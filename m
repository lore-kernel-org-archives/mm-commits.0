Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794545767;
	b=wne8wKcw2ca3NUeKX6BQSwQL7I/msbgUWHljbD/dZdod2U5iQxNzMB3BGZre8k5HnV4C
	 k1eRPCqM+8JkyDafpxk7L/bjuSNxfjeuWojIT/w1mRVSS4iH2Sj/p3dxwBgFwgtMEaILw
	 CwoFhZ+4h0msyAZi7EKjx+GAVcNtLEqzWjsZv0PAKCgkQ4Os5kMTxC6GTotNamMBVIlx0
	 PRmwgdgM8wR8WihOc6gwcBQPm7yyCuuRR0lzWLZka8zulvxBivD/3e/zM0j8bQDy2V2Zc
	 HCKQ2uPyJZPzws7vHV/ZFK86RDzadnuH+bgRe4hL4/lK74UbKkKUBLf2AceczE/VNnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794545767;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=We/st05orEIpntuW/9n+L0rBvBFlCCsWxwkiHvqr97s=;
	b=S0car8hGR0G5zAcwTgBbMo28csTYVGAzc4nVNVP1C40CWG31LjCQr+Qm4QcyGYO0nh3V
	 FHtqnfBqG7KM54H0kyNcRcGWDaPUT3uubgnnfNoQPr3XGoUTZl+vFn16KI/Eg+wlXx/Gg
	 Q3mja9M+C9aR+5Y6S0QNgmsz+m7LNZNJvpoXa+EZznPQar7XtoMvfjGU34CoJVEazamDP
	 LT8bZXBZ8F6q+YC7HfRx/kofBOJwC6cieOdWO3furi59IWIxnqgd0IAm0cZfMONfpcd7+
	 eLPaQT0fVPdvvjafPfgnV1NzJdbRjNohLYIiTW9hD2GuouENp9c76HkNv3IwfSAHzpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tIgYu0hn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BE9606A335
	for <mm-commits@vger.kernel.org>; Fri, 13 Nov 2026 04:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tIgYu0hn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8F01F000C4;
	Fri, 13 Nov 2026 04:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794545766;
	bh=We/st05orEIpntuW/9n+L0rBvBFlCCsWxwkiHvqr97s=;
	h=Date:To:From:Subject;
	b=tIgYu0hnt4AdOWTxaJxVPn0lPWTUyItgqlNx7vYsjkrxgDQompQnF/FPsRKli6PdM
	 +5EnHloEGjIzOdmiiBwcVu9vCGLwyfrUPrNYtGT0qcVliMDox89Y0/kuDXzRVra9oe
	 YMd4h3up1TIfCfxEbkyWc8mGjN1Kd/BAiu9bGdUI=
Date: Thu, 12 Nov 2026 20:56:05 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,qi.zheng@linux.dev,mhocko@kernel.org,
	kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,
	baohua@kernel.org,axelrasmussen@google.com,baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch removed from -mm tree
Message-Id: <20261113045606.2C8F01F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: mglru: use pte_table_clamped_end() helper to calculate the end
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: mglru: use pte_table_clamped_end() helper to calculate the end
Date: Thu, 12 Nov 2026 19:12:39 +0800

Use pte_table_clamped_end() to clamp the range to the PTE table and VMA
boundaries when batch-checking young flags, making the code more readable.

No functional changes intended.

Link: https://lore.kernel.org/b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-mglru-use-pte_table_clamped_end-helper-to-calculate-the-end
+++ a/mm/vmscan.c
@@ -4340,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma
 	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
 
 	start = max(addr & PMD_MASK, vma->vm_start);
-	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
+	end = pte_table_clamped_end(addr, vma->vm_end);
 
 	if (end - start == PAGE_SIZE)
 		return true;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-synchronize-with-pte-table-reclaim-for-all-folio-sizes.patch

