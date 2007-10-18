From: akpm@linux-foundation.org
Subject: - make-kernel-profilectime_hook-static.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:21 -0700
Message-ID: <200710180659.l9I6xLWV030976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbXJRG7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make kernel/profile.c:time_hook static
has been removed from the -mm tree.  Its filename was
     make-kernel-profilectime_hook-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make kernel/profile.c:time_hook static
From: Adrian Bunk <bunk@kernel.org>

{,un}register_timer_hook() is the API that should be used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/profile.h |    3 ---
 kernel/profile.c        |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/profile.h~make-kernel-profilectime_hook-static include/linux/profile.h
--- a/include/linux/profile.h~make-kernel-profilectime_hook-static
+++ a/include/linux/profile.h
@@ -78,9 +78,6 @@ int profile_event_unregister(enum profil
 int register_timer_hook(int (*hook)(struct pt_regs *));
 void unregister_timer_hook(int (*hook)(struct pt_regs *));
 
-/* Timer based profiling hook */
-extern int (*timer_hook)(struct pt_regs *);
-
 struct pt_regs;
 
 #else
diff -puN kernel/profile.c~make-kernel-profilectime_hook-static kernel/profile.c
--- a/kernel/profile.c~make-kernel-profilectime_hook-static
+++ a/kernel/profile.c
@@ -37,7 +37,7 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 /* Oprofile timer tick hook */
-int (*timer_hook)(struct pt_regs *) __read_mostly;
+static int (*timer_hook)(struct pt_regs *) __read_mostly;
 
 static atomic_t *prof_buffer;
 static unsigned long prof_len, prof_shift;
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
