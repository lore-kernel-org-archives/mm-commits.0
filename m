Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832347;
	b=Quc5F+eNViKcVoih6IMqWboBBzb6u34SACuOYQQsAT6nphq0Jcs2ymhkhJ9Qtbrexh7Q
	 Wwt4sadK2uHoNqcyeTRhmu9ltMNjduaqn8HyDFnNt4xaHiFCeVwsSrWPJGA//CxqKjIQ5
	 CnBhQ1M8Jb9I2WkOLRKehoXwiO/bvBVoBJ/f1/BXhM6OZ+yWZziKPbaX8ybKKemWXOIsF
	 mJ4vYST009w1SgTW2wzjtFmIXphh1irtJ7fTiBrTpkhUrhYOX9IHBqugVh9qt/1fj9Y8h
	 5LwB0V2hofESQixT2RQAeNhmmuHuNYi1f4I7J6KxCUFI63xt2QS7CzK/0mrelwas1xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832347;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iwVswukaXdFZpyS1VGec5x5i14nc3gLCsnkFyzAM2CQ=;
	b=HZ5smIVFzWrpDZczOviOOGNgUCk3YtSnUEnPO+gz8S9IyQeyEPBe6BwzJn6mSBAd4g/S
	 7cJDppNqwWjX8NHgPG+9qFFF6jtgEK7g1bySstjqPWF8OnCDS592n7ZZ5zOIdTXIH4suD
	 p+i1g4vI98P9YLf9GHZ7LbxhVj/hHaQSGbDpoUYgn1GWTtzh+E5d5HrecYwqhv3cMtJAG
	 wxiGvLQ0aa3Ymn9o0+8Go8mrBV+dYzi5WginvzgQCLothBiVlai+Ah52MuSja307f5jAz
	 BeXBXEfOfcM4DsH977okZL3zpTF4wc9Fy3Z799JwzCr2Z+mp9KyXyGJ3vPRZaXTAwyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dBI1BheR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC05606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dBI1BheR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFA91F01828;
	Sat, 24 Oct 2026 08:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832346;
	bh=iwVswukaXdFZpyS1VGec5x5i14nc3gLCsnkFyzAM2CQ=;
	h=Date:To:From:Subject;
	b=dBI1BheRyZSg76jekK4y/Yf+ufd831CxtsC1Vsn67W952FIGMbvl3vehQsXJRsvFv
	 4IWe2+GWpPrHlDgWyx2Irsr99BYG4R32pS5ot8eDmLlP6Qjx6uEKYAKIbnj8WIatCB
	 a2yb/6U2yu01jr758ucyMGMci7Y/mq36Tmhu42T0=
Date: Sat, 24 Oct 2026 01:59:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rafael@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kbingham@kernel.org,kasong@tencent.com,jan.kiszka@siemens.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,dakr@kernel.org,brendan.jackman@linux.dev,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch removed from -mm tree
Message-Id: <20261024085906.9FFA91F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/proc/page: clarify comment in get_max_dump_pfn()
has been removed from the -mm tree.  Its filename was
     fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: fs/proc/page: clarify comment in get_max_dump_pfn()
Date: Mon, 21 Sep 2026 21:59:04 +0200

pfn_to_online_page() will only succeed on some PFNs within the same
section, not necessarily all.  Let's make that clearer.

While at it, rephrase it to "Allow inspection of".

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-12-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 fs/proc/page.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-clarify-comment-in-get_max_dump_pfn
+++ a/fs/proc/page.c
@@ -31,10 +31,9 @@ static inline unsigned long get_max_dump
 {
 #ifdef CONFIG_SPARSEMEM
 	/*
-	 * The memmap of early sections is completely populated and marked
-	 * online even if max_pfn does not fall on a section boundary -
-	 * pfn_to_online_page() will succeed on all pages. Allow inspecting
-	 * these memmaps.
+	 * If max_pfn does not fall on a section boundary, pfn_to_online_page()
+	 * can succeed on PFNs beyond max_pfn within the same section. Allow
+	 * inspection of these memmaps.
 	 */
 	return round_up(max_pfn, PAGES_PER_SECTION);
 #else
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

