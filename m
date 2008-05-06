From: akpm@linux-foundation.org
Subject: + parport-sharec-proper-externs.patch added to -mm tree
Date: Tue, 06 May 2008 11:36:32 -0700
Message-ID: <200805061836.m46IaWXj021218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754386AbYEFSgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 14:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     parport/share.c: proper externs
has been added to the -mm tree.  Its filename is
     parport-sharec-proper-externs.patch

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
Subject: parport/share.c: proper externs
From: Adrian Bunk <bunk@kernel.org>

This patch adds proper externs for parport_default_timeslice and
parport_default_spintime in include/linux/parport.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/procfs.c |    3 ---
 include/linux/parport.h  |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/parport/procfs.c~parport-sharec-proper-externs drivers/parport/procfs.c
--- a/drivers/parport/procfs.c~parport-sharec-proper-externs
+++ a/drivers/parport/procfs.c
@@ -429,9 +429,6 @@ struct parport_default_sysctl_table
 	ctl_table dev_dir[2];
 };
 
-extern unsigned long parport_default_timeslice;
-extern int parport_default_spintime;
-
 static struct parport_default_sysctl_table
 parport_default_sysctl_table = {
 	.sysctl_header	= NULL,
diff -puN include/linux/parport.h~parport-sharec-proper-externs include/linux/parport.h
--- a/include/linux/parport.h~parport-sharec-proper-externs
+++ a/include/linux/parport.h
@@ -560,5 +560,8 @@ extern int parport_device_proc_unregiste
 
 #endif /*  !CONFIG_PARPORT_NOT_PC  */
 
+extern unsigned long parport_default_timeslice;
+extern int parport_default_spintime;
+
 #endif /* __KERNEL__ */
 #endif /* _PARPORT_H_ */
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

