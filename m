Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793777177;
	b=KQTaux32xUANoef+XbLT3Y/g2EU/KrtxCXu9hmbXyUZ6tbc/n9LckLPq3HXmxgaB5MVY
	 krV2U/zXlP090WMdgoDKooAj9L3QumtcXS0AYefq7gzMlaoBl9zpE6o/vOUYVkYG4fx5D
	 /8zbydu22MMlrRWRRU9YAuaWaSu9i0sidicHHLJ4du+3eWZ1hZ5iaMx2gukLs6m5QiWn7
	 8B0GkPZPfr1QuWGMsf7DqR4e1UBJluOoTppsTJuRUp55OSL906xLX7ZEgE3V9maMh0STq
	 hg64e0ObvSxQ38RPELouBMlZ5PZmoEfz10hrLAlpU8+rB8N2E4rHKb44K4lTqLWkp+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793777177;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gqkOltD+7V4gOjDgNlHaUe0A1OssjIMRfOG7zDyJv8g=;
	b=s3aAcSVGf62UmErKEmaMgSNvftFvQNiJUt742MqoFqUUEkzcfzrhZ7d8LLhkx6rOoRRg
	 bP7XBDyL7LF5akdLSDkaBE8kVV3igqc0Aip6lPxzg+mYoNrJvKTWlICgnCf1tiV2H/KGf
	 MUev34ogbXFrSyRe7Sq5R5ApWWCX1CMSGnCA0FJjKsZ8HMwy7mqixxxZyLxBjnqPZnikV
	 RAfvo26EPnnPEVAbNtBDYdleDpFsvxLOUm0KDV0xgzMIF6mRweHm5p764tkk/FaG8XgIv
	 8CJFmjOWOEqUYoOujRCX9OveYRt9h8LEdm9U9NdAYOr2HWh0t1+oohclO0/2CRVN2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Z2vYunQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FED606A31B;
	Wed,  4 Nov 2026 07:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Z2vYunQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D721F000C1;
	Wed,  4 Nov 2026 07:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793777176;
	bh=gqkOltD+7V4gOjDgNlHaUe0A1OssjIMRfOG7zDyJv8g=;
	h=Date:To:From:Subject;
	b=Z2vYunQburGadqvNll6uBDXPO/jgorzLQzzTJrDOxCuEWAQ1pw+y2iV7evLUD5AN9
	 KTWFxfIcWSClKodAYsXxUhI8wXQNUeyaaAa2MMx1iCIaYlE+/U5k8fLdCbiZfaedA8
	 Dxk9BdDxytc+mbmFezBzXIU+tg69mi6wbxqqu6Pw=
Date: Tue, 03 Nov 2026 23:26:16 -0800
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,yosry@kernel.org,
	vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,
	stable@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,
	rppt@kernel.org,nphamcs@gmail.com,neil@brown.name,mt4022@columbia.edu,
	mhocko@suse.com,mason@kernel.org,ljs@kernel.org,liam@infradead.org,
	kasong@tencent.com,hch@lst.de,hannes@cmpxchg.org,hanchuanhua@oppo.com,
	david@kernel.org,chrisl@kernel.org,chengming.zhou@linux.dev,
	baoquan.he@linux.dev,baohua@kernel.org,josef@toxicpanda.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch added to mm-new branch
Message-Id: <20261104072616.88D721F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/zswap: drop the stale zswap entry of a zero folio
has been added to the -mm mm-new branch.  Its filename is
     mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm/zswap: drop the stale zswap entry of a zero folio
Date: Wed, 04 Nov 2026 00:18:14 +0800

Patch series "mm/swap, zswap: fix stale zswap data and swap-in bugs", v2.

There are some bug fixes found by AI and collected by David, mostly
originally from Anthropic.  After filtering and dropping a few that are
already being patched up by the community [1] [2], these are the 3 we
kept.  The accounting fix is in two patches now, the second one from
Johannes to cover asynchronous devices too.

Patches 1 and 2 are marked for stable, they affect v6.12 and later.
Patches 3 and 4 only affect v7.3 and later, so they are not marked for
stable.

The zswap bug in patch 1 can return stale data instead of the zeroes that
were written, so it is data corruption and seems critical.  The extent
fix in patch 2 is more urgent than it might look, as it can also read in
unexpected data, but the setup could be really rare.

For the extent fix, in the long term we might actually want to detect
extent contiguity and allow mTHP swap-in for single-extent swap files.
We already disable mTHP allocation for swap files, so the current fix is
trivial. It seems the most minimal and correct one for now.
Optimization and cleanups can come later.

Patch 3 gives up readahead batching for synchronous devices, as its


This patch (of 4):

A folio can stay in the swap cache after zswap_store() has stored it,
when a swapin fault gets a reference on it before reclaim can remove it.
do_swap_page() maps an exclusive folio writable and, for a read fault,
keeps it in the swap cache, so it can be modified and swapped out again
to the same slot. zswap_store() handles this, it replaces the old entry,
or drops it if the store fails or zswap got disabled, "otherwise,
writeback could overwrite the new data in the swapfile".

swap_writeout() does not get as far as zswap_store() if the folio is
zero-filled now. It only sets the zero flag of the slot, and the zswap
entry with the previous contents stays in the tree and on the LRU:

  reclaim            fault              zswap shrinker
  zswap_store(D1)
                     swap cache hit,
                     map, write zeroes
  swap_writeout()
    zero flag set
  folio reclaimed
                                        zswap_writeback_entry()
                                          swap_cache_alloc_folio()
                                          decompress D1, uptodate
                     swap cache hit:
                     maps D1

Swapin looks at the zero flag first, but only when it has to read the
folio. The folio that zswap writeback leaves in the swap cache is up to
date as far as anybody can tell, so the process gets its old data back
instead of the zeroes it has written, until that folio is reclaimed.

Invalidate the zswap entries in the zero-filled case as well. The folio
is locked and in the swap cache, which keeps zswap writeback away.

[kasong@tencent.com: fix zswap_invalidate() arguments]
Link: https://lore.kernel.org/20261104-swap-fixes-v2-0-204be064be5b@tencent.com
Link: https://lore.kernel.org/20261104-swap-fixes-v2-1-204be064be5b@tencent.com
Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <mason@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/page_io.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/page_io.c~mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio
+++ a/mm/page_io.c
@@ -224,7 +224,17 @@ int swap_writeout(struct swap_io_ctx *ct
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {
+		swp_entry_t entry = folio->swap;
+
 		swap_zeromap_folio_set(folio);
+
+		/*
+		 * The folio may have been stored in zswap before and dirtied
+		 * again while it stayed in the swap cache. Drop the old copy,
+		 * or zswap writeback would bring it back into the swap cache.
+		 */
+		zswap_invalidate(swp_type(entry), swp_offset(entry),
+				 folio_nr_pages(folio));
 		goto out_unlock;
 	}
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

