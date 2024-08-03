Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979F926286
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663969; cv=none; b=Me6w7G8vdJv0uO9v8NJa1R8m2yPL7HtP3iunbHNIhfmw/GuTGX3MSKiInBCVvyu2NJAhWSdVIrcmIgaGbLoSiWykq2BvM9/s/INp37QHqwxL8tL1YxWecVTlJPAgVhIrTlLsmv8sMFPVYcXVt8IQjEzMxsVihSVqn8+aQ841cTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663969; c=relaxed/simple;
	bh=kODzLErrpTWex8UnPG0LQO0Tn1C4e8htots9sG3QNmw=;
	h=Date:To:From:Subject:Message-Id; b=bGakayeYaXCsyRl2IPJ21puQdWGlTlbVcXjxgk7+I4Bvx+I5yP58zVlCTPtw8A/4jWHSgTTlFHcfBGDuDvOU/AHZIhjBElvFcNb4c/avJoYsedcIaS+If/tBC3ppu0XQO2jnGqEEnqMt+ClxdJ5K0C5U9uOrLMq7fhPRLDmcmJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIATx080; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIATx080"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231DDC116B1;
	Sat,  3 Aug 2024 05:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663969;
	bh=kODzLErrpTWex8UnPG0LQO0Tn1C4e8htots9sG3QNmw=;
	h=Date:To:From:Subject:From;
	b=cIATx0801VxnRlFnHvkx0plTOEJRZK6qs0dgQ5BZWdw45/qPtXnhJ3zxHRoYT/9xY
	 KgeVCkCMbWDn0fhl8EJDEOKzFi+4bCoeH2Yjj2Od5IMk6RCuiA9UghsBnTn4bO+Oaj
	 tlM5HvFmxyTnex95YAg/nkrm3vTslOnBzzG8X16c=
Date: Fri, 02 Aug 2024 22:46:08 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,ying.huang@intel.com,xiang@kernel.org,willy@infradead.org,surenb@google.com,shy828301@gmail.com,shakeel.butt@linux.dev,senozhatsky@chromium.org,ryan.roberts@arm.com,nphamcs@gmail.com,minchan@kernel.org,mhocko@suse.com,kasong@tencent.com,kaleshsingh@google.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch added to mm-unstable branch
Message-Id: <20240803054609.231DDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: clarify swap_count_continued and improve readability for  __swap_duplicate
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: clarify swap_count_continued and improve readability for  __swap_duplicate
Date: Fri, 2 Aug 2024 17:52:43 +1200

When usage=1 and swapcount is very large, the situation can become quite
complex.  The first entry might succeed with swap_count_continued(), but
the second entry may require extending to an additional continued page. 
Rolling back these changes can be extremely challenging.  Therefore,
anyone using usage==1 for batched __swap_duplicate() operations should
proceed with caution.

Additionally, we have moved swap_count_continued() to the second iteration
to enhance readability, as this function may modify data.

Link: https://lkml.kernel.org/r/20240802071817.47081-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/swapfile.c~mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix
+++ a/mm/swapfile.c
@@ -3386,6 +3386,7 @@ static int __swap_duplicate(swp_entry_t
 
 	offset = swp_offset(entry);
 	VM_WARN_ON(nr > SWAPFILE_CLUSTER - offset % SWAPFILE_CLUSTER);
+	VM_WARN_ON(usage == 1 && nr > 1);
 	ci = lock_cluster_or_swap_info(p, offset);
 
 	err = 0;
@@ -3404,27 +3405,14 @@ static int __swap_duplicate(swp_entry_t
 		has_cache = count & SWAP_HAS_CACHE;
 		count &= ~SWAP_HAS_CACHE;
 
-		if (usage == SWAP_HAS_CACHE) {
-			/* set SWAP_HAS_CACHE if there is no cache and entry is used */
-			if (!has_cache && count)
-				continue;
-			else if (has_cache)		/* someone else added cache */
+		if (!count && !has_cache) {
+			err = -ENOENT;
+		} else if (usage == SWAP_HAS_CACHE) {
+			if (has_cache)
 				err = -EEXIST;
-			else				/* no users remaining */
-				err = -ENOENT;
-
-		} else if (count || has_cache) {
-
-			if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
-				continue;
-			else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX)
-				err = -EINVAL;
-			else if (swap_count_continued(p, offset + i, count))
-				continue;
-			else
-				err = -ENOMEM;
-		} else
-			err = -ENOENT;			/* unused swap entry */
+		} else if ((count & ~COUNT_CONTINUED) > SWAP_MAP_MAX) {
+			err = -EINVAL;
+		}
 
 		if (err)
 			goto unlock_out;
@@ -3439,8 +3427,16 @@ static int __swap_duplicate(swp_entry_t
 			has_cache = SWAP_HAS_CACHE;
 		else if ((count & ~COUNT_CONTINUED) < SWAP_MAP_MAX)
 			count += usage;
-		else
+		else if (swap_count_continued(p, offset + i, count))
 			count = COUNT_CONTINUED;
+		else {
+			/*
+			 * Don't need to rollback changes, because if
+			 * usage == 1, there must be nr == 1.
+			 */
+			err = -ENOMEM;
+			goto unlock_out;
+		}
 
 		WRITE_ONCE(p->swap_map[offset + i], count | has_cache);
 	}
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch

