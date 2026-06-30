Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E8540D56E
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 00:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782778923; cv=none; b=bbJQ59HIPU4BHtRMw0087x4awlFrMO3oHpKXe4fpGHaz6PDCETjLULWEPqYd+rAPRqfX7ZVZwdWbjSUhAS/LqdFpi+n04uP2k9JZCKd1gSxWSOUVcrnauhAglOKCLq05UtCgEvr7cQQf9dO52+eap/Vb5Ep5XiF0d4xEQNmtsHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782778923; c=relaxed/simple;
	bh=bX170Dvag7xTa4Co2qqj++7vFviGxPHlCXx37eSPd5M=;
	h=Date:To:From:Subject:Message-Id; b=UUq2FKhOMUEu9SHg9REXub+BMg+7qIrcT43AOe73P0LxtFUl/NNwfTgOs190Rfjk+ExQoLALHZtdc67+JwtcsLw2j4NYv+IuoiZAmrhTAXVLZJ0ETIIWKGMKdkh2trU1HXdqnOEl46oGR4DH7JvM2NNTOEFI7CCKLmj/fWL+eZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ynUDnucs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ynUDnucs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD351F000E9;
	Tue, 30 Jun 2026 00:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782778921;
	bh=z8HpMFLoeRj+npz13LcpF35kIi6ybgO7TduEx3DaXOc=;
	h=Date:To:From:Subject;
	b=ynUDnucsDHYddrsUhh8J+h281O1clighN+wJ39X1j2a9AQTE3rEQBvXjO0n6l1Zo4
	 E0andD0iyHt+xKo0dBzEcQcyQTGHlTX4bflESXVHWyNSImP7Ue+KatUab+Fua9aOBX
	 Kz01RkATs1vvu6sinSalP71NG8DOf8tNga2cMSdc=
Date: Mon, 29 Jun 2026 17:22:01 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch added to mm-new branch
Message-Id: <20260630002201.9FD351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN logic
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch

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

mm-vmscan-remove-the-redundant-folioref_reclaim_clean-logic.patch

