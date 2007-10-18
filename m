From: akpm@linux-foundation.org
Subject: - allow-disabling-dnotify-without-embedded.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:29 -0700
Message-ID: <200710180656.l9I6uT5Q030705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759902AbXJRHRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     allow disabling DNOTIFY without EMBEDDED
has been removed from the -mm tree.  Its filename was
     allow-disabling-dnotify-without-embedded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: allow disabling DNOTIFY without EMBEDDED
From: Adrian Bunk <bunk@kernel.org>

Allow disabling DNOTIFY with CONFIG_EMBEDDED=n.

I'm currently running a kernel with dnotify disabled and I haven't run into
any problem.  Is there any popular application left that breaks without
dnotify support in the kernel?

Note that this patch does not remove dnotify support, it still defaults to
"y", and the help text recommends enabling it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/Kconfig~allow-disabling-dnotify-without-embedded fs/Kconfig
--- a/fs/Kconfig~allow-disabling-dnotify-without-embedded
+++ a/fs/Kconfig
@@ -555,7 +555,7 @@ config QUOTACTL
 	default y
 
 config DNOTIFY
-	bool "Dnotify support" if EMBEDDED
+	bool "Dnotify support"
 	default y
 	help
 	  Dnotify is a directory-based per-fd file change notification system
@@ -563,7 +563,7 @@ config DNOTIFY
 	  superior alternatives, but some applications may still rely on
 	  dnotify.
 
-	  Because of this, if unsure, say Y.
+	  If unsure, say Y.
 
 config AUTOFS_FS
 	tristate "Kernel automounter support"
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-nfs-make-nfs_wb_page_priority-static.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
make-kernel-power-maincsuspend_enter-static.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
