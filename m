From: akpm@linux-foundation.org
Subject: [merged]
 lib-documentation-synchronize-%p-formatting-documentation.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:48 -0800
Message-ID: <5640f7ec.PRfthLOcBKwHZeOj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbKITpt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkletzan@redhat.com, andriy.shevchenko@linux.intel.com, corbet@lwn.net, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: synchronize %p formatting documentation
has been removed from the -mm tree.  Its filename was
     lib-documentation-synchronize-%p-formatting-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Martin Kletzander <mkletzan@redhat.com>
Subject: printk: synchronize %p formatting documentation

Move all pointer-formatting documentation to one place in the code and one
place in the documentation instead of keeping it in three places with
different level of completeness.  Documentation/printk-formats.txt has
detailed information about each modifier, docstring above pointer() has
short descriptions of them (as that is the function dealing with %p) and
docstring above vsprintf() is removed as redundant.  Both docstrings in
the code that were modified are updated with a reminder of updating the
documentation upon any further change.

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Martin Kletzander <mkletzan@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   29 +++++++++++++++++++++
 lib/vsprintf.c                   |   40 +++++------------------------
 2 files changed, 37 insertions(+), 32 deletions(-)

diff -puN Documentation/printk-formats.txt~lib-documentation-synchronize-%p-formatting-documentation Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-documentation-synchronize-%p-formatting-documentation
+++ a/Documentation/printk-formats.txt
@@ -119,6 +119,7 @@ Raw buffer as an escaped string:
 	If field width is omitted the 1 byte only will be escaped.
 
 Raw buffer as a hex string:
+
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
 	%*phD	00-01-02- ... -3f
@@ -234,6 +235,7 @@ UUID/GUID addresses:
 	Passed by reference.
 
 dentry names:
+
 	%pd{,2,3,4}
 	%pD{,2,3,4}
 
@@ -256,6 +258,8 @@ struct va_format:
 		va_list *va;
 	};
 
+	Implements a "recursive vsnprintf".
+
 	Do not use this feature without some mechanism to verify the
 	correctness of the format string and va_list arguments.
 
@@ -284,6 +288,31 @@ bitmap and its derivatives such as cpuma
 
 	Passed by reference.
 
+Network device features:
+
+	%pNF	0x000000000000c000
+
+	For printing netdev_features_t.
+
+	Passed by reference.
+
+Command from struct task_struct
+
+	%pT	ls
+
+	For printing executable name excluding path from struct
+	task_struct.
+
+	Passed by reference.
+
+Ignored argument:
+
+	%n	%n
+
+	The argument passed will be ignored.  In other words, literal "%n" will
+	be in the output and the argument will be considered for next format
+	specifier.
+
 Thank you for your cooperation and attention.
 
 
diff -puN lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation lib/vsprintf.c
--- a/lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation
+++ a/lib/vsprintf.c
@@ -1448,6 +1448,9 @@ int kptr_restrict __read_mostly;
  * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
  *        (legacy clock framework) of the clock
  * - 'Cr' For a clock, it prints the current rate of the clock
+ * - 'n' For ignored argument
+ *
+ * ** Please update also Documentation/printk-formats.txt when making changes **
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1812,40 +1815,13 @@ qualifier:
  * @args: Arguments for the format string
  *
  * This function follows C99 vsnprintf, but has some extensions:
- * %pS output the name of a text symbol with offset
- * %ps output the name of a text symbol without offset
- * %pF output the name of a function pointer with its offset
- * %pf output the name of a function pointer without its offset
- * %pB output the name of a backtrace symbol with its offset
- * %pR output the address range in a struct resource with decoded flags
- * %pr output the address range in a struct resource with raw flags
- * %pb output the bitmap with field width as the number of bits
- * %pbl output the bitmap as range list with field width as the number of bits
- * %pM output a 6-byte MAC address with colons
- * %pMR output a 6-byte MAC address with colons in reversed order
- * %pMF output a 6-byte MAC address with dashes
- * %pm output a 6-byte MAC address without colons
- * %pmR output a 6-byte MAC address without colons in reversed order
- * %pI4 print an IPv4 address without leading zeros
- * %pi4 print an IPv4 address with leading zeros
- * %pI6 print an IPv6 address with colons
- * %pi6 print an IPv6 address without colons
- * %pI6c print an IPv6 address as specified by RFC 5952
- * %pIS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
- * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
- * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
- *   case.
- * %*pE[achnops] print an escaped buffer
- * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
- *           bytes of the input)
- * %pC output the name (Common Clock Framework) or address (legacy clock
- *     framework) of a clock
- * %pCn output the name (Common Clock Framework) or address (legacy clock
- *      framework) of a clock
- * %pCr output the current rate of a clock
  * %n is ignored
+ * %p* is handled by pointer()
+ *
+ * See pointer() or Documentation/printk-formats.txt for more
+ * extensive description.
  *
- * ** Please update Documentation/printk-formats.txt when making changes **
+ * ** Please update the documentation in both places when making changes **
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
_

Patches currently in -mm which might be from mkletzan@redhat.com are


