Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7B0277CB8
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744957; cv=none; b=EVojxFphk0dhNRP4JoatBowbuRRF/BdSM+NtiQYHfxn1hV4BmgMC+Iv2Sxg/v3DbMTzbVg0vR07pFk5SQq3ht9T9Uxb9PB0Tjj5d3gL/EGVlInzqPoF02MhcGGwG0MJhpPr9TpmzMlaaMOU1cWMFgF0+SaS5WHMuRg4fvfra1GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744957; c=relaxed/simple;
	bh=VmQAHjFt/nLXl7fjgrEohRmyNaQ6zvwMe12Dysoyia8=;
	h=Date:To:From:Subject:Message-Id; b=eq6FGNfww2seqg8yESOx5KMsUSEa5EdGDZ/LVFk+nSw4LkSt6f1StXlBnmazaCX9YJmtNhn3E6bbMhsPiJO32bkyTjcYHln1uRTmf6HnnO/daffqqC7EvtbKQFDN8wV8P3ifLyoHgIEgyH8d34w5eY86NcgJl/RLIUHlkwqmWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uXSmzX9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uXSmzX9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BD1C4CEF7;
	Sun, 29 Mar 2026 00:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744957;
	bh=VmQAHjFt/nLXl7fjgrEohRmyNaQ6zvwMe12Dysoyia8=;
	h=Date:To:From:Subject:From;
	b=uXSmzX9M0ebgromZ8jFU4qXjX5K7bMlSeF8A1Mel3pTWpSq5fjLPsM1+YHLscMWrZ
	 wBiYUvHbociuRqgX9esjn7GBv6sVupASu+8uJBT4m2YVzs9PagiHIyLAYogj54gfbQ
	 /BaeuAnhz6S5oA/LzinKUy3sJIXxlzN4oxQXjwwQ=
Date: Sat, 28 Mar 2026 17:42:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,nphamcs@gmail.com,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,julia.lawall@inria.fr,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,axelrasmussen@google.com,kexinsun@smail.nju.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch removed from -mm tree
Message-Id: <20260329004237.A4BD1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update outdated comments for removed scan_swap_map_slots()
has been removed from the -mm tree.  Its filename was
     mm-update-outdated-comments-for-removed-scan_swap_map_slots.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: mm: update outdated comments for removed scan_swap_map_slots()
Date: Sat, 21 Mar 2026 18:58:14 +0800

The function scan_swap_map_slots() was removed in commit 0ff67f990bd4
("mm, swap: remove swap slot cache").

The three comments referencing it simply noted that ->flags can be updated
non-atomically by scan_swap_map_slots() to justify a data_race()
annotation.  Since the function no longer exists, drop the parenthetical
reference while keeping the data_race() justification intact: ->flags can
still be updated non-atomically by other paths (e.g., swapoff clearing
SWP_WRITEOK).

Assisted-by: unnamed:deepseek-v3.2 coccinelle
Link: https://lkml.kernel.org/r/20260321105814.7053-1-kexinsun@smail.nju.edu.cn
Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    4 ++--
 mm/vmscan.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_io.c~mm-update-outdated-comments-for-removed-scan_swap_map_slots
+++ a/mm/page_io.c
@@ -450,14 +450,14 @@ void __swap_writepage(struct folio *foli
 
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
 	if (data_race(sis->flags & SWP_FS_OPS))
 		swap_writepage_fs(folio, swap_plug);
 	/*
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
 	 * is safe.
 	 */
--- a/mm/vmscan.c~mm-update-outdated-comments-for-removed-scan_swap_map_slots
+++ a/mm/vmscan.c
@@ -1065,7 +1065,7 @@ static bool may_enter_fs(struct folio *f
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO
 	 * providing this isn't SWP_FS_OPS.
-	 * ->flags can be updated non-atomically (scan_swap_map_slots),
+	 * ->flags can be updated non-atomically,
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
_

Patches currently in -mm which might be from kexinsun@smail.nju.edu.cn are


