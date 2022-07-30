Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8145EC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiG3AyO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3AyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:54:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC1872EE4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1031661537
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E6AC433D7;
        Sat, 30 Jul 2022 00:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142451;
        bh=v8j+3W1vkHOXpQiKGZEspKwMFfFZm70OJhXJGxf7jZ0=;
        h=Date:To:From:Subject:From;
        b=yA/FARToozWCJS7506rr6+WonfNeHMfhQlvP7F2dOF3MjZS39SdhGTp0c5BEhNUBh
         K6mQl/ldOjk51i90onGILaWjsqNlszCzsbOIZd+Q8AfAzFPTPI6BOzBwpJK55Kwei9
         7J+Z6MpbM6MztYpGCj2BhWQZ/1QxTJasE2sW1lP0=
Date:   Fri, 29 Jul 2022 17:54:10 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        roman.gushchin@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch removed from -mm tree
Message-Id: <20220730005411.64E6AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-shrinkers-fix-double-kfree-on-shrinker-name-fix
has been removed from the -mm tree.  Its filename was
     mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch

This patch was dropped because it was folded into mm-shrinkers-fix-double-kfree-on-shrinker-name.patch

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-shrinkers-fix-double-kfree-on-shrinker-name-fix
Date: Wed, 20 Jul 2022 09:29:45 -0700

zero shrinker->name in all cases where shrinker->name is freed

Link: https://lkml.kernel.org/r/YtgteTnQTgyuKUSY@castle
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shrinker_debug.c |    1 +
 mm/vmscan.c         |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/shrinker_debug.c~mm-shrinkers-fix-double-kfree-on-shrinker-name-fix
+++ a/mm/shrinker_debug.c
@@ -251,6 +251,7 @@ void shrinker_debugfs_remove(struct shri
 	lockdep_assert_held(&shrinker_rwsem);
 
 	kfree_const(shrinker->name);
+	shrinker->name = NULL;
 
 	if (!shrinker->debugfs_entry)
 		return;
--- a/mm/vmscan.c~mm-shrinkers-fix-double-kfree-on-shrinker-name-fix
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
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-shrinkers-fix-double-kfree-on-shrinker-name.patch
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

