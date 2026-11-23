Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415132;
	b=5I4/P60CcDkH3bMz5Pwg4zSF+a9LIBF2Tq1Bu2WgLsl+e+cUtjaDCYxG41TtQ5TOC9kM
	 esRDxyJmCCBmS9i6FnOE0d3VJzytbnpgAWM0CcVNLIvee74iN15MyRFHxdecQyyxFEv8w
	 3+4Pgn+V53mhCcjp5UgTy0rr4LutsrT5BX1uDO0fJaMtBDQliTGk6Ov3Z8f+RNO6dA+Qa
	 r8fcGFP9MqtRwj/KOAXr5KVcMpUWXXZrXFUIwg7yOzFQfSk0SmrGUVxN0vPVteVPHHNEP
	 ccTZPuAy/SdVUEqH09R/fuZ7Lmcr+Ix9NEgUL4F2pTBpYL0AsgPpuPC0J+etloHzSew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415132;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=rdf0zAHKQ6uu8bvgyFB5K8RILiYuHoNOtHIPwH9VCZI=;
	b=4JMvWZ3WagseYEppGxa/bNIlBcAJgT85DxlDAU2FCTbp4o/6Gt+F7ZHX5k+9e38Hdxz+
	 0XbOht7iaGJeoEiFMIbXRsv6dWhj4POmrVgFiykBLgqr9hM7pVCf+R/xWz5W4784d2g6y
	 LOcwtLDPgXEnF+0VgQqgJ0Xbx/tQJJNvzmUd3qvCba/VBaC2umTAgbPUnRqsFq50OCj/8
	 PUBU7Jix9NInz65B7a5BnXwIx20u+D/tC4haimFKMU3kS2C2LvdPWZWcl4CpYxVgEP39P
	 fFpE6g0+tYy+0SIohrR9c2yipN8cy/dlCGc+ZYo6mhco7zrHh8yzrBSK/cWaUbvGEfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XFFZZytH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8242D606A321;
	Mon, 23 Nov 2026 06:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XFFZZytH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263021F000C6;
	Mon, 23 Nov 2026 06:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415132;
	bh=rdf0zAHKQ6uu8bvgyFB5K8RILiYuHoNOtHIPwH9VCZI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=XFFZZytHWybp3mynQSJ6wT3ECqJ0Q4BWZAzipyHK7+KrjLGlFgbYVRGI6ax3N31Fv
	 G1q8YYqUyhm7WwXVqmfWPgjJ/ExnDF3B4VDsuKvMobruYOxRNUa6tfurLQgHUcSdPW
	 gwLPX6g15QEvGRRI/HP9fXBmA4hdzJdoPlxrtBgY=
Date: Sun, 22 Nov 2026 22:25:31 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@kernel.org,
	surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,kasong@tencent.com,david@kernel.org,
	baohua@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261109021611.22247-1-hui.zhu@linux.dev>
References: <20261109021611.22247-1-hui.zhu@linux.dev>
Subject: [merged mm-hotfixes-stable] mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch removed from -mm tree
Message-Id: <20261123062532.263021F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Mon,  9 Nov 2026 10:16:11 +0800

lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
clearing the refs or PG_workingset.

A MADV_FREE folio therefore keeps the state it had before madvise(2),
even though madvise_free_pte_range() has already cleared the accessed and
dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
younger, and PG_workingset puts it in the last tier, so sort_folio()
promotes and protects it instead of evicting it and charges it to
lrugen->protected[], which read_ctrl_pos() uses to balance anon against
file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
so this repeats every time the folio reaches the oldest generation.  If
the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
lru_gen_eviction() packs the stale state into the shadow entry, so a
later refault is promoted to the youngest generation.

Call lru_gen_clear_refs() while the folio is still on the generation
list, as deactivate_file_folio() and folio_deactivate() already do.  Its
return value only says whether the folio is in the oldest generation,
which lru_lazyfree() does not need because it re-adds the folio below.
Keep folio_clear_referenced() unconditional: the classic LRU needs it,
and it also covers the folios that lru_gen_clear_refs() skips.

Link: https://patch.msgid.link/20261109021611.22247-1-hui.zhu@linux.dev
Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: <stable@vger.kernel.org>

 mm/folio.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/folio.c~mm-mglru-fix-a-no-op-lru_gen_clear_refs-call-in-lru_lazyfree
+++ a/mm/folio.c
@@ -623,12 +623,10 @@ static void lru_lazyfree(struct lruvec *
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
+	lru_gen_clear_refs(folio);
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	if (lru_gen_enabled())
-		lru_gen_clear_refs(folio);
-	else
-		folio_clear_referenced(folio);
+	folio_clear_referenced(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch
mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch
mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch

