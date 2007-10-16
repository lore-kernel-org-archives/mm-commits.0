From: akpm@linux-foundation.org
Subject: - use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 15:12:07 -0700
Message-ID: <200710162212.l9GMC7KM020282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbXJPWMt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 18:12:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, chrisw@sous-sol.org, mm-commits@vger.kernel.org


The patch titled
     make do_restart_poll() static
has been removed from the -mm tree.  Its filename was
     use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch

This patch was dropped because it was folded into use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch

------------------------------------------------------
Subject: make do_restart_poll() static
From: Adrian Bunk <bunk@kernel.org>

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
>...
>  The infamous misc
>...

do_restart_poll() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix fs/select.c
--- a/fs/select.c~use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix
+++ a/fs/select.c
@@ -714,7 +714,7 @@ out_fds:
 	return err;
 }
 
-long do_restart_poll(struct restart_block *restart_block)
+static long do_restart_poll(struct restart_block *restart_block)
 {
 	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
 	int nfds = restart_block->arg1;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
