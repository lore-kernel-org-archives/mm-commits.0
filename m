Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E5A139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280445; cv=none; b=P3dTWnhupypNXMQVkfNNV4liA06CHI08cj4vNiZXBFysOHl+k5Tum2UYIHd7hbzyh9l11x924TLwDUKDbxljdUgLs7a0tah5bJZc9MjEAYdzeVhxxkmSUFxUBZpS7ggEQSrcXI8rnPNIxjwsLpQOOAgkwFc9YqCvRx8x9WhGcXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280445; c=relaxed/simple;
	bh=cqterSyupTGzHaIMa22iBW8ckKFK4E0p42YB/HP/u3k=;
	h=Date:To:From:Subject:Message-Id; b=a7HIytmBQitQM/CUSQ/JWw/u2MHI33rZCJC+fbZ0deFlFKMRWWZDCSBQYxeRfYtIlBFmPnnSbS1tuXa84ZEGP4ZSaWYcEb+jNP+nd+v5mUcKYHt4ZtkYAd/HmdgELRuNhLxcyhclLXrTOBxmn2imCF4x2/H0kksKy8SXnxqjE14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCu2sgzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCu2sgzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A207C4CED2;
	Thu, 30 Jan 2025 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280445;
	bh=cqterSyupTGzHaIMa22iBW8ckKFK4E0p42YB/HP/u3k=;
	h=Date:To:From:Subject:From;
	b=cCu2sgzSnJLN9vHx2w9/HHKm9QwbBob+/1QV8eq4e3zN4OqxiXA+CuAR/Zj/ikWV+
	 IgGAbvBd8svqL9xi//5sxEHmiDA113ehJjT05RdtihF8XEA2O5JbkfMFsBLNJLr4sr
	 B+FUfrLJPuPijeShhBR50ryWLZZPvwqsO0/jmNqM=
Date: Thu, 30 Jan 2025 15:40:44 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-i915-gem-convert-__shmem_writeback-to-folios.patch added to mm-unstable branch
Message-Id: <20250130234045.5A207C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/i915/gem: convert __shmem_writeback() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     drm-i915-gem-convert-__shmem_writeback-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-gem-convert-__shmem_writeback-to-folios.patch

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
Subject: drm/i915/gem: convert __shmem_writeback() to folios
Date: Thu, 30 Jan 2025 12:00:40 +0200

Use folios instead of pages.

This is preparation for removing PG_reclaim.

Link: https://lkml.kernel.org/r/20250130100050.1868208-3-kirill.shutemov@linux.intel.com
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

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~drm-i915-gem-convert-__shmem_writeback-to-folios
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -320,25 +320,25 @@ void __shmem_writeback(size_t size, stru
 
 	/* Begin writeback on each dirty page */
 	for (i = 0; i < size >> PAGE_SHIFT; i++) {
-		struct page *page;
+		struct folio *folio;
 
-		page = find_lock_page(mapping, i);
-		if (!page)
+		folio = filemap_lock_folio(mapping, i);
+		if (!folio)
 			continue;
 
-		if (!page_mapped(page) && clear_page_dirty_for_io(page)) {
+		if (!folio_mapped(folio) && folio_clear_dirty_for_io(folio)) {
 			int ret;
 
-			SetPageReclaim(page);
-			ret = mapping->a_ops->writepage(page, &wbc);
+			folio_set_reclaim(folio);
+			ret = mapping->a_ops->writepage(&folio->page, &wbc);
 			if (!PageWriteback(page))
-				ClearPageReclaim(page);
+				folio_clear_reclaim(folio);
 			if (!ret)
 				goto put;
 		}
-		unlock_page(page);
+		folio_unlock(folio);
 put:
-		put_page(page);
+		folio_put(folio);
 	}
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

