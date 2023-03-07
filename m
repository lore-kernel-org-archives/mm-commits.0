Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ED6C6FD1E
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCGW1d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCGW0t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:26:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23F697B74
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:26:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9ED68CE1D58
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F222EC433EF;
        Tue,  7 Mar 2023 22:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678227931;
        bh=IOLTQgpru9x7C16Gliyd+1U7bvPc+eRjwvqTLRMzyr0=;
        h=Date:To:From:Subject:From;
        b=pZhpqvBDTXyrkpS0c2yX2NgYYWUna9usKy6cXjHm9CNTQvMK4fjDA7QnVFEqKV0QC
         ov2LUermFxjlSJiHkkWpK1DuaPRNbQ7O/LQnKkiZgYHWrXayaBu7lscsVSQxqIn7IJ
         UtwEs/I9qF+S7Lo+dUuTygnD8ddfaZheKRU53rzU=
Date:   Tue, 07 Mar 2023 14:25:30 -0800
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, sultan@kerneltoast.com,
        shy828301@gmail.com, shakeelb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch added to mm-unstable branch
Message-Id: <20230307222530.F222EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: hold write lock to reparent shrinker nr_deferred
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch

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
Subject: mm: vmscan: hold write lock to reparent shrinker nr_deferred
Date: Tue, 7 Mar 2023 14:56:03 +0800

For now, reparent_shrinker_deferred() is the only holder of read lock of
shrinker_rwsem.  And it already holds the global cgroup_mutex, so it will
not be called in parallel.

Therefore, in order to convert shrinker_rwsem to shrinker_mutex later,
here we change to hold the write lock of shrinker_rwsem to reparent.

Link: https://lkml.kernel.org/r/20230307065605.58209-7-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred
+++ a/mm/vmscan.c
@@ -451,7 +451,7 @@ void reparent_shrinker_deferred(struct m
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_read(&shrinker_rwsem);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -460,7 +460,7 @@ void reparent_shrinker_deferred(struct m
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	up_read(&shrinker_rwsem);
+	up_write(&shrinker_rwsem);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-add-a-map_nr_max-field-to-shrinker_info.patch
mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-make-memcg-slab-shrink-lockless.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

