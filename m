From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-update-documentation.patch added to -mm tree
Date: Fri, 02 Oct 2015 15:07:02 -0700
Message-ID: <560f0006.dXJ35+tLcGdIgVLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbJBWHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 18:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, corbet@lwn.net, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: update documentation
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-update-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-update-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-update-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: update documentation

%n is no longer just ignored; it results in early return from vsnprintf. 
Also add a request to add test cases for future %p extensions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Martin Kletzander <mkletzan@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |   12 ++++++------
 lib/vsprintf.c                   |    7 ++++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN Documentation/printk-formats.txt~lib-vsprintfc-update-documentation Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-vsprintfc-update-documentation
+++ a/Documentation/printk-formats.txt
@@ -23,6 +23,10 @@ Example:
 
 Reminder: sizeof() result is of type size_t.
 
+The kernel's printf does not support %n. For obvious reasons, floating
+point formats (%e, %f, %g, %a) are also not recognized. Use of any
+unsupported specifier or length qualifier results in a WARN and early
+return from vsnprintf.
 
 Raw pointer value SHOULD be printed with %p. The kernel supports
 the following extended format specifiers for pointer types:
@@ -305,13 +309,9 @@ Command from struct task_struct
 
 	Passed by reference.
 
-Ignored argument:
+If you add other %p extensions, please extend lib/test_printf.c with
+one or more test cases, if at all feasible.
 
-	%n	%n
-
-	The argument passed will be ignored.  In other words, literal "%n" will
-	be in the output and the argument will be considered for next format
-	specifier.
 
 Thank you for your cooperation and attention.
 
diff -puN lib/vsprintf.c~lib-vsprintfc-update-documentation lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-update-documentation
+++ a/lib/vsprintf.c
@@ -1448,7 +1448,6 @@ int kptr_restrict __read_mostly;
  * - 'Cn' For a clock, it prints the name (Common Clock Framework) or address
  *        (legacy clock framework) of the clock
  * - 'Cr' For a clock, it prints the current rate of the clock
- * - 'n' For ignored argument
  *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
@@ -1814,8 +1813,10 @@ qualifier:
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
- * This function follows C99 vsnprintf, but has some extensions:
- * %n is ignored
+ * This function generally follows C99 vsnprintf, but has some
+ * extensions and a few limitations:
+ *
+ * %n is unsupported
  * %p* is handled by pointer()
  *
  * See pointer() or Documentation/printk-formats.txt for more
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

compilerh-add-support-for-function-attribute-assume_aligned.patch
slabh-sprinkle-__assume_aligned-attributes.patch
lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-vsprintfc-update-documentation.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

