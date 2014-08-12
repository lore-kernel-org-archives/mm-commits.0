From: akpm@linux-foundation.org
Subject: [merged]
 scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:40 -0700
Message-ID: <53ea6df4.EP7s9JNKoBP1EX4Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:36309 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaHLTll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:41 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1916596obb.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, Gilles.Muller@lip6.fr, Julia.Lawall@lip6.fr, elfring@users.sourceforge.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/coccinelle/free: add NULL test before freeing functions
has been removed from the -mm tree.  Its filename was
     scripts-coccinelle-free-add-null-test-before-freeing-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: scripts/coccinelle/free: add NULL test before freeing functions

Warns or generates patch for NULL check before the following functions:

kfree
usb_free_urb
debugfs_remove
debugfs_remove_recursive

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Gilles Muller <Gilles.Muller@lip6.fr>
Cc: Joe Perches <joe@perches.com>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/coccinelle/free/ifnullfree.cocci |   53 +++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff -puN /dev/null scripts/coccinelle/free/ifnullfree.cocci
--- /dev/null
+++ a/scripts/coccinelle/free/ifnullfree.cocci
@@ -0,0 +1,53 @@
+/// NULL check before some freeing functions is not needed.
+///
+/// Based on checkpatch warning
+/// "kfree(NULL) is safe this check is probably not required"
+/// and kfreeaddr.cocci by Julia Lawall.
+///
+/// Comments: -
+/// Options: --no-includes --include-headers
+
+virtual patch
+virtual org
+virtual report
+virtual context
+
+@r2 depends on patch@
+expression E;
+@@
+- if (E)
+(
+-	kfree(E);
++ kfree(E);
+|
+-	debugfs_remove(E);
++ debugfs_remove(E);
+|
+-	debugfs_remove_recursive(E);
++ debugfs_remove_recursive(E);
+|
+-	usb_free_urb(E);
++ usb_free_urb(E);
+)
+
+@r depends on context || report || org @
+expression E;
+position p;
+@@
+
+* if (E)
+*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
+
+@script:python depends on org@
+p << r.p;
+@@
+
+cocci.print_main("NULL check before that freeing function is not needed", p)
+
+@script:python depends on report@
+p << r.p;
+@@
+
+msg = "WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values."
+coccilib.report.print_report(p[0], msg)
+
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

