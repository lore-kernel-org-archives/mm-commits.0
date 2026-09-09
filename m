Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828A4356A37
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 07:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788937387; cv=none; b=r4C37ZMC34mSVj+H3YLQLnZ6tcqDYiaBAcgRRQp1C3XrdkJu1QbUBJb3uTH2fBijaW/zze9iLAH2kKh83i88EN18ZhvhNvb8swKUKwwtUWcDU7qOz8kA7W8mCu/WkHYapdpWxZRGqvxBDzvLewVsm6hRRNlbsPHIujk6eFko3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788937387; c=relaxed/simple;
	bh=XAExf44wlSTGYnWDMSUST1M5ZBVXBcNQkgWZHO61j0I=;
	h=Date:To:From:Subject:Message-Id; b=lTNyl3u7zTQxXSboasarTKsHdyaaDcbcuazSsJDqMXpX7NI2oUHrnZkK4WlxQGm9NCA2IwyUy0eTPhYQkR1m2PILIF2BAC3u+fXpXZ1LWNoKvyEPyHyBQzhQ5GwvOgSMXSAHZwdrCXQz9EkTz8wqNR3WpXeG4XhEHK4kycPAPfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gRX9f0uC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gRX9f0uC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688D1F00A3A;
	Wed,  9 Sep 2026 07:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788937386;
	bh=mCcxNsLRqtTJagJrSbmVd5Bo8k3sPbpeTtVHBneA+6E=;
	h=Date:To:From:Subject;
	b=gRX9f0uCQweJwaxe5vgKHqK8oVedpZ6rd0be2oNBWxcj/SlFGcZA6mfogm/85Wr0f
	 dLew3RjYhxxlG2DlqffzwH5hFSp2nkRP/julgMFs7Re1kCuz9rFFvfVemrvgy4vR6a
	 hkxQrZTR2ld0MJzFgGOzvYRkUpDFhK4aQ4lAzHU4=
Date: Wed, 09 Sep 2026 00:03:05 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-clear-the-reference-counter-for-rejected-folios.patch added to mm-new branch
Message-Id: <20260909070306.0688D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mglru: clear the reference counter for rejected folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: clear the reference counter for rejected folios
Date: Wed, 9 Sep 2026 09:57:04 +0800

As per the comment on LRU_REFS_FLAGS, when accessed folios are promoted to
a new generation, LRU_REFS_FLAGS should be cleared so that the reference
counter can start over.

For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS and
set the PG_active flag when lru_gen_folio_seq() would place them in the
oldest generation.  That's fine.

But for rejected folios where lru_gen_folio_seq() returns a generation
other than the oldest one (which can be treated as a promotion), we do not
clear LRU_REFS_FLAGS.  This can violate the promotion mechanism.  And this
means the rejected folio enters the new generation with stale, inflated
tier bits, which can inflate reference counts and distort eviction
statistics for these rejected folios.

Fix this by clearing LRU_REFS_FLAGS for rejected folios.  Of course, I
need to evaluate the impact of the changes, which mainly falls into 3
cases:

1. When lru_gen_folio_seq() returns the oldest generation for rejected
   folios, there are no logic changes, and they will be put back into the
   2nd youngest generation.

2. For rejected folios with PG_active set by shrink_folio_list(), we
   only clear the LRU_REFS_FLAGS and do not change the generation.

3. For rejected folios with PG_referenced set, the original code would
   put them back into the 2nd oldest generation.  After this patch, we
   will put them back into the 2nd youngest generation.

I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
use folio_mark_accessed to replace folio_set_active"), a rejected
referenced folio was also put back to the 2nd youngest gen.  Meanwhile, I
didn't see any noticeable performance impact on my 32-core Arm machine
when running 'make -j32' to build the kernel inside a 3G-limited memcg
with either zram or NVMe swap.

Link: https://lore.kernel.org/9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-mglru-clear-the-reference-counter-for-rejected-folios
+++ a/mm/vmscan.c
@@ -5072,11 +5072,12 @@ retry:
 			continue;
 		}
 
+		/* See the comments on LRU_REFS_FLAGS */
+		folio_set_lru_refs(folio, 0);
+
 		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

maintainers-add-baoquan-and-me-as-mglru-reviewers.patch
mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

