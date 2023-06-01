Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08159C77B7E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjFAWef (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjFAWee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:34:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826E12C
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24F0364A6E
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DE4C433D2;
        Thu,  1 Jun 2023 22:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685658872;
        bh=8UoZCmHFnVTKXqH00KAeXD/HyemqDig9KmMMjYIH82E=;
        h=Date:To:From:Subject:From;
        b=NqLhy4JIZFesIiukggcS+GVt4z42kXLx6y0ZBbcsS8EAFf0agFnGke+7Usdwqm/jY
         WLkUL+JhwuIPUOOaMJG74dPEB1xeL+yX9s0CyqwipMaJebkRLiGYAlmm5aRb6HHbEr
         BiklxoTuGCd+PtKdmnTb3qEHtI3z6e3pPu/CGNhw=
Date:   Thu, 01 Jun 2023 15:34:31 -0700
To:     mm-commits@vger.kernel.org, roman.gushchin@linux.dev,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch added to mm-unstable branch
Message-Id: <20230601223432.72DE4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: move shrinker_debugfs_remove() before synchronize_srcu()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: move shrinker_debugfs_remove() before synchronize_srcu()
Date: Thu, 1 Jun 2023 13:27:14 +0000

The debugfs_remove_recursive() will wait for debugfs_file_put() to return,
so there is no need to put it after synchronize_srcu() to wait for the rcu
read-side critical section to exit.

Just move it before synchronize_srcu(), which is also convenient to put
the heavy synchronize_srcu() in the delayed work later.

Link: https://lkml.kernel.org/r/20230601132714.2540707-1-qi.zheng@linux.dev
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu
+++ a/mm/vmscan.c
@@ -818,11 +818,11 @@ void unregister_shrinker(struct shrinker
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	mutex_unlock(&shrinker_mutex);
 
+	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
+
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
-	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
-
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch

