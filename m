Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832516;
	b=ZYuBEmDVtff5/7ZpZxOh8IEQLmbP0vauCLZ7vsKJP4z5AeIXMOXoQx270OQz8tXKQo/m
	 WCbBj5lH6phX+jaQlETzxkYEuMcuoehmpfFRH0KWWoywwMM664AcV85gWB1OaNS+7CckT
	 FP8GgwGFwVgRVth/IF6Ck9mRimmKrX8oiw4ijL8FQvvhe06ZPNEzSaMtExjMGQtGAGzOI
	 RDIsvgCzU1afA8oSqBJnCOAAM009xQ/zFL7qXiygAurYqoI5wckOsCd7BBEH+w3zj22Yu
	 BHKyeInzKoS7aSAfQr1nvv2wSyh25jc6FtKNwnnd3qPopN2SZmWZr08J1K9uqlBQPjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832516;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Mrp1dJ6e6JrUCQ0H1eTS7Q/C9Z04h2Mj7aab/tXMUoA=;
	b=pYe5+RL6Ft4/0A1tgztuJWlKruj0aCV222xrppwIBovR1kO7ME/lQfWsg+KB8WqMNaxf
	 9PxXJ4IedqDpLMz6wJX/LK2w7OFH8PVo6wMptTMRNEccdDnDtb8yboLobh8xEQfvr8M1n
	 kW7ddgo7pJ+1i80UXLsMaKy/YCG1U4h0wKNpLKNXOEtF/1MiVbVvbYpSR/oO0/jr5Tm18
	 FDW1xl+MpfXq7u9WqLgPJE5ZE2rUhbBRwjaOP9utHv5/UtlQYYrG3NL+8ds1NN1Aj2OfK
	 ajTGTlCJLQM0mn2sxfTZKXqo0EgBqR3K3MRlNNqtBGFcMZqrp6w2U2KNbXaeVi6dZIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="NlcZFSY/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3345606A31F;
	Sat, 24 Oct 2026 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NlcZFSY/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5811F01825;
	Sat, 24 Oct 2026 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832515;
	bh=Mrp1dJ6e6JrUCQ0H1eTS7Q/C9Z04h2Mj7aab/tXMUoA=;
	h=Date:To:From:Subject;
	b=NlcZFSY/VbOge5yPzybGhtd/8xd479had4nF1O2eIOio1BZhIChhkSa6xY6fJQEMq
	 etHaTeyRuMe24AVJ8j5orz8mQdeaHP9Iqxi6pv01QTnixXSEIRkRKlOxVKMaK/tuz3
	 iYcXNw60kQd+sl/Na5sIMEwuw3VL/MYPsnaZD3gc=
Date: Sat, 24 Oct 2026 02:01:55 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch removed from -mm tree
Message-Id: <20261024090155.7D5811F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/swap: fix swap_cache_get_folio() returning a folio that left the swap cache
Date: Thu, 15 Oct 2026 14:05:27 +0800

swap_cache_get_folio() reads the folio from the swap table and takes a
reference with folio_try_get(), without any lock.  If the folio is removed
from the swap cache and freed in between, and its memory gets reused,
folio_try_get() still succeeds and we return a page that has nothing to do
with the swap entry:

  CPU 0                                  CPU 1
  do_swap_page()
    swap_cache_get_folio()
      swp_tb = swap_table_get()
      folio = swp_tb_to_folio(swp_tb)
                                         madvise(MADV_DONTNEED)
                                           zap_nonpresent_ptes()
                                             swap_put_entries_direct()
                                               swap_put_entries_cluster()
                                                 __try_to_reclaim_swap()
                                                   swap_cache_del_folio()
                                                   folio_put()   <- freed
                                         page reused, e.g. as an anon
                                         folio of another task
      folio_try_get(folio)               <- succeeds
      return folio
    swap_update_readahead()              <- may clear PG_readahead on it
    folio_lock_or_retry()                <- locks it
    folio_matches_swap_entry() fails, unlock and put

filemap_get_entry() does the same lockless lookup for the page cache, and
after folio_try_get() it rechecks the xarray, because the folio may have
been freed and reused in between.  swap_cache_get_folio() lost that
recheck when the swap cache moved to the swap table.

So CPU 0 writes to a folio it doesn't own: it may clear PG_readahead and
takes the folio lock of someone else's page, before
folio_matches_swap_entry() finds out the folio is not ours.

When the race occurs, a swap fault can acquire a reference to a
physical page that has been freed and reused for an unrelated purpose,
potentially by another process.  The fault handler may then clear that
page's PG_readahead/PG_reclaim flag, wait on or acquire its folio lock,
and potentially attempt to remove it from an unrelated swap cache.

These operations can interfere with unrelated workloads and may cause
unexpected stalls and impaired reclaim.  The subsequent swap-entry
validation normally prevents the wrong folio from being mapped into the
faulting process.

It's documented that caller always double checks the folio so this part
is harmless from the aspect of data corruption or crash.

Recheck the slot after folio_try_get() and retry if it no longer holds
this folio.

[akpm@linux-foundation.org: add LLM-generated description of userspace impact]
Link: https://lore.kernel.org/20261015060528.302634-1-jiayuan.chen@linux.dev
Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: <stable@vger.kernel.org>
---

 mm/swap_state.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-fix-swap_cache_get_folio-returning-a-folio-that-left-the-swap-cache
+++ a/mm/swap_state.c
@@ -92,17 +92,27 @@ void show_swap_cache_info(void)
  */
 struct folio *swap_cache_get_folio(swp_entry_t entry)
 {
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	unsigned int ci_off = swp_cluster_offset(entry);
 	unsigned long swp_tb;
 	struct folio *folio;
 
 	for (;;) {
-		swp_tb = swap_table_get(__swap_entry_to_cluster(entry),
-					swp_cluster_offset(entry));
+		swp_tb = swap_table_get(ci, ci_off);
 		if (!swp_tb_is_folio(swp_tb))
 			return NULL;
 		folio = swp_tb_to_folio(swp_tb);
-		if (likely(folio_try_get(folio)))
+		if (!folio_try_get(folio))
+			continue;
+		/*
+		 * The folio may have been freed and its memory reused before
+		 * we got the reference. Make sure it is still in the slot.
+		 */
+		swp_tb = swap_table_get(ci, ci_off);
+		if (likely(swp_tb_is_folio(swp_tb) &&
+			   swp_tb_to_folio(swp_tb) == folio))
 			return folio;
+		folio_put(folio);
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are


