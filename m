Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6B6C77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 21:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjECVWg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 17:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjECVWb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 17:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577A67EEB
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 14:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6CC663024
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 21:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353C0C4339E;
        Wed,  3 May 2023 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683148949;
        bh=/uauhhrfbmObXsxZU9hYOHXNMLS5z9Lf3RCor9JcAkY=;
        h=Date:To:From:Subject:From;
        b=M+2wukvAilHCzPuokn0KeWKcMAYqPUSQUNmQ2JRCOo/AHFM9z4+82vC1vahY9Qgqq
         fCMSwLWxuvglPK5ZhVCirD43g3q87ZB+yZSwK4uXeySXfFlGTCgpH3bzBCGFWoZbQS
         +5pqV5zgEJnHoizeyRgU4dGflg86fg3GbNpnEREE=
Date:   Wed, 03 May 2023 14:22:28 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        roman.gushchin@linux.dev, joanbrugueram@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-race-condition-on-debugfs-cleanup.patch added to mm-hotfixes-unstable branch
Message-Id: <20230503212229.353C0C4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: fix race condition on debugfs cleanup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shrinkers-fix-race-condition-on-debugfs-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-race-condition-on-debugfs-cleanup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joan Bruguera Micó <joanbrugueram@gmail.com>
Subject: mm: shrinkers: fix race condition on debugfs cleanup
Date: Wed, 3 May 2023 01:32:32 +0000

When something registers and unregisters many shrinkers, such as:
    for x in $(seq 10000); do unshare -Ui true; done

Sometimes the following error is printed to the kernel log:
    debugfs: Directory '...' with parent 'shrinker' already present!

This occurs since commit badc28d4924b ("mm: shrinkers: fix deadlock in
shrinker debugfs") / v6.2: Since the call to `debugfs_remove_recursive`
was moved outside the `shrinker_rwsem`/`shrinker_mutex` lock, but the call
to `ida_free` stayed inside, a newly registered shrinker can be
re-assigned that ID and attempt to create the debugfs directory before the
directory from the previous shrinker has been removed.

The locking changes in commit f95bdb700bc6 ("mm: vmscan: make global slab
shrink lockless") made the race condition more likely, though it existed
before then.

Commit badc28d4924b ("mm: shrinkers: fix deadlock in shrinker debugfs")
could be reverted since the issue is addressed should no longer occur
since the count and scan operations are lockless since commit 20cd1892fcc3
("mm: shrinkers: make count and scan in shrinker debugfs lockless"). 
However, since this is a contended lock, prefer instead moving `ida_free`
outside the lock to avoid the race.

Link: https://lkml.kernel.org/r/20230503013232.299211-1-joanbrugueram@gmail.com
Fixes: badc28d4924b ("mm: shrinkers: fix deadlock in shrinker debugfs")
Signed-off-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shrinker.h |   13 +++++++++++--
 mm/shrinker_debug.c      |   15 ++++++++++-----
 mm/vmscan.c              |    5 +++--
 3 files changed, 24 insertions(+), 9 deletions(-)

--- a/include/linux/shrinker.h~mm-shrinkers-fix-race-condition-on-debugfs-cleanup
+++ a/include/linux/shrinker.h
@@ -107,7 +107,10 @@ extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker);
+extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
+					      int *debugfs_id);
+extern void shrinker_debugfs_remove(struct dentry *debugfs_entry,
+				    int debugfs_id);
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
@@ -115,10 +118,16 @@ static inline int shrinker_debugfs_add(s
 {
 	return 0;
 }
-static inline struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
+static inline struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
+						     int *debugfs_id)
 {
+	*debugfs_id = -1;
 	return NULL;
 }
+static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
+					   int debugfs_id)
+{
+}
 static inline __printf(2, 3)
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 {
--- a/mm/shrinker_debug.c~mm-shrinkers-fix-race-condition-on-debugfs-cleanup
+++ a/mm/shrinker_debug.c
@@ -237,7 +237,8 @@ int shrinker_debugfs_rename(struct shrin
 }
 EXPORT_SYMBOL(shrinker_debugfs_rename);
 
-struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
+struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
+				       int *debugfs_id)
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
@@ -246,14 +247,18 @@ struct dentry *shrinker_debugfs_remove(s
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
 
-	if (entry) {
-		ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
-		shrinker->debugfs_entry = NULL;
-	}
+	*debugfs_id = entry ? shrinker->debugfs_id : -1;
+	shrinker->debugfs_entry = NULL;
 
 	return entry;
 }
 
+void shrinker_debugfs_remove(struct dentry *debugfs_entry, int debugfs_id)
+{
+	debugfs_remove_recursive(debugfs_entry);
+	ida_free(&shrinker_debugfs_ida, debugfs_id);
+}
+
 static int __init shrinker_debugfs_init(void)
 {
 	struct shrinker *shrinker;
--- a/mm/vmscan.c~mm-shrinkers-fix-race-condition-on-debugfs-cleanup
+++ a/mm/vmscan.c
@@ -805,6 +805,7 @@ EXPORT_SYMBOL(register_shrinker);
 void unregister_shrinker(struct shrinker *shrinker)
 {
 	struct dentry *debugfs_entry;
+	int debugfs_id;
 
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
@@ -814,13 +815,13 @@ void unregister_shrinker(struct shrinker
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
-	debugfs_entry = shrinker_debugfs_remove(shrinker);
+	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	mutex_unlock(&shrinker_mutex);
 
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
-	debugfs_remove_recursive(debugfs_entry);
+	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
 
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
_

Patches currently in -mm which might be from joanbrugueram@gmail.com are

mm-shrinkers-fix-race-condition-on-debugfs-cleanup.patch

