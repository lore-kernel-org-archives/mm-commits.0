From: akpm@linux-foundation.org
Subject: + md-proper-extern-for-mdp_major.patch added to -mm tree
Date: Sun, 18 May 2008 18:27:27 -0700
Message-ID: <200805190127.m4J1RRsT009549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993AbYESB1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 May 2008 21:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, neilb@suse.de


The patch titled
     md: proper extern for mdp_major
has been added to the -mm tree.  Its filename is
     md-proper-extern-for-mdp_major.patch

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
Subject: md: proper extern for mdp_major
From: Adrian Bunk <bunk@kernel.org>

This patch adds a proper extern for mdp_major in include/linux/raid/md.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/raid/md.h |    2 ++
 init/do_mounts_md.c     |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/raid/md.h~md-proper-extern-for-mdp_major include/linux/raid/md.h
--- a/include/linux/raid/md.h~md-proper-extern-for-mdp_major
+++ a/include/linux/raid/md.h
@@ -72,6 +72,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+extern int mdp_major;
+
 extern int register_md_personality (struct mdk_personality *p);
 extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
diff -puN init/do_mounts_md.c~md-proper-extern-for-mdp_major init/do_mounts_md.c
--- a/init/do_mounts_md.c~md-proper-extern-for-mdp_major
+++ a/init/do_mounts_md.c
@@ -24,7 +24,6 @@ static struct {
 
 static int md_setup_ents __initdata;
 
-extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
drm-make-drm_minors_cleanup-static.patch
git-input.patch
nfs-make-nfs4_drop_state_owner-static.patch
show_schedstat-fix-memleak.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
remove-include-asm-h8300-keyboardh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
serial-8250_gscc-add-module_license.patch
mfd-sm501c-if-0-unused-functions.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
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
make-struct-mpt_proc_root_dir-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
reiser4.patch

