Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB76420E8F
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525596; cv=none; b=eLoa4CIVpTaXD/iPCOAadCQVOto+bbW6THsBhHrFsa1TOsp+LOp3QKKeICupZT3EgopHDXpvJPw2Hcklnsmo/h7NCxobWKad0G80OB1bCBG/0MktjxI5WUrwTBcS9ihOvdsRQKvcSzN9T4p3Vjs64hTlGRp8uLNaGgNYsCAg8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525596; c=relaxed/simple;
	bh=NFffHiHawkMDfTfM7oS/qys53BVyOQrqq33IRZHgQbE=;
	h=Date:To:From:Subject:Message-Id; b=uF+RpFR9+gV6/7ZWif9LfpizMS7HnAhHp8th/1LlQVsoiTdlS2MKHDapqvYy8Fq52Mom3FHjj4Imkn9U/mJ6It/Pj1aQWKj2U3A/ijFE68AviEDsJ7mKsPN7HvhPqj/EL+toI6sFnXmPfbipZrGo+SBxHZ1YInZFOp8k9q07r0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=emPnMOot; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="emPnMOot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C73A1F0089A;
	Fri,  9 Oct 2026 05:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525591;
	bh=Ca/+ciA65xIZ5ATd/fSMXXfFCDYhaT2h8q7F/2Gr2c0=;
	h=Date:To:From:Subject;
	b=emPnMOotPpsg5KqySOQxbLfe4m2j6VX9JYFFDAK9wFf8yJBuv/AuReZQ5BxbKfAjE
	 4iku6XeDz/nE4gD5PfQKt0rrV8YO9yMv1+WgaU0bHrcNeiENCLDS8HEt86x+dWYnhY
	 13fYkGKDmdjcgzpr4mWAb+zUJptD9SXLnjVYBCQU=
Date: Thu, 08 Oct 2026 22:59:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,youngjun.park@lge.com,yeoreum.yun@arm.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shivamkalra98@zohomail.in,shikemeng@huaweicloud.com,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,nphamcs@gmail.com,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch removed from -mm tree
Message-Id: <20261009055951.5C73A1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: fix off-by-one in swap cache replace sanity check
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap: fix off-by-one in swap cache replace sanity check
Date: Wed, 23 Sep 2026 23:32:32 +0200

Patch series "mm/huge_memory: clean up and decouple the anon and file
split helpers", v6.

The folio split path handles anon, page cache and swap cache folios in one
routine.  That mixing is what makes the swap cache split restrictions hard
to lift and to review.  We now support uniform split to order-0 only, and
no mappingless swap cache folios.  And it has left a fair number of dead
or redundant checks behind.

This series prepares for lifting those restrictions by cleaning up the
code first: split the routine into an anon and a file helper, and keep all
swap cache handling in the anon helper.  The file helper never sees a swap
cache folio, folio_check_splittable() rejects them up front.

Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
splitting (patch 12), this is a pure cleanup.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 over 600
runs on the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on the
same x86-64 box (interleaved runs across alternating reboots.  135 split
calls per run, 600 test runs):

Before: 68.52 us, stddev: 1.58
After:  67.38 us, stddev: 1.33

The patched kernel is slightly faster.  The stack usage and object size
change as the config and compiler change, but in general the stack usage
is reduced and object size is basically unchanged.


This patch (of 17):

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates the old
folio's range with "while (ci_off++ < ci_end)", so the loop body runs on
the already-incremented offset: the first entry is skipped and one entry
past the range is read.  For a folio split that entry belongs to the first
after-split folio and was just repointed by the replacement loop above, so
the check would warn spuriously whenever sub-folio orders differ from the
head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com
Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-1-ba1b4ba72c6f@tencent.com
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/swap_state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check
+++ a/mm/swap_state.c
@@ -396,8 +396,9 @@ void __swap_cache_replace_folio(struct s
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are


