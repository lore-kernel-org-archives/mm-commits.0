Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832444;
	b=hIKy6gDKrMWzLs/Mht5VK0vp7s8ftEnWUQAtp6STD2fKJGHa9/Z2ujOgYgnk9VKwT+J2
	 uQOMHXejNBZZsLnUN0Sdaxup/sg8Tvc3Nkw2i3gV3kG0hruGpif7HBQ7KfasiV/r3D3Wg
	 r5xdUB5dTMlXn0NZWR1X3Rp/X0X/7J9562TsVVF63nYoYSvvZpB1c+dj1nYDCZIfKTFOM
	 E7E3lC2b6NbLsZiqBkZbkffD2gdhueMtzQ87Hn2cJRZRxVNukLCr+QbcM1cn7BFeuUNzt
	 DpnxVUBEK2rYebJ4xcKDrD9PzVowpu9y57yZwFeZ3wyVnA1uR1VUfSVaravkvE1Gkdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832444;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PYYI7iqc+YW0XnMLgRPVnetMTvk2ig6MEQTFVChqjIc=;
	b=R1n+q5nLNmua1n13txYRR1F5jFej9GAH2WI6kVoMnoRRFRG2yO1GkW/Zb5kjPT7LV/I8
	 7694iAFnzKVXOtBoBASiQT8GFAL+xXWoytIiIBDGKswLqc9AYMcetVF8kaSNf6hnVQUrD
	 lp1/dtt2ZhcvX5JqIAyNzd+A1r4mv0oiOmxMuBOJhdDnJ9kVQ1q8zvlyDsAEdCW97xsNZ
	 z0duw+iQVSFOTl6LO1O37hatn7u8c+kkvsd54RHdSORxbzrLP5+mRG/tHIr7VPxxd/Z8u
	 ERfA6GUD+BrdYMYxBLgX6K8mg8t+b+9CvrK0rPtKhwuprj0Vijji7wbI98OL8a8YxOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YO+QD57l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E87606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YO+QD57l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9451F01825;
	Sat, 24 Oct 2026 09:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832443;
	bh=PYYI7iqc+YW0XnMLgRPVnetMTvk2ig6MEQTFVChqjIc=;
	h=Date:To:From:Subject;
	b=YO+QD57laGoyRili1RvkvbrIICUyeuaVwgha5+Iw0nlTV2Z4+JHHyjp1ifv3OOkT5
	 MOUGiDpdUDJEI3UKR1XIvRcce99VPj4m8o1rC5JrAHelz+oJq4GnxH8WUx6Crdb1Yn
	 icUhij8E1u2Z2L5RKk/PKGVdfNAmRB7CvsLm/JL4=
Date: Sat, 24 Oct 2026 02:00:43 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,joshua.hahnjy@gmail.com,hch@lst.de,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,alex@ghiti.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-submit-the-last-readahead-batch-before-unplugging.patch removed from -mm tree
Message-Id: <20261024090043.9D9451F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/swap: submit the last readahead batch before unplugging
has been removed from the -mm tree.  Its filename was
     mm-swap-submit-the-last-readahead-batch-before-unplugging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm/swap: submit the last readahead batch before unplugging
Date: Thu,  1 Oct 2026 10:57:12 +0200

Since block swap I/O is batched in struct swap_iocb, swap_add_folio() only
appends a folio to the pending batch when its slot directly follows the
previous one, and submits the pending batch otherwise.  Batches submitted
inside the readahead loop go through the plug, where the block layer can
still merge them, but the final batch is submitted after blk_finish_plug()
and always becomes a separate request.

So submit the final batch before finishing the plug.

Link: https://lore.kernel.org/20261001085730.2029773-1-alex@ghiti.fr
Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
---

 mm/swap_state.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap-submit-the-last-readahead-batch-before-unplugging
+++ a/mm/swap_state.c
@@ -906,8 +906,8 @@ struct folio *swap_cluster_readahead(swp
 			continue;
 		folio_put(folio);
 	}
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
 }
@@ -1019,8 +1019,8 @@ static struct folio *swap_vma_readahead(
 	}
 	if (pte)
 		pte_unmap(pte);
-	blk_finish_plug(&plug);
 	swap_read_submit(&ctx);
+	blk_finish_plug(&plug);
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
_

Patches currently in -mm which might be from alex@ghiti.fr are


