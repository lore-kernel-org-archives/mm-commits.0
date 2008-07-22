From: akpm@linux-foundation.org
Subject: - fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:24 -0700
Message-ID: <200807222132.m6MLWOsp018711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbYGVVik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, davidel@xmailserver.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix build on COMPAT platforms when CONFIG_EPOLL is disabled
has been removed from the -mm tree.  Its filename was
     fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix build on COMPAT platforms when CONFIG_EPOLL is disabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add missing cond_syscall() entry for compat_sys_epoll_pwait.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys_ni.c~fix-build-on-compat-platforms-when-config_epoll-is-disabled kernel/sys_ni.c
--- a/kernel/sys_ni.c~fix-build-on-compat-platforms-when-config_epoll-is-disabled
+++ a/kernel/sys_ni.c
@@ -59,6 +59,7 @@ cond_syscall(sys_epoll_create);
 cond_syscall(sys_epoll_ctl);
 cond_syscall(sys_epoll_wait);
 cond_syscall(sys_epoll_pwait);
+cond_syscall(compat_sys_epoll_pwait);
 cond_syscall(sys_semget);
 cond_syscall(sys_semop);
 cond_syscall(sys_semtimedop);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
mtdpart-separate-main-loop-from-per-partition-code-in-add_mtd_partition.patch
mtdpart-handle-most-checkpatch-findings.patch
mtdpart-cleanup-and-document-the-erase-region-handling.patch
mtdpart-fix-a-division-by-zero-bug.patch
mtdpart-handle-remaining-checkpatch-findings.patch

