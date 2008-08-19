From: akpm@linux-foundation.org
Subject: - kernelh-fix-kernel-doc-for-might_sleep.patch removed from -mm tree
Date: Tue, 19 Aug 2008 15:40:26 -0700
Message-ID: <200808192240.m7JMeQtA010648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYHSWkk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 18:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Uwe.Kleine-Koenig@digi.com, mm-commits@vger.kernel.org


The patch titled
     kernel.h: fix kernel-doc for might_sleep
has been removed from the -mm tree.  Its filename was
     kernelh-fix-kernel-doc-for-might_sleep.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel.h: fix kernel-doc for might_sleep
From: Randy Dunlap <randy.dunlap@oracle.com>

Put the kernel-doc for might_sleep() _immediately_ before the macro (no
intervening lines).  Otherwise kernel-doc complains like so:

Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'file'
Warning(linux-2.6.27-rc3-git2//include/linux/kernel.h:129): No description found for parameter 'line'

because kernel-doc is looking at the wrong function prototype (i.e.,
__might_sleep).  [Yes, I have a todo note to myself to check/warn for that
inconsistency in scripts/kernel-doc.]

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Uwe Kleine-K_nig <Uwe.Kleine-Koenig@digi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kernel.h~kernelh-fix-kernel-doc-for-might_sleep include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-fix-kernel-doc-for-might_sleep
+++ a/include/linux/kernel.h
@@ -115,6 +115,8 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+  void __might_sleep(char *file, int line);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -125,8 +127,6 @@ extern int _cond_resched(void);
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

documentation-describe-bootmem_debug-kernel-parameter.patch
linux-next.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

