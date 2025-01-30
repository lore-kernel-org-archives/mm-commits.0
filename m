Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E37A139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280448; cv=none; b=FTJ3EMDLgrPcG4Rl5e4B4yJ8bQM+kidtZ+i2mdNgTSOG1ckukphH2YhxI+DvelgG60iqr4Dse0qvsMue9U/FOKxe94NKauu+luaPj8iiPjLBGkKMs3B17/YwjFFx0dcloRiDFvwIISRUJCzdxCUKHKZUDsSLbN/NV18qvL3ydBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280448; c=relaxed/simple;
	bh=Quusp0mgBhKwwk5sBfdQgN6WWrslXsQyME8qGE70HwI=;
	h=Date:To:From:Subject:Message-Id; b=FaoYjmL3UO4LFP8Om3H7Rn6ZE/8pO7t2+PgTuafdVvNWZjYVXSGLjljLN6QEzJBMtusAZ3BTOIztSejIyjoLwS7lOuBHVFUpMkW+AvCEymQHzAT8+qo219ktfvRRPGUFW20JmU7QMRmLXOR8RiCpCGPkliGGZYeXOYvMnJPV+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yw6ds5On; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yw6ds5On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982E3C4CED2;
	Thu, 30 Jan 2025 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280447;
	bh=Quusp0mgBhKwwk5sBfdQgN6WWrslXsQyME8qGE70HwI=;
	h=Date:To:From:Subject:From;
	b=Yw6ds5OnZHXHxBUayZOkPrXe7CXwVc23F7HUJpTSWQYJzfZ3Vxqt5qyNZ1e3K3Cut
	 PiXR51LHUL1vnZSA9A9d+FetChHYGvLfLxBMnxUzZPwufcYmjGkV0YgmAAySc1CmBz
	 t3rlGKBqiUF6UXUszRkG+dh+pN46WdvI0b12Khms=
Date: Thu, 30 Jan 2025 15:40:47 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch added to mm-unstable branch
Message-Id: <20250130234047.982E3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drm/i915/gem: use PG_dropbehind instead of PG_reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch

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
Subject: drm/i915/gem: use PG_dropbehind instead of PG_reclaim
Date: Thu, 30 Jan 2025 12:00:41 +0200

The recently introduced PG_dropbehind allows for freeing folios
immediately after writeback.  Unlike PG_reclaim, it does not need vmscan
to be involved to get the folio freed.

Instead of using folio_set_reclaim(), use folio_set_dropbehind() in
__shmem_writeback()

It is safe to leave PG_dropbehind on the folio if, for some reason (bug?),
the folio is not in a writeback state after ->writepage().  In these
cases, the kernel had to clear PG_reclaim as it shared a page flag bit
with PG_readahead.

Link: https://lkml.kernel.org/r/20250130100050.1868208-4-kirill.shutemov@linux.intel.com
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

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -329,10 +329,8 @@ void __shmem_writeback(size_t size, stru
 		if (!folio_mapped(folio) && folio_clear_dirty_for_io(folio)) {
 			int ret;
 
-			folio_set_reclaim(folio);
+			folio_set_dropbehind(folio);
 			ret = mapping->a_ops->writepage(&folio->page, &wbc);
-			if (!PageWriteback(page))
-				folio_clear_reclaim(folio);
 			if (!ret)
 				goto put;
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

