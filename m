From: akpm@linux-foundation.org
Subject: + kernelh-fix-might_sleep-kernel-doc.patch added to -mm tree
Date: Tue, 28 Oct 2008 13:08:49 -0700
Message-ID: <200810282008.m9SK8nvV012357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbYJ1UJN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 16:09:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, Uwe.Kleine-Koenig@digi.com


The patch titled
     kernel.h: fix might_sleep kernel-doc
has been added to the -mm tree.  Its filename is
     kernelh-fix-might_sleep-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: fix might_sleep kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Put the kernel-doc for might_sleep() _immediately_ before the macro
(no intervening lines).  Otherwise kernel-doc complains like so:

Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'file'
Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'line'

because kernel-doc is looking at the wrong function prototype (i.e.,
__might_sleep).  [Yes, I have a todo note to myself to check/warn for that
inconsistency in scripts/kernel-doc.]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~kernelh-fix-might_sleep-kernel-doc include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-fix-might_sleep-kernel-doc
+++ a/include/linux/kernel.h
@@ -116,6 +116,8 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+  void __might_sleep(char *file, int line);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -126,8 +128,6 @@ extern int _cond_resched(void);
  * be bitten later when the calling function happens to sleep when it is not
  * supposed to.
  */
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
 # define might_sleep() \
 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
 #else
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
fs-remove-excess-kernel-doc.patch
kernelh-fix-might_sleep-kernel-doc.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

