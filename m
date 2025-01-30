Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EFF139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280459; cv=none; b=Koy8S4ulcji9NdAxaBK45kgenpxRD2Of083evrcM5ElZF9uknX+DXvdRDFRMX3NcVqNOigN9mwHfxjk+wUQVB8exa0jH6e7b8Djx5JHDQ5+uldaNKUFyJCoNcXgddBso2RkDj9AA8NTxPAsuRhet96Xvm7Y35bNQ/OwZZ6DsxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280459; c=relaxed/simple;
	bh=epAdGRoXwrsRpOHphvUUrs/QDUn2clGrOHlOK58uw0A=;
	h=Date:To:From:Subject:Message-Id; b=nf4Ad1Ri0RrmZm1KSYaNaVef0iKUyv4WzTCAZC/OFeL3ZsKQ2Wb/nByig2MJGo3vQHa5kX+suO8s4DK4p2LZ8HJlYTVYUnH1P7WoAVBQ4tXEWCiSaB8lb82Nf6w98ZOD3XoaTuQHdHytbQA9fbbRVg06d5Atn6saKpA6LwTDIdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1axKgCTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1axKgCTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8384AC4CED2;
	Thu, 30 Jan 2025 23:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280459;
	bh=epAdGRoXwrsRpOHphvUUrs/QDUn2clGrOHlOK58uw0A=;
	h=Date:To:From:Subject:From;
	b=1axKgCTd2CU280Yqv5gEFhLPZhz+DD62xf13XGRbwgW9AqwzHoFKv1Wat4INDvvRp
	 JZUfWrV8LftmYexrTwiFw2mfu9QmRyz+hSBRwAHhkKPh21x1cwNrW9QcxVXwqERdhc
	 hTIgL5Jm8EAQzTJlIjZJ0H05/xx5tod0pskGOIJA=
Date: Thu, 30 Jan 2025 15:40:59 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch added to mm-unstable branch
Message-Id: <20250130234059.8384AC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: check PG_dropbehind instead of PG_reclaim in lru_gen_folio_seq()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch

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
Subject: mm/mglru: check PG_dropbehind instead of PG_reclaim in lru_gen_folio_seq()
Date: Thu, 30 Jan 2025 12:00:46 +0200

Kernel sets PG_dropcache instead of PG_reclaim everywhere.  Check
PG_dropcache in lru_gen_folio_seq().

No need to check for dirty and writeback as there's no conflict with
PG_readahead anymore.

Link: https://lkml.kernel.org/r/20250130100050.1868208-9-kirill.shutemov@linux.intel.com
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

 include/linux/mm_inline.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mm_inline.h~mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq
+++ a/include/linux/mm_inline.h
@@ -241,8 +241,7 @@ static inline unsigned long lru_gen_foli
 	else if (reclaiming)
 		gen = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
-		 (folio_test_reclaim(folio) &&
-		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
+		 folio_test_dropbehind(folio))
 		gen = MIN_NR_GENS;
 	else
 		gen = MAX_NR_GENS - folio_test_workingset(folio);
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

