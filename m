Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E3139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280455; cv=none; b=F9ARqhd84vumrSmKKM5mRiBBq76fhc/zYvJvmMSWVqqda+XbxsK3SSZ7T7K5mYRmeulXjIGaXGpPgXv7YXde29aVCLeApfopASCImpgZYV94o8MBoZS+Mp11EKPsKq6Z7c/msRzKWVFCpT6LpFkD47nTljqZNAXKMhpXEPtH4bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280455; c=relaxed/simple;
	bh=QEkz6pv3foTFs//XhslfCF8ajVcsXFB7EwDEr36ncZw=;
	h=Date:To:From:Subject:Message-Id; b=krwtdwDNy449dhWaAohA20xRhZsV/n3LQLcgp5sNZQhDyIFv7tza62UYLIlTw7G1Ia/waoXoh0L4gu9U5LFtGQunRFDpMyaNfzT+eFERIlpWZWrl5U5FzbsCGPS10HPHNh/4IKcz60q79vVqZKRf6B5yaQ1ltsXYvtLFUwoi0sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F5N7p8kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F5N7p8kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044A0C4CED2;
	Thu, 30 Jan 2025 23:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280455;
	bh=QEkz6pv3foTFs//XhslfCF8ajVcsXFB7EwDEr36ncZw=;
	h=Date:To:From:Subject:From;
	b=F5N7p8krDO3J3QVFm9VYKmWIjGDdRKVyI/jYVN4Yr9dRubUJySq7WwQ9WmXkhPaSB
	 CepmKBZngvElYHiRtpeRI0bRJj0JLWLnoRiLAs+O9ku3KMtrbbDVbwpktCCdM67iq+
	 uvprAcA7RQaI93QsyUFP8Nahf7zueliy2BeGRPzE=
Date: Thu, 30 Jan 2025 15:40:54 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch added to mm-unstable branch
Message-Id: <20250130234055.044A0C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: use PG_dropbehind instead of PG_reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch

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
Subject: mm/vmscan: use PG_dropbehind instead of PG_reclaim
Date: Thu, 30 Jan 2025 12:00:44 +0200

The recently introduced PG_dropbehind allows for freeing folios
immediately after writeback.  Unlike PG_reclaim, it does not need vmscan
to be involved to get the folio freed.

Instead of using folio_set_reclaim(), use folio_set_dropbehind() in
pageout().

It is safe to leave PG_dropbehind on the folio if, for some reason (bug?),
the folio is not in a writeback state after ->writepage().  In these
cases, the kernel had to clear PG_reclaim as it shared a page flag bit
with PG_readahead.

Link: https://lkml.kernel.org/r/20250130100050.1868208-7-kirill.shutemov@linux.intel.com
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

 mm/vmscan.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim
+++ a/mm/vmscan.c
@@ -692,19 +692,16 @@ static pageout_t pageout(struct folio *f
 		if (shmem_mapping(mapping) && folio_test_large(folio))
 			wbc.list = folio_list;
 
-		folio_set_reclaim(folio);
+		folio_set_dropbehind(folio);
+
 		res = mapping->a_ops->writepage(&folio->page, &wbc);
 		if (res < 0)
 			handle_write_error(mapping, folio, res);
 		if (res == AOP_WRITEPAGE_ACTIVATE) {
-			folio_clear_reclaim(folio);
+			folio_clear_dropbehind(folio);
 			return PAGE_ACTIVATE;
 		}
 
-		if (!folio_test_writeback(folio)) {
-			/* synchronous write or broken a_ops? */
-			folio_clear_reclaim(folio);
-		}
 		trace_mm_vmscan_write_folio(folio);
 		node_stat_add_folio(folio, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
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

