From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch removed from
 -mm tree
Date: Tue, 15 Mar 2016 14:37:26 -0700
Message-ID: <56e88096.xHgCcyKsx0LOiXtR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbcCOVh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, js1304@gmail.com, keescook@chromium.org, labbott@fedoraproject.org, minipli@googlemail.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-drop-lock-at-the-end-of-free_debug_processing-fix
has been removed from the -mm tree.  Its filename was
     slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch

This patch was dropped because it was folded into slub-drop-lock-at-the-end-of-free_debug_processing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-drop-lock-at-the-end-of-free_debug_processing-fix

fix build

mm/slub.c: In function 'free_debug_processing':
mm/slub.c:1211:46: warning: return makes integer from pointer without a cast [enabled by default]
  unsigned long addr, unsigned long *flags) { return NULL; }
                                              ^
mm/slub.c: In function '__slab_free':
mm/slub.c:2589:6: error: too few arguments to function 'free_debug_processing'
      !free_debug_processing(s, page, head, tail, cnt, addr))
      ^
mm/slub.c:1208:19: note: declared here
 static inline int free_debug_processing(

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>
Cc: Mathias Krause <minipli@googlemail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing-fix mm/slub.c
--- a/mm/slub.c~slub-drop-lock-at-the-end-of-free_debug_processing-fix
+++ a/mm/slub.c
@@ -1208,7 +1208,7 @@ static inline int alloc_debug_processing
 static inline int free_debug_processing(
 	struct kmem_cache *s, struct page *page,
 	void *head, void *tail, int bulk_cnt,
-	unsigned long addr, unsigned long *flags) { return NULL; }
+	unsigned long addr) { return 0; }
 
 static inline int slab_pad_check(struct kmem_cache *s, struct page *page)
 			{ return 1; }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
slub-drop-lock-at-the-end-of-free_debug_processing.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch

