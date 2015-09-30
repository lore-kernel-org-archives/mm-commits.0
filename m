From: akpm@linux-foundation.org
Subject: +
 lib-documentation-synchronize-%p-formatting-documentation-fix.patch added
 to -mm tree
Date: Wed, 30 Sep 2015 14:32:39 -0700
Message-ID: <560c54f7.qANjewnb3m7EN09l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbbI3Vck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkletzan@redhat.com, andriy.shevchenko@linux.intel.com, corbet@lwn.net, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-documentation-synchronize-%p-formatting-documentation-fix
has been added to the -mm tree.  Its filename is
     lib-documentation-synchronize-%p-formatting-documentation-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-documentation-synchronize-%25p-formatting-documentation-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-documentation-synchronize-%25p-formatting-documentation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Kletzander <mkletzan@redhat.com>
Subject: lib-documentation-synchronize-%p-formatting-documentation-fix

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    6 ++++--
 lib/vsprintf.c                   |   13 ++++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff -puN Documentation/printk-formats.txt~lib-documentation-synchronize-%p-formatting-documentation-fix Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~lib-documentation-synchronize-%p-formatting-documentation-fix
+++ a/Documentation/printk-formats.txt
@@ -307,9 +307,11 @@ Command from struct task_struct
 
 Ignored argument:
 
-	%pn
+	%n	%n
 
-	The argument passed will be ignored.
+	The argument passed will be ignored.  In other words, literal "%n" will
+	be in the output and the argument will be considered for next format
+	specifier.
 
 Thank you for your cooperation and attention.
 
diff -puN lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation-fix lib/vsprintf.c
--- a/lib/vsprintf.c~lib-documentation-synchronize-%p-formatting-documentation-fix
+++ a/lib/vsprintf.c
@@ -1450,7 +1450,7 @@ int kptr_restrict __read_mostly;
  * - 'Cr' For a clock, it prints the current rate of the clock
  * - 'n' For ignored argument
  *
- * ** Please update Documentation/printk-formats.txt when making changes **
+ * ** Please update also Documentation/printk-formats.txt when making changes **
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1814,11 +1814,14 @@ qualifier:
  * @fmt: The format string to use
  * @args: Arguments for the format string
  *
- * This function follows C99 vsnprintf, but has some extensions.  See
- * pointer() or Documentation/printk-formats.txt for all format
- * specifiers.
+ * This function follows C99 vsnprintf, but has some extensions:
+ * %n is ignored
+ * %p* is handled by pointer()
  *
- * ** Please update the documentation when making changes **
+ * See pointer() or Documentation/printk-formats.txt for more
+ * extensive description.
+ *
+ * ** Please update the documentation on both places when making changes **
  *
  * The return value is the number of characters which would
  * be generated for the given input, excluding the trailing
_

Patches currently in -mm which might be from mkletzan@redhat.com are

lib-documentation-synchronize-%p-formatting-documentation.patch
lib-documentation-synchronize-%p-formatting-documentation-fix.patch

