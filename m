From: akpm@linux-foundation.org
Subject: - uml-defconfig-tweaks.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:57 -0800
Message-ID: <200802052238.m15MccjK012966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760782AbYBEWlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: defconfig tweaks
has been removed from the -mm tree.  Its filename was
     uml-defconfig-tweaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: defconfig tweaks
From: Jeff Dike <jdike@addtoit.com>

Tweak the UML defconfig -
      we probably don't need 256 old-style ptys - this slows down udev
noticably
      enable hostfs
      disable slab debugging - another noticable performance hit

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/defconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/um/defconfig~uml-defconfig-tweaks arch/um/defconfig
--- a/arch/um/defconfig~uml-defconfig-tweaks
+++ a/arch/um/defconfig
@@ -77,7 +77,7 @@ CONFIG_LD_SCRIPT_DYN=y
 CONFIG_NET=y
 CONFIG_BINFMT_ELF=y
 CONFIG_BINFMT_MISC=m
-# CONFIG_HOSTFS is not set
+CONFIG_HOSTFS=y
 # CONFIG_HPPFS is not set
 CONFIG_MCONSOLE=y
 CONFIG_MAGIC_SYSRQ=y
@@ -188,7 +188,7 @@ CONFIG_CON_CHAN="xterm"
 CONFIG_SSL_CHAN="pts"
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_LEGACY_PTY_COUNT=32
 # CONFIG_WATCHDOG is not set
 CONFIG_UML_SOUND=m
 CONFIG_SOUND=m
@@ -508,7 +508,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
-CONFIG_DEBUG_SLAB=y
+# CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_SLAB_LEAK is not set
 # CONFIG_DEBUG_MUTEXES is not set
 # CONFIG_DEBUG_SPINLOCK is not set
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
