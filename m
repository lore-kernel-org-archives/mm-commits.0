Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0446C43334
	for <mm-commits@archiver.kernel.org>; Wed, 20 Jul 2022 16:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbiGTQhN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiGTQhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jul 2022 12:37:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A5F55091
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 09:37:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCF261DA6
        for <mm-commits@vger.kernel.org>; Wed, 20 Jul 2022 16:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FEBC341C7;
        Wed, 20 Jul 2022 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658335025;
        bh=JHQuJm+0W66CBp82h5JpXKaQBrsT/ofIrQs2Y9zhcZA=;
        h=Date:To:From:Subject:From;
        b=t8E9mZ9t1LQoVyPQoJhAFhyTovX1LUtt2P5FR+EiDzUKZOUwuB6aM88JtUjrUGqQc
         WA7/6RfozOXYTDodkTVcJutJfsazKR34TRlGMS2stSizNyfjBE+s8VsZnflOzSSS7B
         bp4Qot96eIb4I5692lFDEKelv5l7ZQVzFATrFLkw=
Date:   Wed, 20 Jul 2022 09:37:04 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        roman.gushchin@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch added to mm-unstable branch
Message-Id: <20220720163705.14FEBC341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-shrinkers-fix-double-kfree-on-shrinker-name-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch

This patch will later appear in the mm-unstable branch at
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

mm-shrinkers-fix-double-kfree-on-shrinker-name-fix.patch
mm-memcontrol-do-not-miss-memcg_max-events-for-enforced-allocations.patch

