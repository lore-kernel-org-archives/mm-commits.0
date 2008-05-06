From: akpm@linux-foundation.org
Subject: + proper-prototype-for-acpi_processor_tstate_has_changed.patch added to -mm tree
Date: Tue, 06 May 2008 11:37:10 -0700
Message-ID: <200805061837.m46IbAtm021282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758052AbYEFShX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, lenb@kernel.org


The patch titled
     proper prototype for acpi_processor_tstate_has_changed()
has been added to the -mm tree.  Its filename is
     proper-prototype-for-acpi_processor_tstate_has_changed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-udf.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
reiser4.patch
remove-is_tty.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
make-pnp_add_card_id-static.patch
mfd-sm501c-if-0-unused-functions.patch
pcmcia-kill-in_card_services.patch
video-sis-remove-compat-code.patch
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
parport-sharec-proper-externs.patch
remove-include-asm-h8300-keyboardh.patch
proper-spawn_ksoftirqd-prototype.patch
proper-pidhashmap_init-prototypes.patch
mm-migratec-should-include-linux-syscallsh.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
minix-remove-no_truncate-code.patch
remove-the-v850-port.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
if-0-hpet_unregister.patch
tpm_biosc-make-2-structs-static.patch
proper-extern-for-mwave_s_mdd.patch
xtensa-remove-the-nonexisting-highmem-support.patch
serial-8250_gscc-add-module_license.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
unexport-proc_clear_tty.patch
unexport-uts_sem.patch

