Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1192330652
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465709; cv=none; b=mN8kOYKwTMJZvTpr8tuQ0Mq+DMDHHQdjBBU1PbLZe6tG/ysEQCvSe7rFJj70EPlhN5Ware1HvlQ7jv1rMWvUZH7DvX7Iyf0v4bLtMMT85L66RkQOaMwcEluGw02FSschujj9CgWtPB1TUFzKkUMPaHrz1mdMooHrF8RKaYbQyfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465709; c=relaxed/simple;
	bh=2WG6si6oM7RmigsPBrtsE6bqSwGO622zymgWqpQIJ+w=;
	h=Date:To:From:Subject:Message-Id; b=ttSZO4LPhXO1Px5Sfw/BWKlUCdcWHl7/MnGPC1q2jXLG5DU1d7aMa1qiYA4NeW3MfK8VMfieEkRDX8JaQcREBAOncjBLwMZF4ykFOHP93wnzpFMjkyaASkQEJH6AViX8XMgjBUafWwwbvOg8zkyTp6RUQoloGKejbUUI00/XRTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FefaXqhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FefaXqhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7852D1F000E9;
	Fri, 31 Jul 2026 02:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465705;
	bh=Kkp2CPBwGcUvUljbCQaVCk9aHk2UlnhM6oSSpm5ea90=;
	h=Date:To:From:Subject;
	b=FefaXqhptfSPMLPRFBYQdhaHvgFqa7z/wbICFu3brKc1zK8wA62mmmA/SReZWCGZb
	 u8EDHrsdtb3Bp9kixKU1rTJ4Q3FbV6I6v8fq5b6gw5cxOKI5RpzdNPkgP3OaaKAUW8
	 wBhEQXstUoeKuZAM+L0NxgW9tueINH0e6xgo/20Q=
Date: Thu, 30 Jul 2026 19:41:45 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch removed from -mm tree
Message-Id: <20260731024145.7852D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN logic
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN logic
Date: Mon, 29 Jun 2026 16:04:06 +0800

folio_check_references() will return FOLIOREF_RECLAIM_CLEAN for referenced
file folios, indicating that we can proceed to reclaim clean file folios
or keep them if they are dirty file folios.  However, after commit
6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer attempt to write
back filesystem folios through reclaim.  Instead, we always activate dirty
file folios and wakeup the flush workers to write them back.  As a result,
the FOLIOREF_RECLAIM_CLEAN logic is now redundant: for dirty file folios,
we will no longer reach the 'references == FOLIOREF_RECLAIM_CLEAN' branch
in shrink_folio_list().

Additionally, lazyfree folios are also placed on the file LRU list, but if
a lazyfree folio becomes dirty, try_to_unmap() will fail and thus prevent
reclaim of the re-dirtied lazyfree folios.

Therefore, we can drop the FOLIOREF_RECLAIM_CLEAN-related logic.

Link: https://lore.kernel.org/def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic
+++ a/mm/vmscan.c
@@ -823,7 +823,6 @@ void folio_putback_lru(struct folio *fol
 
 enum folio_references {
 	FOLIOREF_RECLAIM,
-	FOLIOREF_RECLAIM_CLEAN,
 	FOLIOREF_KEEP,
 	FOLIOREF_ACTIVATE,
 };
@@ -920,10 +919,6 @@ static enum folio_references folio_check
 		return FOLIOREF_KEEP;
 	}
 
-	/* Reclaim if clean, defer dirty folios to writeback */
-	if (referenced_folio && folio_is_file_lru(folio))
-		return FOLIOREF_RECLAIM_CLEAN;
-
 	return FOLIOREF_RECLAIM;
 }
 
@@ -1235,7 +1230,6 @@ retry:
 			stat->nr_ref_keep += nr_pages;
 			goto keep_locked;
 		case FOLIOREF_RECLAIM:
-		case FOLIOREF_RECLAIM_CLEAN:
 			; /* try to reclaim the folio below */
 		}
 
@@ -1381,8 +1375,6 @@ retry:
 				goto activate_locked;
 			}
 
-			if (references == FOLIOREF_RECLAIM_CLEAN)
-				goto keep_locked;
 			if (!may_enter_fs(folio, sc->gfp_mask))
 				goto keep_locked;
 			if (!sc->may_writepage)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-convert-folio_referenced-to-use-vma_flags_t.patch
mm-vmscan-add-a-helper-to-identify-file-backed-executable-folios.patch
mm-mglru-promote-mapped-executable-folios-after-first-usage.patch

