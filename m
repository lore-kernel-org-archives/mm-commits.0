From: akpm@linux-foundation.org
Subject: + frv-dont-offer-binfmt_flat.patch added to -mm tree
Date: Wed, 21 May 2008 23:25:47 -0700
Message-ID: <200805220625.m4M6Plxu020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYEVG0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dhowells@redhat.com


The patch titled
     frv: don't offer BINFMT_FLAT
has been added to the -mm tree.  Its filename is
     frv-dont-offer-binfmt_flat.patch

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
Subject: frv: don't offer BINFMT_FLAT
From: Adrian Bunk <bunk@kernel.org>

Fix the following compile error:

  CC      fs/binfmt_flat.o
In file included from
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:36:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/flat.h:14:22: error: asm/flat.h: No such file or directory
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'create_flat_tables':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:124: error: implicit declaration of function 'flat_stack_align'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:125: error: implicit declaration of function 'flat_argvp_envp_on_stack'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'calc_reloc':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:347: error: implicit declaration of function 'flat_reloc_valid'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c: In function 'load_flat_file':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:479: error: implicit declaration of function 'flat_old_ram_flag'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:755: error: implicit declaration of function 'flat_set_persistent'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:757: error: implicit declaration of function 'flat_get_relocate_addr'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:765: error: implicit declaration of function 'flat_get_addr_from_rp'
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/binfmt_flat.c:781: error: implicit declaration of function 'flat_put_addr_at_rp'

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig.binfmt~frv-dont-offer-binfmt_flat fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~frv-dont-offer-binfmt_flat
+++ a/fs/Kconfig.binfmt
@@ -42,7 +42,7 @@ config BINFMT_ELF_FDPIC
 
 config BINFMT_FLAT
 	bool "Kernel support for flat binaries"
-	depends on !MMU
+	depends on !MMU && (!FRV || BROKEN)
 	help
 	  Support uClinux FLAT format binaries.
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ibmaem-fix-64-bit-division-on-32-bit-platforms-update.patch
md-proper-extern-for-mdp_major.patch
frv-export-empty_zero_page.patch
linux-next.patch
proper-prototype-for-acpi_processor_tstate_has_changed.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
if-0-ses_match_host.patch
git-watchdog.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
frv-dont-offer-binfmt_flat.patch
remove-include-asm-h8300-keyboardh.patch
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

