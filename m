From: akpm@linux-foundation.org
Subject: - pty-remove-unused-unix98_pty_count-options.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:05 -0700
Message-ID: <200807252301.m6PN151w003681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49734 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbYGYXHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davem@davemloft.net, rpjday@crashcourse.ca, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     pty: remove unused UNIX98_PTY_COUNT options
has been removed from the -mm tree.  Its filename was
     pty-remove-unused-unix98_pty_count-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -298,20 +298,6 @@ config UNIX98_PTYS
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
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

