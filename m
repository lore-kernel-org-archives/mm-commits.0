From: akpm@linux-foundation.org
Subject: + lib-bitmapc-enhance-bitmap-syntax.patch added to -mm tree
Date: Tue, 13 Sep 2016 15:55:40 -0700
Message-ID: <57d883ec.mRFV1YmfSRJtdH2R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36333 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755632AbcIMWzl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2016 18:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: noamca@mellanox.com, ben@decadent.org.uk, davem@davemloft.net, decot@googlers.com, xinhui@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: enhance bitmap syntax
has been added to the -mm tree.  Its filename is
     lib-bitmapc-enhance-bitmap-syntax.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-bitmapc-enhance-bitmap-syntax.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-bitmapc-enhance-bitmap-syntax.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Noam Camus <noamca@mellanox.com>
Subject: lib/bitmap.c: enhance bitmap syntax

Today there are platforms with many CPUs (up to 4K).  Trying to boot only
part of the CPUs may result in too long string.

For example lets take NPS platform that is part of arch/arc.  This
platform have SMP system with 256 cores each with 16 HW threads (SMT
machine) where HW thread appears as CPU to the kernel.  In this example
there is total of 4K CPUs.  When one tries to boot only part of the HW
threads from each core the string representing the map may be long...  For
example if for sake of performance we decided to boot only first half of
HW threads of each core the map will look like:
0-7,16-23,32-39,...,4080-4087

This patch introduce new syntax to accommodate with such use case.  I
added an optional postfix to a range of CPUs which will choose according
to given modulo the desired range of reminders i.e.:

    <cpus range>:sed_size/group_size

For example, above map can be described in new syntax like this:
0-4095:8/16

Note that this patch is backward compatible with current syntax.

Link: http://lkml.kernel.org/r/1473579629-4283-1-git-send-email-noamca@mellanox.com
Signed-off-by: Noam Camus <noamca@mellanox.com>
Cc: David Decotigny <decot@googlers.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Pan Xinhui <xinhui@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   15 +++++++
 lib/bitmap.c                        |   50 +++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 4 deletions(-)

diff -puN Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax
+++ a/Documentation/kernel-parameters.txt
@@ -33,6 +33,21 @@ can also be entered as
 Double-quotes can be used to protect spaces in values, e.g.:
 	param="spaces in here"
 
+Some of the kernel parameters takes list of CPUs as value e.g.:
+isolcpus, task_isolation, nohz_full, irqaffinity, rcu_nocbs.
+The format of this list is:
+<cpu number>,...,<cpu number>
+or
+<cpu number>-<cpu number>
+(must be a positive range in ascending order)
+or a mixture
+<cpu number>,...,<cpu number>-<cpu number>
+Note that for special case of range one can split range into equal size of groups
+and for each group to use some amount form the begin of that group.
+<cpu number>-cpu number>:<used size>/<group size>
+For example one can add to its command line following parameter:
+isolcpus=1,2,10-20,100-2000:2/25
+
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
 module. Loadable modules, after being loaded into the running kernel, also
diff -puN lib/bitmap.c~lib-bitmapc-enhance-bitmap-syntax lib/bitmap.c
--- a/lib/bitmap.c~lib-bitmapc-enhance-bitmap-syntax
+++ a/lib/bitmap.c
@@ -496,6 +496,11 @@ EXPORT_SYMBOL(bitmap_print_to_pagebuf);
  * ranges.  Consecutively set bits are shown as two hyphen-separated
  * decimal numbers, the smallest and largest bit numbers set in
  * the range.
+ * Optionally each range can be postfixed to denote that only parts of it
+ * should be set. The range will divided to groups of specific size.
+ * From each group will be used only defined amount of bits.
+ * Syntax: range:used_size/group_size
+ * Example: 0-1023:2/256 ==> 0,1,256,257,512,513,768,769
  *
  * Returns 0 on success, -errno on invalid input strings.
  * Error values:
@@ -507,16 +512,20 @@ static int __bitmap_parselist(const char
 		int is_user, unsigned long *maskp,
 		int nmaskbits)
 {
-	unsigned a, b;
+	unsigned int a, b, old_a, old_b;
+	unsigned int group_size, used_size;
 	int c, old_c, totaldigits, ndigits;
 	const char __user __force *ubuf = (const char __user __force *)buf;
-	int at_start, in_range;
+	int at_start, in_range, in_partial_range;
 
 	totaldigits = c = 0;
+	old_a = old_b = 0;
+	group_size = used_size = 0;
 	bitmap_zero(maskp, nmaskbits);
 	do {
 		at_start = 1;
 		in_range = 0;
+		in_partial_range = 0;
 		a = b = 0;
 		ndigits = totaldigits;
 
@@ -547,6 +556,24 @@ static int __bitmap_parselist(const char
 			if ((totaldigits != ndigits) && isspace(old_c))
 				return -EINVAL;
 
+			if (c == '/') {
+				used_size = a;
+				at_start = 1;
+				in_range = 0;
+				a = b = 0;
+				continue;
+			}
+
+			if (c == ':') {
+				old_a = a;
+				old_b = b;
+				at_start = 1;
+				in_range = 0;
+				in_partial_range = 1;
+				a = b = 0;
+				continue;
+			}
+
 			if (c == '-') {
 				if (at_start || in_range)
 					return -EINVAL;
@@ -567,15 +594,30 @@ static int __bitmap_parselist(const char
 		}
 		if (ndigits == totaldigits)
 			continue;
+		if (in_partial_range) {
+			group_size = a;
+			a = old_a;
+			b = old_b;
+			old_a = old_b = 0;
+		}
 		/* if no digit is after '-', it's wrong*/
 		if (at_start && in_range)
 			return -EINVAL;
-		if (!(a <= b))
+		if (!(a <= b) || !(used_size <= group_size))
 			return -EINVAL;
 		if (b >= nmaskbits)
 			return -ERANGE;
 		while (a <= b) {
-			set_bit(a, maskp);
+			if (in_partial_range) {
+				static int pos_in_group = 1;
+
+				if (pos_in_group <= used_size)
+					set_bit(a, maskp);
+
+				if (a == b || ++pos_in_group > group_size)
+					pos_in_group = 1;
+			} else
+				set_bit(a, maskp);
 			a++;
 		}
 	} while (buflen && c == ',');
_

Patches currently in -mm which might be from noamca@mellanox.com are

lib-bitmapc-enhance-bitmap-syntax.patch

