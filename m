Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795637844;
	b=NIzce8qiVuD9LdN/hCnTkXtln1XYKW38HkvRUM7ncawvZTvkH93regH7Ujuxk0YHJSc3
	 X3NaN//S3H4+6vPPUea9HFmEljO1rw21/Qx4TEtDAmNnuNemGsar/8HgzMIvM2isoLKmP
	 0CCHgCbJh3bSm40mSUJ+6UYyUXV3HHzyxkM93MjR35t1hIRBX4n6J9ii64jvkm9Di0NZz
	 vloYkm9MFb1o8zcbTrEeUhqt7AoWeFqNnBjDG2GaNvptHgLDl2NNFr18X1EcTXZgwPkWq
	 s1iANwGRbC8G50lTPOKmS6RCXFJa2Rc6rOILW/1Rvv5e9kL4j7KCct+hMOESZxLQf/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795637844;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=pQC8f2gT9qUq3JSKG2U6D45ognrZaqa2l4dHmaUTLTg=;
	b=dsokh0p86+QsWtJEsDmyBp8STicoIDSFbnxPRvHQGq9huN0RGU6iwPC4bFQz3UMiBwg1
	 DTXTSdLlThnfhz7y/G+BjAxynfcO1uf4+B67OnwOGk80VxAyjjdj58s7/l/UNuxjcmdf2
	 O6tx2Li3A43+HqHBsEaBmAcSYHqvsklFvOi8LDtRVrH/cH+a+fscSwpDeo+8yKZRvX1j6
	 aav8dMnatPvI4aTq5b6riModdfftpCRkmsiwzwvB91SBgfcnLFE4kd3XsEYw+7ectbjOF
	 KGWGddxWyXTIDr10ImwDDdefQOZLiMfe6bD1/C0dcL2ZTyrqA4dpFMV/3DebABEMndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vyriP2hh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E77B606A31E;
	Wed, 25 Nov 2026 20:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vyriP2hh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5872D1F000D3;
	Wed, 25 Nov 2026 20:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795637843;
	bh=pQC8f2gT9qUq3JSKG2U6D45ognrZaqa2l4dHmaUTLTg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=vyriP2hh9isQQb7VqWs4C7XrlYM0ziV3/QwrAwNxBK2hIBb17qlDJybLHRDdEF/pD
	 UwJZBspqYHit4x5eVSLAIaqx/2xgiNDQDLQctZLohvE/5ZggFJerebNKHbAi+4mvHF
	 f6oELoD8BNWlOUneWrHOhe7a9MFxrciksffO12Kc=
Date: Wed, 25 Nov 2026 12:17:22 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	stable@vger.kernel.org,shakeel.butt@linux.dev,qi.zheng@linux.dev,
	mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,harry@kernel.org,
	hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,
	zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125113518.1207280-1-hui.zhu@linux.dev>
References: <20261125113518.1207280-1-hui.zhu@linux.dev>
Subject: + mm-mglru-reset-the-mm-iteration-cursor-in-try_to_inc_max_seq_nowalk.patch added to mm-new branch
Message-Id: <20261125201723.5872D1F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-reset-the-mm-iteration-cursor-in-try_to_inc_max_seq_nowalk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-reset-the-mm-iteration-cursor-in-try_to_inc_max_seq_nowalk.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
Date: Wed, 25 Nov 2026 19:35:18 +0800

try_to_inc_max_seq_nowalk() advances mm_state->seq without walking the
mm_list, but unlike iterate_mm_list_nowalk() it leaves head and tail
alone.  If it races with an ongoing page table walk, the cursor is left in
the middle of the fifo.

The next walker reads that as "this generation already started": it skips
reset_bloom_filter() and resumes after the cursor.  The mm it visits are
the ones the aborted walk never reached, so they have no bits in the
filter being read and walk_pmd_range() descends into none of their PMDs. 
Those mm miss a generation of accessed-bit harvesting, so their aging is
less accurate and hot folios can be under-promoted.  Eviction can still
detect their references via rmap and lru_gen_look_around(), so this
weakens aging rather than guaranteeing reclaim and refault.

Reset head and tail with the seq increment, as iterate_mm_list_nowalk()
does.  It is safe: get_next_mm() holds an mmgrab() reference and a
concurrent walker bails out at "walk->seq <= mm_state->seq" before
touching head again.

Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
memory safety issue, since lru_gen_del_mm() repoints head and tail under
mm_list->lock.

Link: https://patch.msgid.link/20261125113518.1207280-1-hui.zhu@linux.dev
Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: <stable@vger.kernel.org>

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c~mm-mglru-reset-the-mm-iteration-cursor-in-try_to_inc_max_seq_nowalk
+++ a/mm/vmscan.c
@@ -4767,6 +4767,8 @@ static void try_to_inc_max_seq_nowalk(st
 		spin_lock(&mm_list->lock);
 		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
 		if (max_seq > mm_state->seq) {
+			mm_state->head = NULL;
+			mm_state->tail = NULL;
 			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
 			success = true;
 		}
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-in-zone_page_state_snapshot.patch
mm-compaction-annotate-data-race-for-zone-free_areanr_free.patch
mm-mglru-use-a-smaller-batch-in-fill-drain_evictable.patch
mm-mglru-reset-the-mm-iteration-cursor-in-try_to_inc_max_seq_nowalk.patch

