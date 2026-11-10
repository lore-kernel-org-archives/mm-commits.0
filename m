Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794339380;
	b=AaFP4x3w48GPXq0jT5xv1VMmRXQOYZWQ5voJHbXVGBFyljuac3vQCa7R2yA7nvn1XIhs
	 EKEuVHQXgFYckUalamU0B0yGm61ReutqX6qDB96MLfZjvl552t1a2P9OZZk3j8kTHa5vc
	 wUgU5D+j6Q13SDrLc2cfGhSYqB7+hXc4vl4DD9juAQ7tcnAgvO9bAsAcGKiwfI89Mmvck
	 oQ0pcJhW/w73AYVjIUerELYIh8FoZwmwh3/27Z2OzEv3GIamTsbNxmE1z9wHyRQClN8XF
	 FiMp8+s1DNFBW3spdAKW4LmZvs+2VIo93nAZmbtb3WZotTQAZqeCJB2rnRAc50EJYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794339380;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yKI8uRbxWpKAgg0VxEj7KIuiAdskqV8+SQSmpYSxc+k=;
	b=YShAn2jMWPdkmZpNh7jrRHPPxHBhhl5H3BjYwPTnwVaVlr/PWHoHZKYhq/mwq+mmXcxL
	 iMZK3MRneGWQFCWmXvZ/HTTSR612jk9XOBYTstWs9mZKVEGAjPazpGrBYFTknPyf9nUpF
	 RZruFG51PVYBIx7NAqfc+7sMqJlfp5fP9kJ7jiR4h4Ogcn85TzNPk82wCmH09KIwUtGOJ
	 yRPoJ3u9RDEb/UcHAfe6rb1zdyHyp/3nRLNTAPppjb0lksJHNhMGibPuli7zh2f2IZiF0
	 XSPTUMJ6E5cgdTzGpuTNOBWsvLSHDT9mU8RWsLlSPBIfkR4d5doBC+FiZ/JKo8ISgyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="u0/qiNfO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FEA606A31C;
	Tue, 10 Nov 2026 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u0/qiNfO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5271F0089F;
	Tue, 10 Nov 2026 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794339379;
	bh=yKI8uRbxWpKAgg0VxEj7KIuiAdskqV8+SQSmpYSxc+k=;
	h=Date:To:From:Subject;
	b=u0/qiNfO2PazNmcFfMYFvtL3fpqq87JNts2cbMm5kMhes6pl+FUPovKECYcyIFHJO
	 3ylMYq/2nBTCocxpD5SCuhYFuPaNr5icitiJ+LyX9Tkffx26QvBe3ASW19SZD+lo4i
	 6ebCJRUojxWIO0FQzFSFRa/8Wdk/XyrHw74w6LW0=
Date: Tue, 10 Nov 2026 11:36:18 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,youngjun.park@lge.com,
	willy@infradead.org,weixugc@google.com,stable@vger.kernel.org,
	shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryncsn@gmail.com,
	qi.zheng@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,
	hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,brauner@kernel.org,
	baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	axelrasmussen@google.com,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch added to mm-hotfixes-unstable branch
Message-Id: <20261110193619.6F5271F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: vmscan: allow writeout of swapcache folios without anon mappings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Link: https://lore.kernel.org/20261110151407.789960-2-nphamcs@gmail.com
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
---

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

mm-vmscan-allow-writeout-of-swapcache-folios-without-anon-mappings.patch
mm-swap-publish-cluster-tables-after-reacquiring-allocator-locks.patch
mm-swap-skip-relocation-of-tableless-clusters.patch

