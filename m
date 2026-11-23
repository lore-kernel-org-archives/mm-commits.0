Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415099;
	b=ayG9E7SmhrwF1+thui94qI0lKCHX/zdTbWlksxppk1BePiRTZUlof1m0ndfAoWOlCQN2
	 smxdlUPXS2fY2ujXmv6GAf+akdje2rwusnM6M2zVXlm6xi5EMgVx6pZjymKgIMjXi8b88
	 sruFJ0O58MhK/ATRu9Hi+4zeEwOLfM3WtRS2xIN59W6ianEnaKr80geAAZl/7M1qxerhN
	 Qlm9ByGQdbccR4sb73PxvedOcsxP6rD3K3dVi4V+gWXZuekq8uzq5K4jfzdV2zAdiAB9b
	 2Dexm/zjRpeIm9vM9tb58FIBwjVRYVj8Izmtsbl34vr5umV3Li3Ih8fBqVbNYQ6jYPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415099;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=haG0CibP8g4E0+nLjPt6N5pjPZOaA96qKSIcOhFsubA=;
	b=ydKwi6NxZeY87inftt1FJnW6oKKptXME/ZVgH76r6+Em3340mL+8njOlhaWddyD8F5Dl
	 hlMYQlJNe/ltYQCaw17wt02x1j7qh7A76MmR7AcKPoMI2ptdPlQ1EK2SALGk1gdXz2kZG
	 iZg6zBeWDFz763gclgLXa9c3w+4YzTLDyzNw72MccHYunj69NHDTfXkt0AGhtc2ZySBE/
	 IhTsy5Am0Yu+jzXRwfm6TUAjMunD3FP7iA45hYjwEAWf+jw3hFd1EnBCeM2i2xSNnZf6e
	 E5E0YLs7oU94zOqsdbQ8S4S0BR6/35x1JOWmnhGFI5Ku346Gmpq90/+aLZoAyYdnuzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YHWubrmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3091606A33A;
	Mon, 23 Nov 2026 06:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YHWubrmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA441F000D3;
	Mon, 23 Nov 2026 06:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415098;
	bh=haG0CibP8g4E0+nLjPt6N5pjPZOaA96qKSIcOhFsubA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=YHWubrmh3F91lazgdBEuvsTHtTmdMfdB64GxPR46bcuh/Fkzm+HNX4s6n/v9IPyYt
	 sQm6LU18A9/GSxhnDXDPPpd4LmSxIRQaxxkCY3QudGXhFKMsQwjbzyLMob0A1/UWd6
	 nrTkhjwOjR326YlML6kw2g2TKuBH7uvx9yb9GoAA=
Date: Sun, 22 Nov 2026 22:24:58 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,
	willy@infradead.org,weixugc@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261110151407.789960-2-nphamcs@gmail.com>
References: <20261110151407.789960-2-nphamcs@gmail.com>
Subject: [merged mm-hotfixes-stable] mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch removed from -mm tree
Message-Id: <20261123062458.8FA441F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: vmscan: allow writeout of swapcache folios without anon mappings
has been removed from the -mm tree.  Its filename was
     mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nhat Pham <nphamcs@gmail.com>
Subject: mm: vmscan: allow writeout of swapcache folios without anon mappings
Date: Tue, 10 Nov 2026 07:14:05 -0800

Patch series "mm: fix swapcache writeout and cluster table races", v2.

Reviews of vswap and v1 of this series found bugs in existing swap code. 
Allow swapcache writeout without anon mappings, publish cluster tables
with the allocator locks held, and leave tableless clusters to the
allocator.


This patch (of 3):

Unfaulted zswap readahead folios can be dirty and in swapcache without
an anonymous mapping. pageout() rejects them before swap_writeout(),
so reclaim cannot write them out while their swap entries remain
referenced.

Allow swapcache folios through the filesystem folio check. They already
have swap entries and can use the existing swap writeout path. Anonymous
folios outside swapcache have no mapping and already return PAGE_KEEP.

Link: https://lore.kernel.org/20261110151407.789960-1-nphamcs@gmail.com
Link: https://patch.msgid.link/20261110151407.789960-2-nphamcs@gmail.com
Fixes: 84798514db50 ("mm: Remove swap_writepage() and shmem_writepage()")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-181078@kernel.org/
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christopher Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings
+++ a/mm/vmscan.c
@@ -714,7 +714,8 @@ static pageout_t pageout(struct swap_io_
 	 */
 	if (folio_ref_count(folio) != 1 + folio_nr_pages(folio) || !mapping)
 		return PAGE_KEEP;
-	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
+	/* Anonymous folios outside swapcache returned PAGE_KEEP above. */
+	if (!shmem_mapping(mapping) && !folio_test_swapcache(folio))
 		return PAGE_ACTIVATE;
 	if (!folio_clear_dirty_for_io(folio))
 		return PAGE_CLEAN;
_

Patches currently in -mm which might be from nphamcs@gmail.com are


