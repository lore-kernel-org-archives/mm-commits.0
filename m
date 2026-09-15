Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5B23BD635
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 03:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789444299; cv=none; b=biLBpMkZxVPTYLoKs7r0WLYwk/fTuW0JMJXPYJ1lz3yQw9ihH+M7/x8+IZxX9y8TnhzunLVQkOgdbUuu65SPNdiLPNQWqdP533naOgeRAhl/9ehxom3zoDXdqLFE65oNMExvN5u2s/PtJoNxrs+D+/kbFOLc9naek7bpQnXynoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789444299; c=relaxed/simple;
	bh=imaT4gJGdRBudaPhpTF3fkuf7JXToqPiWslZj5oa40I=;
	h=Date:To:From:Subject:Message-Id; b=tKjKZDAdMBa2eStfJgY1D1OY2L6fFHRRFdVC/8knd6tWUMQU/Xk/dOa0UJaDwDlGzoF76C+ooWpTTk/Bqu0mtlQYLLk5fcU/MeJEHAoXZfwPtubSqkgr1KO7P6tlXAOl87HMQRPKcww3eKKcTLxMG+j6xsu2jNdklM5Y8u78ht8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f9ZhreM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f9ZhreM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A192E1F000FF;
	Tue, 15 Sep 2026 03:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789444297;
	bh=o1lAti4AZBrgyM3L4oFzDm/AngsKAPPjI/7Iy20aH9A=;
	h=Date:To:From:Subject;
	b=f9ZhreM++bH9DyELl9T9gcv2tR8oQewxugvb6/eRQjiA6BGEZpcuu5eRD9dIVY1f6
	 JC16BL5I5VC46FL9Wwnw2vNW7ZsVnPrf0fsPSJSi0qsfquU1wBL33fu7++ujyA8ddx
	 gXywc56jR5gq4tcULUcc36NfAd+XO1TeSwxOXJYM=
Date: Mon, 14 Sep 2026 20:51:37 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-clear-the-reference-counter-for-rejected-folios.patch added to mm-unstable branch
Message-Id: <20260915035137.A192E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mglru: clear the reference counter for rejected folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Mon, 14 Sep 2026 19:29:22 +0800

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
cases: 1.  When lru_gen_folio_seq() returns the oldest generation for
rejected folios, there are no logic changes, and they will be put back
into the 2nd youngest generation.  2.  For rejected folios with PG_active
set by shrink_folio_list(), we only clear the LRU_REFS_FLAGS and do not
change the generation.  3.  For rejected folios with PG_referenced set,
the original code would put them back into the 2nd oldest generation. 
After this patch, we will put them back into the 2nd youngest generation.

I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mglru:
use folio_mark_accessed to replace folio_set_active"), a rejected
referenced folio was also put back to the 2nd youngest gen.  Meanwhile, I
didn't see any noticeable performance impact on my 32-core Arm machine
when running 'make -j32' to build the kernel inside a 3G-limited memcg
with either zram or NVMe swap.

Link: https://lore.kernel.org/7384df363c12e4acdaa2e0428420cd8eed320ee7.1789384831.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-mglru-clear-the-reference-counter-for-rejected-folios
+++ a/mm/vmscan.c
@@ -5072,11 +5072,15 @@ retry:
 			continue;
 		}
 
-		/* don't add rejected folios to the oldest generation */
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
-			folio_set_lru_refs(folio, 0);
+		/*
+		 * See the comments on LRU_REFS_FLAGS.
+		 *
+		 * The rejected folios are never added to the oldest generation,
+		 * so this effectively promotes them by at least one generation.
+		 */
+		folio_set_lru_refs(folio, 0);
+		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
 			folio_set_active(folio);
-		}
 	}
 
 	move_folios_to_lru(&list);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

maintainers-add-baoquan-and-me-as-mglru-reviewers.patch
mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch
mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

