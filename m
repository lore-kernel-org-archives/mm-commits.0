From: akpm@linux-foundation.org
Subject: [merged] fcntl-rename-f_owner_gid-to-f_owner_pgrp.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:24 -0800
Message-ID: <200911201930.nAKJUOKL010594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbZKTTbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mingo@elte.hu, mtk.manpages@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fcntl: rename F_OWNER_GID to F_OWNER_PGRP
has been removed from the -mm tree.  Its filename was
     fcntl-rename-f_owner_gid-to-f_owner_pgrp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fcntl: rename F_OWNER_GID to F_OWNER_PGRP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

This is for consistency with various ioctl() operations that include the
suffix "PGRP" in their names, and also for consistency with PRIO_PGRP,
used with setpriority() and getpriority().  Also, using PGRP instead of
GID avoids confusion with the common abbreviation of "group ID".

I'm fine with anything that makes it more consistent, and if PGRP is what
is the predominant abbreviation then I see no need to further confuse
matters by adding a third one.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fcntl.c                  |    4 ++--
 include/asm-generic/fcntl.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fcntl.c~fcntl-rename-f_owner_gid-to-f_owner_pgrp fs/fcntl.c
--- a/fs/fcntl.c~fcntl-rename-f_owner_gid-to-f_owner_pgrp
+++ a/fs/fcntl.c
@@ -284,7 +284,7 @@ static int f_setown_ex(struct file *filp
 		type = PIDTYPE_PID;
 		break;
 
-	case F_OWNER_GID:
+	case F_OWNER_PGRP:
 		type = PIDTYPE_PGID;
 		break;
 
@@ -321,7 +321,7 @@ static int f_getown_ex(struct file *filp
 		break;
 
 	case PIDTYPE_PGID:
-		owner.type = F_OWNER_GID;
+		owner.type = F_OWNER_PGRP;
 		break;
 
 	default:
diff -puN include/asm-generic/fcntl.h~fcntl-rename-f_owner_gid-to-f_owner_pgrp include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~fcntl-rename-f_owner_gid-to-f_owner_pgrp
+++ a/include/asm-generic/fcntl.h
@@ -106,7 +106,7 @@
 
 #define F_OWNER_TID	0
 #define F_OWNER_PID	1
-#define F_OWNER_GID	2
+#define F_OWNER_PGRP	2
 
 struct f_owner_ex {
 	int	type;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch

