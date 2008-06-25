From: akpm@linux-foundation.org
Subject: + pty-remove-unused-unix98_pty_count-options.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:27:11 -0700
Message-ID: <200806252127.m5PLRB2T027694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbYFYVeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:34:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, davem@davemloft.net, rpjday@crashcourse.ca, ysato@users.sourceforge.jp


The patch titled
     pty: remove unused UNIX98_PTY_COUNT options
has been added to the -mm tree.  Its filename is
     pty-remove-unused-unix98_pty_count-options.patch

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
Subject: pty: remove unused UNIX98_PTY_COUNT options
From: Adrian Bunk <bunk@kernel.org>

The h8300 and sparc options somehow survived when the code stopped using
CONFIG_UNIX98_PTY_COUNT.

Reviewed-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig |   14 --------------
 arch/sparc/Kconfig |   14 --------------
 2 files changed, 28 deletions(-)

diff -puN arch/h8300/Kconfig~pty-remove-unused-unix98_pty_count-options arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~pty-remove-unused-unix98_pty_count-options
+++ a/arch/h8300/Kconfig
@@ -203,20 +203,6 @@ config UNIX98_PTYS
 	  Read the instructions in <file:Documentation/Changes> pertaining to
 	  pseudo terminals. It's safe to say N.
 
-config UNIX98_PTY_COUNT
-	int "Maximum number of Unix98 PTYs in use (0-2048)"
-	depends on UNIX98_PTYS
-	default "256"
-	help
-	  The maximum number of Unix98 PTYs that can be used at any one time.
-	  The default is 256, and should be enough for desktop systems. Server
-	  machines which support incoming telnet/rlogin/ssh connections and/or
-	  serve several X terminals may want to increase this: every incoming
-	  connection and every xterm uses up one PTY.
-
-	  When not in use, each additional set of 256 PTYs occupy
-	  approximately 8 KB of kernel memory on 32-bit architectures.
-
 source "drivers/char/pcmcia/Kconfig"
 
 source "drivers/serial/Kconfig"
diff -puN arch/sparc/Kconfig~pty-remove-unused-unix98_pty_count-options arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~pty-remove-unused-unix98_pty_count-options
+++ a/arch/sparc/Kconfig
@@ -283,20 +283,6 @@ config UNIX98_PTYS
 	  Read the instructions in <file:Documentation/Changes> pertaining to
 	  pseudo terminals. It's safe to say N.
 
-config UNIX98_PTY_COUNT
-	int "Maximum number of Unix98 PTYs in use (0-2048)"
-	depends on UNIX98_PTYS
-	default "256"
-	help
-	  The maximum number of Unix98 PTYs that can be used at any one time.
-	  The default is 256, and should be enough for desktop systems. Server
-	  machines which support incoming telnet/rlogin/ssh connections and/or
-	  serve several X terminals may want to increase this: every incoming
-	  connection and every xterm uses up one PTY.
-
-	  When not in use, each additional set of 256 PTYs occupy
-	  approximately 8 KB of kernel memory on 32-bit architectures.
-
 endmenu
 
 source "fs/Kconfig"
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
mm-make-register_page_bootmem_info_section-static.patch
remove-include-asm-h8300-keyboardh.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
proper-spawn_ksoftirqd-prototype.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
pty-remove-unused-unix98_pty_count-options.patch
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

