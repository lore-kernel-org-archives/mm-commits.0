From: akpm@linux-foundation.org
Subject: - uml-add-back-config_hz.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:21 -0800
Message-ID: <200802052238.m15Mc2fh012920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762622AbYBEWmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, hpa@zytor.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add back CONFIG_HZ
has been removed from the -mm tree.  Its filename was
     uml-add-back-config_hz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: add back CONFIG_HZ
From: Jeff Dike <jdike@addtoit.com>

avoid-overflows-in-kernel-timec.patch makes CONFIG_HZ necessary for a
successful build.  UML lacks a definition, so this patch adds one.  It also
changes the hard-wired definition of HZ to CONFIG_HZ.

Note: this patch is a good idea even in the absence of hpa's time fixes.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig        |    4 ++++
 include/asm-um/param.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/um/Kconfig~uml-add-back-config_hz arch/um/Kconfig
--- a/arch/um/Kconfig~uml-add-back-config_hz
+++ a/arch/um/Kconfig
@@ -68,6 +68,10 @@ config IRQ_RELEASE_METHOD
 	bool
 	default y
 
+config HZ
+	int
+	default 100
+
 menu "UML-specific options"
 
 config STATIC_LINK
diff -puN include/asm-um/param.h~uml-add-back-config_hz include/asm-um/param.h
--- a/include/asm-um/param.h~uml-add-back-config_hz
+++ a/include/asm-um/param.h
@@ -10,7 +10,7 @@
 #define MAXHOSTNAMELEN  64      /* max length of hostname */
 
 #ifdef __KERNEL__
-#define HZ 100
+#define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
 #endif
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
