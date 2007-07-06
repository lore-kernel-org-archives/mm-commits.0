From: akpm@linux-foundation.org
Subject: + i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch added to -mm tree
Date: Fri, 06 Jul 2007 11:08:17 -0700
Message-ID: <200707061808.l66I8HQd011724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758818AbXGFSIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 14:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, zach@vmware.com


The patch titled
     i386: deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
has been added to the -mm tree.  Its filename is
     i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: deactivate the test for the dead CONFIG_DEBUG_PAGE_TYPE
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
sound-remove-unreferenced-header-file-include-sound-wavefront_fxh.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
usb-remove-makefile-reference-to-obsolete-ohci_at91.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
