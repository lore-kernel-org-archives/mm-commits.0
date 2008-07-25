From: akpm@linux-foundation.org
Subject: - quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:19:37 -0700
Message-ID: <200807250019.m6P0Jc0Y013802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbYGYATm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:19:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, arjenpool@gmail.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota-move-function-macros-from-quotah-to-quotaopsh fix
has been removed from the -mm tree.  Its filename was
     quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch

This patch was dropped because it was folded into quota-move-function-macros-from-quotah-to-quotaopsh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota-move-function-macros-from-quotah-to-quotaopsh fix
From: Vegard Nossum <vegard.nossum@gmail.com>

On Wed, Jun 11, 2008 at 8:08 PM,  <arjenpool@gmail.com> wrote:
> Today i`ve tried to compile a linux-2.6.26-rc5-mm2 kernel obtained with the
> Ketchup tool.
>
> It got halfway interupted with the following error messages:
>
> CC [M] fs/xfs/support/debug.o
>  CC [M] fs/xfs/support/uuid.o
>  LD [M] fs/xfs/xfs.o
>  CC fs/quota.o
> fs/quota.c: In function 'quota_sync_sb':
> fs/quota.c:174: error: implicit declaration of function 'sb_dqopt'

It seems that this definition is needed regardless of CONFIG_QUOTA.

I'm attaching a patch that fixes it for me. I'm not 100% it's the right
thing.

Vegard

From 5fc276129d8a3e2a70980104cc374bdc0d61afa3 Mon Sep 17 00:00:00 2001
Date: Wed, 11 Jun 2008 21:58:32 +0200
Subject: [PATCH] fs: fix build breakage

The patch

| commit 9651a656c9fbf3e8183b5eb21740edc1eb9ca16b
| Author: Jan Kara <jack@suse.cz>
| Date:   Thu Jun 5 19:53:42 2008 +0000
|
|     quota-move-function-macros-from-quotah-to-quotaopsh
|

causes the build to break for CONFIG_QUOTA=n.

Reviewed-by: Arjen Pool <arjenpool@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/quotaops.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/quotaops.h~quota-move-function-macros-from-quotah-to-quotaopsh-fix include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-move-function-macros-from-quotah-to-quotaopsh-fix
+++ a/include/linux/quotaops.h
@@ -14,6 +14,8 @@
 
 #include <linux/fs.h>
 
+#define sb_dqopt(sb) (&(sb)->s_dquot)
+
 #if defined(CONFIG_QUOTA)
 
 /*
@@ -52,7 +54,6 @@ void vfs_dq_drop(struct inode *inode);
 int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
 int vfs_dq_quota_on_remount(struct super_block *sb);
 
-#define sb_dqopt(sb) (&(sb)->s_dquot)
 #define sb_dqinfo(sb, type) (sb_dqopt(sb)->info+(type))
 
 /*
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
kallsyms-unify-32-and-64-bit-code.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
s390-topology-dont-use-kthread-for-arch_reinit_sched_domains.patch
taskstats-remove-initialization-of-static-per-cpu-variable.patch

