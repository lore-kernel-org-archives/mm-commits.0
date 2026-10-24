Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832530;
	b=4bn1GV5moGdCt3VnAgJq1PCFr3LjcO8d8T92LvNX0VAurR/wtxsdz/TM58Bz8loo/iix
	 xsdkMXKHgL/KLWGB4Ft1jpfOzSom2u2QlRodNEeZfnDDcJiNwYWFy3rO8mUTVITOPaj2j
	 yjHtlcV2AHTzmVkN56/5FiDJq9b2zHTMPVtBNP9NPamkHbHpYC+2tRqwMFd/VpWXZ34vm
	 wjbhGK8O82o7Y3OJXlohSAdVwAsKDwLpe0OWCUyx6TCvjAzQtcNmYd3lOwxAHSx4RTiT4
	 nKz6LFn9tFoPR1NSvJ+Mo5EoGL5DU5oenaKdooIRfHkaU1q/kKvk+qhFP6vzFK9wCMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832530;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uG+v7FV8m7lQX5AMIpimqjVPyv38AWQKh3vXbEloEUQ=;
	b=3ZmMdnYutLOEmlLPv7YiBCQMKQMi/jJqbeycesAKbUTQNtv+SweweKg1+/7f0vWysgeF
	 QbaF0gwU8yUwP2T1/enCTUO343eU1HIt48M2tN941Ry5+8QswbNZ6xuW0cqLBbz0eq7JV
	 MMsVdD16QpeCkGDPWUSJViSXbEbDKRpedz1ACrdThfkBEof+NnoFm6VnIZNkVsdFLgypp
	 JfTgUryv5jr4nYp6tM5o17jcxkKmTwaQFD77tceHRORXmffNx+wZJVk8WVo/TqnWOyg8n
	 PzN0ObSZkrgIMUSpoJLbouM+G/nMIBDBxyAeSO8pov82es1mbXoQuvavpgqHr/MQOgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jENY73oc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D188606A31D;
	Sat, 24 Oct 2026 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jENY73oc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EBB1F01828;
	Sat, 24 Oct 2026 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832530;
	bh=uG+v7FV8m7lQX5AMIpimqjVPyv38AWQKh3vXbEloEUQ=;
	h=Date:To:From:Subject;
	b=jENY73ocQP0T/1uveWQk4A38l7lMC4mDxRU223xOoJ2/hKxdOMYTYmf2Ydrac+5GT
	 L+zGwVayB4YIZYn5AzqGKHItCudT3yV2rwMMwO0eyCHAagHGQHNRic/CHWMYpu1AOS
	 ZZy4Mn0WN+1beOETVZCD/3q8EkKamRkyHrmDW4ME=
Date: Sat, 24 Oct 2026 02:02:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,riel@surriel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,kylebot@openai.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch removed from -mm tree
Message-Id: <20261024090210.66EBB1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/page_vma_mapped: continue past nonmatching huge PMDs
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-continue-past-nonmatching-huge-pmds.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kyle Zeng <kylebot@openai.com>
Subject: mm/page_vma_mapped: continue past nonmatching huge PMDs
Date: Thu, 15 Oct 2026 18:15:49 -0700

A PTE-mapped large folio can straddle PMD boundaries after an unaligned
mremap().  If the first part is discarded and replaced with an unrelated
huge PMD, page_vma_mapped_walk() stops instead of looking for the rest of
the folio in subsequent PMDs.

This also affects migration entries.  A walk that stops at an unrelated
huge PMD can leave migration PTEs behind when migration or an anonymous
folio split restores the mappings.  Those entries do not hold mapping
references and can outlive the source folio.

This issue can lead to memory corruption and I have a reproducer for
it.

Skip the current PMD rather than ending the walk on a flag or PFN
mismatch.  Do the same if the PMD became nonpresent before the locked
recheck.  Release the PMD lock, clear the per-PMD state and advance with
step_forward(), so the existing range limit controls termination.  This
covers present, migration and device-private huge PMDs while preserving
the matching-PMD and split-to-PTE paths.

Link: https://lore.kernel.org/20261016011549.61146-1-kylebot@openai.com
Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>
---

 mm/page_vma_mapped.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-continue-past-nonmatching-huge-pmds
+++ a/mm/page_vma_mapped.c
@@ -265,28 +265,28 @@ restart:
 				softleaf_t entry;
 
 				if (!(pvmw->flags & PVMW_MIGRATION))
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (pmd_is_device_private_entry(pmde)) {
 				softleaf_t entry;
 
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				entry = softleaf_from_pmd(pmde);
 				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			} else if (!pmd_present(pmde)) {
-				return not_found(pvmw);
+				goto next_pmd;
 			}
 			if (likely(pmd_trans_huge(pmde))) {
 				if (pvmw->flags & PVMW_MIGRATION)
-					return not_found(pvmw);
+					goto next_pmd;
 				if (!check_pmd(pmd_pfn(pmde), pvmw))
-					return not_found(pvmw);
+					goto next_pmd;
 				return true;
 			}
 			/* THP/device-private pmd was split under us: handle on pte level */
@@ -299,8 +299,7 @@ restart:
 			    (pvmw->nr_pages >= HPAGE_PMD_NR))
 				sync_with_folio_pmd_zap(mm, pvmw->pmd);
 
-			step_forward(pvmw, PMD_SIZE);
-			continue;
+			goto next_pmd;
 		}
 		if (!map_pte(pvmw, &pmde, &ptl)) {
 			if (!pvmw->pte)
@@ -343,6 +342,17 @@ next_pte:
 			pvmw->ptl = ptl;
 		}
 		goto this_pte;
+next_pmd:
+		/*
+		 * A large folio can be PTE-mapped across PMDs, so a
+		 * nonmatching PMD does not end the walk.
+		 */
+		if (pvmw->ptl) {
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+		}
+		pvmw->pmd = NULL;
+		step_forward(pvmw, PMD_SIZE);
 	} while (pvmw->address < end);
 
 	return false;
_

Patches currently in -mm which might be from kylebot@openai.com are

mm-khugepaged-flush-deferred-unmaps-before-dropping-a-failed-folio.patch

