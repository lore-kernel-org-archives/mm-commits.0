From: akpm@linux-foundation.org
Subject: [merged] lib-bitmapc-enhance-bitmap-syntax.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:22:57 -0700
Message-ID: <57fe8d91.Uy0kpbqD74CKUC/L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33193 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755972AbcJLTYa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: noamca@mellanox.com, ben@decadent.org.uk, davem@davemloft.net, decot@googlers.com, xinhui@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/bitmap.c: enhance bitmap syntax
has been removed from the -mm tree.  Its filename was
     lib-bitmapc-enhance-bitmap-syntax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: rework documentation]
Link: http://lkml.kernel.org/r/1473579629-4283-1-git-send-email-noamca@mellanox.com
Signed-off-by: Noam Camus <noamca@mellanox.com>
Cc: David Decotigny <decot@googlers.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Pan Xinhui <xinhui@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   50 ++++++++++++++++++--------
 lib/bitmap.c                        |   50 +++++++++++++++++++++++---
 2 files changed, 82 insertions(+), 18 deletions(-)

diff -puN Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~lib-bitmapc-enhance-bitmap-syntax
+++ a/Documentation/kernel-parameters.txt
@@ -33,6 +33,37 @@ can also be entered as
 Double-quotes can be used to protect spaces in values, e.g.:
 	param="spaces in here"
 
+cpu lists:
+----------
+
+Some kernel parameters take a list of CPUs as a value, e.g.  isolcpus,
+nohz_full, irqaffinity, rcu_nocbs.  The format of this list is:
+
+	<cpu number>,...,<cpu number>
+
+or
+
+	<cpu number>-<cpu number>
+	(must be a positive range in ascending order)
+
+or a mixture
+
+<cpu number>,...,<cpu number>-<cpu number>
+
+Note that for the special case of a range one can split the range into equal
+sized groups and for each group use some amount from the beginning of that
+group:
+
+	<cpu number>-cpu number>:<used size>/<group size>
+
+For example one can add to the command line following parameter:
+
+	isolcpus=1,2,10-20,100-2000:2/25
+
+where the final item represents CPUs 100,101,125,126,150,151,...
+
+
+
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
 module. Loadable modules, after being loaded into the running kernel, also
@@ -1789,13 +1820,7 @@ bytes respectively. Such letter suffixes
 			See Documentation/filesystems/nfs/nfsroot.txt.
 
 	irqaffinity=	[SMP] Set the default irq affinity mask
-			Format:
-			<cpu number>,...,<cpu number>
-			or
-			<cpu number>-<cpu number>
-			(must be a positive range in ascending order)
-			or a mixture
-			<cpu number>,...,<cpu number>-<cpu number>
+			The argument is a cpu list, as described above.
 
 	irqfixup	[HW]
 			When an interrupt is not handled search all handlers
@@ -1812,13 +1837,7 @@ bytes respectively. Such letter suffixes
 			Format: <RDP>,<reset>,<pci_scan>,<verbosity>
 
 	isolcpus=	[KNL,SMP] Isolate CPUs from the general scheduler.
-			Format:
-			<cpu number>,...,<cpu number>
-			or
-			<cpu number>-<cpu number>
-			(must be a positive range in ascending order)
-			or a mixture
-			<cpu number>,...,<cpu number>-<cpu number>
+			The argument is a cpu list, as described above.
 
 			This option can be used to specify one or more CPUs
 			to isolate from the general SMP balancing and scheduling
@@ -2680,6 +2699,7 @@ bytes respectively. Such letter suffixes
 			Default: on
 
 	nohz_full=	[KNL,BOOT]
+			The argument is a cpu list, as described above.
 			In kernels built with CONFIG_NO_HZ_FULL=y, set
 			the specified list of CPUs whose tick will be stopped
 			whenever possible. The boot CPU will be forced outside
@@ -3285,6 +3305,8 @@ bytes respectively. Such letter suffixes
 			See Documentation/blockdev/ramdisk.txt.
 
 	rcu_nocbs=	[KNL]
+			The argument is a cpu list, as described above.
+
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
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


