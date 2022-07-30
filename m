Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC8DC19F29
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiG3BIM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiG3BIL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8ACC78221
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8400CB82925
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF38C433C1;
        Sat, 30 Jul 2022 01:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143288;
        bh=u8iFbZ228c8G+OhDSR4X2a7YnyXvFcpno+bzQUB793s=;
        h=Date:To:From:Subject:From;
        b=V1VX8YRlCetev8utoQxj64anQpaNtgCQSQnvNVmk7gs8hG1hV5V8SGWVkLW4zvcj/
         MdX1iXYNof3SMcgNEF53NQojgKTH37hN1R4MtTVuU6jEqjfggnRJiUZIripgbSwN06
         hj3DVinWkmxtSXaz3WSTEOgwZoLlSKyaw6Re11nA=
Date:   Fri, 29 Jul 2022 18:08:07 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+8b481578352d4637f510@syzkaller.appspotmail.com,
        roman.gushchin@linux.dev, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shrinkers-fix-double-kfree-on-shrinker-name.patch removed from -mm tree
Message-Id: <20220730010808.3AF38C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: shrinkers: fix double kfree on shrinker name
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-fix-double-kfree-on-shrinker-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm: shrinkers: fix double kfree on shrinker name
Date: Wed, 20 Jul 2022 23:47:55 +0900

syzbot is reporting double kfree() at free_prealloced_shrinker() [1], for
destroy_unused_super() calls free_prealloced_shrinker() even if
prealloc_shrinker() returned an error.  Explicitly clear shrinker name
when prealloc_shrinker() called kfree().

[roman.gushchin@linux.dev: zero shrinker->name in all cases where shrinker->name is freed]
  Link: https://lkml.kernel.org/r/YtgteTnQTgyuKUSY@castle
Link: https://syzkaller.appspot.com/bug?extid=8b481578352d4637f510 [1]
Link: https://lkml.kernel.org/r/ffa62ece-6a42-2644-16cf-0d33ef32c676@I-love.SAKURA.ne.jp
Fixes: e33c267ab70de424 ("mm: shrinkers: provide shrinkers with names")
Reported-by: syzbot <syzbot+8b481578352d4637f510@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    1 +
 mm/vmscan.c         |    9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-fix-double-kfree-on-shrinker-name
+++ a/mm/shrinker_debug.c
@@ -251,6 +251,7 @@ void shrinker_debugfs_remove(struct shri
 	lockdep_assert_held(&shrinker_rwsem);
 
 	kfree_const(shrinker->name);
+	shrinker->name = NULL;
 
 	if (!shrinker->debugfs_entry)
 		return;
--- a/mm/vmscan.c~mm-shrinkers-fix-double-kfree-on-shrinker-name
+++ a/mm/vmscan.c
@@ -644,8 +644,10 @@ int prealloc_shrinker(struct shrinker *s
 		return -ENOMEM;
 
 	err = __prealloc_shrinker(shrinker);
-	if (err)
+	if (err) {
 		kfree_const(shrinker->name);
+		shrinker->name = NULL;
+	}
 
 	return err;
 }
@@ -660,6 +662,7 @@ void free_prealloced_shrinker(struct shr
 {
 #ifdef CONFIG_SHRINKER_DEBUG
 	kfree_const(shrinker->name);
+	shrinker->name = NULL;
 #endif
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
 		down_write(&shrinker_rwsem);
@@ -704,8 +707,10 @@ int register_shrinker(struct shrinker *s
 		return -ENOMEM;
 
 	err = __register_shrinker(shrinker);
-	if (err)
+	if (err) {
 		kfree_const(shrinker->name);
+		shrinker->name = NULL;
+	}
 	return err;
 }
 #else
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are


