From: akpm@linux-foundation.org
Subject: +
 zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch added to -mm tree
Date: Wed, 07 Oct 2015 14:49:56 -0700
Message-ID: <56159384.k3glJSU5G8yrWDtD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbbJGVt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 17:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhuhui@xiaomi.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: fix obj_to_head use page_private(page) as value but not pointer
has been added to the -mm tree.  Its filename is
     zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch

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
Subject: zsmalloc: fix obj_to_head use page_private(page) as value but not pointer

In obj_malloc():

	if (!class->huge)
		/* record handle in the header of allocated chunk */
		link->handle = handle;
	else
		/* record handle in first_page->private */
		set_page_private(first_page, handle);

In the hugepage we save handle to private directly.

But in obj_to_head():

	if (class->huge) {
		VM_BUG_ON(!is_first_page(page));
		return *(unsigned long *)page_private(page);
	} else
		return *(unsigned long *)obj;

It is used as a pointer.

The reason why there is no problem until now is huge-class page is born
with ZS_FULL so it can't be migrated.  However, we need this patch for
future work: "VM-aware zsmalloced page migration" to reduce external
fragmentation.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer
+++ a/mm/zsmalloc.c
@@ -825,7 +825,7 @@ static unsigned long obj_to_head(struct
 {
 	if (class->huge) {
 		VM_BUG_ON(!is_first_page(page));
-		return *(unsigned long *)page_private(page);
+		return page_private(page);
 	} else
 		return *(unsigned long *)obj;
 }
_

Patches currently in -mm which might be from zhuhui@xiaomi.com are

zsmalloc-add-comments-for-inuse-to-zspage.patch
zsmalloc-fix-obj_to_head-use-page_privatepage-as-value-but-not-pointer.patch

