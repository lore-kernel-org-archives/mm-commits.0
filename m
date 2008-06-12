From: akpm@linux-foundation.org
Subject: - proper-prototype-for-acpi_processor_tstate_has_changed.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:35 -0700
Message-ID: <200806122036.m5CKaZU1005340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525AbYFLUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proper prototype for acpi_processor_tstate_has_changed()
has been removed from the -mm tree.  Its filename was
     proper-prototype-for-acpi_processor_tstate_has_changed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proper prototype for acpi_processor_tstate_has_changed()
From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper prototype for acpi_processor_tstate_has_changed()
in include/acpi/processor.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_core.c |    1 -
 include/acpi/processor.h      |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_core.c~proper-prototype-for-acpi_processor_tstate_has_changed drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~proper-prototype-for-acpi_processor_tstate_has_changed
+++ a/drivers/acpi/processor_core.c
@@ -86,7 +86,6 @@ static int acpi_processor_info_open_fs(s
 static void acpi_processor_notify(acpi_handle handle, u32 event, void *data);
 static acpi_status acpi_processor_hotadd_init(acpi_handle handle, int *p_cpu);
 static int acpi_processor_handle_eject(struct acpi_processor *pr);
-extern int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
 
 
 static const struct acpi_device_id processor_device_ids[] = {
diff -puN include/acpi/processor.h~proper-prototype-for-acpi_processor_tstate_has_changed include/acpi/processor.h
--- a/include/acpi/processor.h~proper-prototype-for-acpi_processor_tstate_has_changed
+++ a/include/acpi/processor.h
@@ -319,6 +319,7 @@ static inline int acpi_processor_ppc_has
 #endif				/* CONFIG_CPU_FREQ */
 
 /* in processor_throttling.c */
+int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
 int acpi_processor_get_throttling_info(struct acpi_processor *pr);
 extern int acpi_processor_set_throttling(struct acpi_processor *pr, int state);
 extern struct file_operations acpi_processor_throttling_fops;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
remove-is_tty.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

