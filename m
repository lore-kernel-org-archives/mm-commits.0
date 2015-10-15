From: akpm@linux-foundation.org
Subject: + zsmalloc-remove-unless-line-in-obj_free.patch added to -mm tree
Date: Thu, 15 Oct 2015 12:59:47 -0700
Message-ID: <562005b3.eqaIq18gjC00Kscd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbJOT7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 15:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: remove useless line in obj_free()
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-unless-line-in-obj_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-unless-line-in-obj_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-unless-line-in-obj_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Zhu <zhuhui@xiaomi.com>
Subject: mm/zsmalloc.c: remove useless line in obj_free()

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-unless-line-in-obj_free mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-unless-line-in-obj_free
+++ a/mm/zsmalloc.c
@@ -1429,8 +1429,6 @@ static void obj_free(struct zs_pool *poo
 	struct page *first_page, *f_page;
 	unsigned long f_objidx, f_offset;
 	void *vaddr;
-	int class_idx;
-	enum fullness_group fullness;
 
 	BUG_ON(!obj);
 
@@ -1438,7 +1436,6 @@ static void obj_free(struct zs_pool *poo
 	obj_to_location(obj, &f_page, &f_objidx);
 	first_page = get_first_page(f_page);
 
-	get_zspage_mapping(first_page, &class_idx, &fullness);
 	f_offset = obj_idx_to_offset(f_page, f_objidx, class->size);
 
 	vaddr = kmap_atomic(f_page);
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are

zsmalloc-add-comments-for-inuse-to-zspage.patch
zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch
zsmalloc-remove-unless-line-in-obj_free.patch

