From: akpm@linux-foundation.org
Subject: - update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch removed from -mm tree
Date: Sun, 29 Jul 2007 00:18:51 -0700
Message-ID: <200707290718.l6T7IpIg013410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759709AbXG2HTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, ak@suse.de, alan@lxorguk.ukuu.org.uk, hidehiro.kawai.ez@hitachi.com, mm-commits@vger.kernel.org


The patch titled
     update coredump path in kernel to not check coredump rlim if core_pattern is a pipe
has been removed from the -mm tree.  Its filename was
     update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: update coredump path in kernel to not check coredump rlim if core_pattern is a pipe
From: Neil Horman <nhorman@tuxdriver.com>

Update do_coredump such that it ignores RLIMIT_CORE in the event that
core_pattern is a pipe.  RLIMIT_CORE is meant to prevent dumping cores that
are to large for the filesystem they are being written to for a given user
id.  If the core_pattern points to a pipe, the core isn't written to disk,
but rather sent to a spawned reader utility, negating the need for the
check.  If the pipe reader later decides to write the core to disk, the
reading process is bound by the quotas and permissions that the target
filesystem has set on it.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff -puN fs/exec.c~update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe fs/exec.c
--- a/fs/exec.c~update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe
+++ a/fs/exec.c
@@ -1759,9 +1759,6 @@ int do_coredump(long signr, int exit_cod
 	 */
 	clear_thread_flag(TIF_SIGPENDING);
 
-	if (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump)
-		goto fail_unlock;
-
 	/*
 	 * lock_kernel() because format_corename() is controlled by sysctl, which
 	 * uses lock_kernel()
@@ -1769,6 +1766,19 @@ int do_coredump(long signr, int exit_cod
  	lock_kernel();
 	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
+
+	/*
+	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
+	 * to a pipe.  Since we're not writing directly to the filesystem
+	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
+	 * created unless the pipe reader choses to write out the core file
+	 * at which point file size limits and permissions will be imposed
+	 * as it does with any other process
+	 */
+	if ((!ispipe) &&
+	   (current->signal->rlim[RLIMIT_CORE].rlim_cur < binfmt->min_coredump))
+		goto fail_unlock;
+
  	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-binfmt_flat-fix.patch
