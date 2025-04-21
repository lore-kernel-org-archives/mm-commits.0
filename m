Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEEA1EF09C
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745261666; cv=none; b=OpIKFzwRbXwugH7LQHcJgd7wuJNj76lnCChMfDP5le2Bbz5CpRcsnnlcxKpRA2YD2IDiugCeLP0fSt2zepgaTitnrg4A4+GgDvsnuq9/x92PRU7pfpmtJ3ee1maQnNIgFNz83qFL4+umcbWs699a0dHc6YSO/dLD00aXyhIsObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745261666; c=relaxed/simple;
	bh=XZWj1Xe7DYAtcgrna+Lm5wvmvEVubizlH7+4w2V06t4=;
	h=Date:To:From:Subject:Message-Id; b=D234NC5FxxYjh7oF7sEPJ8ZAiGJzqzUrTtPPLf9b2sjIqO5wAdGMJSyzMIKZC3dj09jKaE3l7+tiRJoOBpedSMz2+wB5VTn68obYpeKYJyfEeCTJVtRWolSUGpYq+Xkkpp9wAdnCOqIVaIo6SKnpgXHuKAnijTcjRoagIYUYFoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QfM9gy6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QfM9gy6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C62AC4CEE4;
	Mon, 21 Apr 2025 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745261665;
	bh=XZWj1Xe7DYAtcgrna+Lm5wvmvEVubizlH7+4w2V06t4=;
	h=Date:To:From:Subject:From;
	b=QfM9gy6RFJCA6jA3W4bkyNqWNhxepEE0h9QKmqn+nrBU29cTNKVwGCd9OUteq5mPV
	 D4G9AFZi8W4EZNfrZhWeGRogB+HMpW/JhEJFS5tClPoS56EU9z+2dJbC4a/Pl8R0c4
	 Ek8RPc0cnTopgKnzfILjsL+/BLM98Q30MYTlxJmw=
Date: Mon, 21 Apr 2025 11:54:24 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosry.ahmed@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch added to mm-new branch
Message-Id: <20250421185425.8C62AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add swappiness=max arg to memory.reclaim for only anon reclaim
has been added to the -mm mm-new branch.  Its filename is
     mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm: add swappiness=max arg to memory.reclaim for only anon reclaim
Date: Mon, 21 Apr 2025 17:13:28 +0800

Patch series "add max arg to swappiness in memory.reclaim and lru_gen", v4.

This patchset adds max arg to swappiness in memory.reclaim and lru_gen for
anon only proactive memory reclaim.

With commit <68cd9050d871> ("mm: add swappiness= arg to memory.reclaim")
we can submit an additional swappiness=<val> argument to memory.reclaim. 
It is very useful because we can dynamically adjust the reclamation ratio
based on the anonymous folios and file folios of each cgroup.  For
example,when swappiness is set to 0, we only reclaim from file folios. 
But we can not relciam memory just from anon folios.

This patchset introduces a new macro, SWAPPINESS_ANON_ONLY, defined as
MAX_SWAPPINESS + 1, represent the max arg semantics.  It specifically
indicates that reclamation should occur only from anonymous pages.

Patch 1 adds swappiness=max arg to memory.reclaim suggested-by: Yosry
Ahmed

Patch 2 add more comments for cache_trim_mode from Johannes Weiner in [1].

Patch 3 add max arg to lru_gen for proactive memory reclaim in MGLRU.  The
MGLRU already supports reclaiming exclusively from anonymous pages.  This
patch formalizes that behavior by introducing a max parameter to represent
the corresponding semantics.

Patch 4 using SWAPPINESS_ANON_ONLY in MGLRU Using SWAPPINESS_ANON_ONLY
instead of MAX_SWAPPINESS + 1 to indicate reclaiming only from anonymous
pages makes the code more readable and explicit

Here is the previous discussion:
https://lore.kernel.org/all/20250314033350.1156370-1-hezhongkun.hzk@bytedance.com/
https://lore.kernel.org/all/20250312094337.2296278-1-hezhongkun.hzk@bytedance.com/
https://lore.kernel.org/all/20250318135330.3358345-1-hezhongkun.hzk@bytedance.com/


This patch (of 4):

With commit <68cd9050d871> ("mm: add swappiness= arg to memory.reclaim")
we can submit an additional swappiness=<val> argument to memory.reclaim. 
It is very useful because we can dynamically adjust the reclamation ratio
based on the anonymous folios and file folios of each cgroup.  For
example,when swappiness is set to 0, we only reclaim from file folios.

However,we have also encountered a new issue: when swappiness is set to
the MAX_SWAPPINESS, it may still only reclaim file folios.

So, we hope to add a new arg 'swappiness=max' in memory.reclaim where
proactive memory reclaim only reclaims from anonymous folios when
swappiness is set to max.  The swappiness semantics from a user
perspective remain unchanged.

For example, something like this:

echo "2M swappiness=max" > /sys/fs/cgroup/memory.reclaim

will perform reclaim on the rootcg with a swappiness setting of 'max' (a
new mode) regardless of the file folios.  Users have a more comprehensive
view of the application's memory distribution because there are many
metrics available.  For example, if we find that a certain cgroup has a
large number of inactive anon folios, we can reclaim only those and skip
file folios, because with the zram/zswap, the IO tradeoff that
cache_trim_mode or other file first logic is making doesn't hold - file
refaults will cause IO, whereas anon decompression will not.

With this patch, the swappiness argument of memory.reclaim has a new
mode 'max', means reclaiming just from anonymous folios both in traditional
LRU and MGLRU.

Link: https://lkml.kernel.org/r/cover.1745225696.git.hezhongkun.hzk@bytedance.com
Link: https://lore.kernel.org/all/20250314141833.GA1316033@cmpxchg.org/ [1]
Link: https://lkml.kernel.org/r/519e12b9b1f8c31a01e228c8b4b91a2419684f77.1745225696.git.hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v2.rst |    3 +++
 include/linux/swap.h                    |    4 ++++
 mm/memcontrol.c                         |    5 +++++
 mm/vmscan.c                             |    7 +++++++
 4 files changed, 19 insertions(+)

--- a/Documentation/admin-guide/cgroup-v2.rst~mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim
+++ a/Documentation/admin-guide/cgroup-v2.rst
@@ -1362,6 +1362,9 @@ The following nested keys are defined.
 	same semantics as vm.swappiness applied to memcg reclaim with
 	all the existing limitations and potential future extensions.
 
+	The valid range for swappiness is [0-200, max], setting
+	swappiness=max exclusively reclaims anonymous memory.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
--- a/include/linux/swap.h~mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim
+++ a/include/linux/swap.h
@@ -414,6 +414,10 @@ extern unsigned long try_to_free_pages(s
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
+
+/* Just recliam from anon folios in proactive memory reclaim */
+#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
+
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
--- a/mm/memcontrol.c~mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim
+++ a/mm/memcontrol.c
@@ -4457,11 +4457,13 @@ static ssize_t memory_oom_group_write(st
 
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
+	MEMORY_RECLAIM_SWAPPINESS_MAX,
 	MEMORY_RECLAIM_NULL,
 };
 
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
+	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -4495,6 +4497,9 @@ static ssize_t memory_reclaim(struct ker
 			if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
 				return -EINVAL;
 			break;
+		case MEMORY_RECLAIM_SWAPPINESS_MAX:
+			swappiness = SWAPPINESS_ANON_ONLY;
+			break;
 		default:
 			return -EINVAL;
 		}
--- a/mm/vmscan.c~mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim
+++ a/mm/vmscan.c
@@ -2564,6 +2564,13 @@ static void get_scan_count(struct lruvec
 		goto out;
 	}
 
+	/* Proactive reclaim initiated by userspace for anonymous memory only */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		scan_balance = SCAN_ANON;
+		goto out;
+	}
+
 	/*
 	 * Do not apply any pressure balancing cleverness when the
 	 * system is close to OOM, scan both anon and file equally
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-add-swappiness=max-arg-to-memoryreclaim-for-only-anon-reclaim.patch
mm-vmscan-add-more-comments-about-cache_trim_mode.patch
mm-add-max-swappiness-arg-to-lru_gen-for-anonymous-memory-only.patch
mm-using-swappiness_anon_only-in-mglru.patch

