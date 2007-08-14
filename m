From: akpm@linux-foundation.org
Subject: - i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:47 -0700
Message-ID: <200708141913.l7EJDlC9016538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47800 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765140AbXHNTUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     i386: deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
has been removed from the -mm tree.  Its filename was
     i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/vmi.c~i386-deactivate-the-test-for-the-dead-config_debug_page_type arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~i386-deactivate-the-test-for-the-dead-config_debug_page_type
+++ a/arch/i386/kernel/vmi.c
@@ -235,7 +235,7 @@ static void vmi_nop(void)
 {
 }
 
-#ifdef CONFIG_DEBUG_PAGE_TYPE
+#if 0 /* debug page type */
 
 #ifdef CONFIG_X86_PAE
 #define MAX_BOOT_PTS (2048+4+1)
@@ -336,7 +336,7 @@ static void vmi_check_page_type(u32 pfn,
 #else
 #define vmi_set_page_type(p,t) do { } while (0)
 #define vmi_check_page_type(p,t) do { } while (0)
-#endif
+#endif /* debug page type */
 
 #ifdef CONFIG_HIGHPTE
 static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
