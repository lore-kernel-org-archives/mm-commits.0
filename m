Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5851139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280458; cv=none; b=dFC7QAo88NpE708lE4/DPf4TMphl/vyJdWyJ4VOoJEGNKx6PxDXInk+xW/5joBAqLCdBj7Snk4xY7H3v8Dx5uMUcAuq0SPioquIdTYOxKdap4fl5FoZ/PPetkjKZ1bJM8XLcAmFD9kvvdE3/8AQJT0tIta02IsnGUDo06DCitT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280458; c=relaxed/simple;
	bh=mbb5laJ1CAuVk+R+fsYc8xNgCDxhpFbXNOTg34U20K8=;
	h=Date:To:From:Subject:Message-Id; b=I32E6JyecKokNP/DO+2VWqOxBFTC0q7AhVBXe729Y9gV2l3f4VhoOyO/4kD7jaOPAiYu91sWqpKwhT3arTs/Z/qgMXb3AA6Bgal9l8n8Zx7e1q2/Gz8YAAGhWNKy6LLqOqc6NAN1OPch2CmjByyo53P776/y1jvL01VsdrbH/2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wpaNU1ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wpaNU1ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E018C4CED3;
	Thu, 30 Jan 2025 23:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280457;
	bh=mbb5laJ1CAuVk+R+fsYc8xNgCDxhpFbXNOTg34U20K8=;
	h=Date:To:From:Subject:From;
	b=wpaNU1ezzMjBlI8qVAeUsvPLCM9OXr1Urm5WKp1DjfOKkyAPz3N097lLGfLZkmgZG
	 aWC6elIARWr2AgOvq9vuIC8w1JeugrOkGc1jFPdIFRRM6zQ54sLuOsTF0RFgCaU0xf
	 HnG551dxt0YpK5XBFmGVvI4JmVrqQb0CGTFCdG+o=
Date: Thu, 30 Jan 2025 15:40:56 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20250130234057.4E018C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: use PG_dropbehind instead of PG_reclaim in shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/vmscan: use PG_dropbehind instead of PG_reclaim in shrink_folio_list()
Date: Thu, 30 Jan 2025 12:00:45 +0200

The recently introduced PG_dropbehind allows for freeing folios
immediately after writeback.  Unlike PG_reclaim, it does not need vmscan
to be involved to get the folio freed.

Instead of using folio_set_reclaim(), use folio_set_dropbehind() in
shrink_folio_list().

It is safe to leave PG_dropbehind on the folio if, for some reason (bug?),
the folio is not in a writeback state after ->writepage().  In these
cases, the kernel had to clear PG_reclaim as it shared a page flag bit
with PG_readahead.

Also use PG_dropbehind instead PG_reclaim to detect I/O congestion.

Link: https://lkml.kernel.org/r/20250130100050.1868208-8-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: gehao <gehao@kylinos.cn>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mattew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1140,7 +1140,7 @@ retry:
 		 * for immediate reclaim are making it to the end of
 		 * the LRU a second time.
 		 */
-		if (writeback && folio_test_reclaim(folio))
+		if (writeback && folio_test_dropbehind(folio))
 			stat->nr_congested += nr_pages;
 
 		/*
@@ -1149,7 +1149,7 @@ retry:
 		 *
 		 * 1) If reclaim is encountering an excessive number
 		 *    of folios under writeback and this folio has both
-		 *    the writeback and reclaim flags set, then it
+		 *    the writeback and dropbehind flags set, then it
 		 *    indicates that folios are being queued for I/O but
 		 *    are being recycled through the LRU before the I/O
 		 *    can complete. Waiting on the folio itself risks an
@@ -1173,7 +1173,7 @@ retry:
 		 *    would probably show more reasons.
 		 *
 		 * 3) Legacy memcg encounters a folio that already has the
-		 *    reclaim flag set. memcg does not have any dirty folio
+		 *    dropbehind flag set. memcg does not have any dirty folio
 		 *    throttling so we could easily OOM just because too many
 		 *    folios are in writeback and there is nothing else to
 		 *    reclaim. Wait for the writeback to complete.
@@ -1190,30 +1190,16 @@ retry:
 		if (folio_test_writeback(folio)) {
 			/* Case 1 above */
 			if (current_is_kswapd() &&
-			    folio_test_reclaim(folio) &&
+			    folio_test_dropbehind(folio) &&
 			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
 				stat->nr_immediate += nr_pages;
 				goto activate_locked;
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
-			    !folio_test_reclaim(folio) ||
+			    !folio_test_dropbehind(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask)) {
-				/*
-				 * This is slightly racy -
-				 * folio_end_writeback() might have
-				 * just cleared the reclaim flag, then
-				 * setting the reclaim flag here ends up
-				 * interpreted as the readahead flag - but
-				 * that does not matter enough to care.
-				 * What we do want is for this folio to
-				 * have the reclaim flag set next time
-				 * memcg reclaim reaches the tests above,
-				 * so it will then wait for writeback to
-				 * avoid OOM; and it's also appropriate
-				 * in global reclaim.
-				 */
-				folio_set_reclaim(folio);
+				folio_set_dropbehind(folio);
 				stat->nr_writeback += nr_pages;
 				goto activate_locked;
 
@@ -1368,7 +1354,7 @@ retry:
 			 */
 			if (folio_is_file_lru(folio) &&
 			    (!current_is_kswapd() ||
-			     !folio_test_reclaim(folio) ||
+			     !folio_test_dropbehind(folio) ||
 			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
 				/*
 				 * Immediately reclaim when written back.
@@ -1378,7 +1364,7 @@ retry:
 				 */
 				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
 						nr_pages);
-				folio_set_reclaim(folio);
+				folio_set_dropbehind(folio);
 
 				goto activate_locked;
 			}
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch
drm-i915-gem-convert-__shmem_writeback-to-folios.patch
drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-zswap-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch
mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch
mm-remove-pg_reclaim.patch
mm-vmscan-do-not-demote-pg_dropbehind-folios.patch
mm-rename-pg_dropbehind-to-pg_reclaim.patch

