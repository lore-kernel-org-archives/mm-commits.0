From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch removed
 from -mm tree
Date: Fri, 04 Sep 2015 15:26:49 -0700
Message-ID: <55ea1aa9.mXaaQRoJ5TqOeTKK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264AbbIDW0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:26:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix
has been removed from the -mm tree.  Its filename was
     watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch

This patch was dropped because it was folded into watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix

fix build with CONFIG_LOCKUP_DETECTOR=m

Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nmi.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/linux/nmi.h~watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix
+++ a/include/linux/nmi.h
@@ -80,6 +80,15 @@ extern int proc_watchdog_cpumask(struct
 				 void __user *, size_t *, loff_t *);
 extern int watchdog_suspend(void);
 extern void watchdog_resume(void);
+#else
+static inline int watchdog_suspend(void)
+{
+	return 0;
+}
+
+static inline void watchdog_resume(void)
+{
+}
 #endif
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-activate-syscall-fix-2.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch

