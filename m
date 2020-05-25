From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm_typesh-change-set_page_private-to-inline-function.patch added to -mm
 tree
Date: Mon, 25 May 2020 14:55:27 -0700
Message-ID: <20200525215527.ew0FyaaiY%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389067AbgEYVz2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 May 2020 17:55:28 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm_types.h: change set_page_private to inline function
has been added to the -mm tree.  Its filename is
     mm_typesh-change-set_page_private-to-inline-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm_typesh-change-set_page_private-to-inline-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm_typesh-change-set_page_private-to-inline-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: mm_types.h: change set_page_private to inline function

Change it to inline function to make callers use the proper argument.  And
no need for it to be macro per Andrew's comment [1].

[1] https://lore.kernel.org/lkml/20200518221235.1fa32c38e5766113f78e3f0d@linux-foundation.org/

Link: http://lkml.kernel.org/r/20200525203149.18802-1-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm_typesh-change-set_page_private-to-inline-function
+++ a/include/linux/mm_types.h
@@ -240,7 +240,11 @@ static inline atomic_t *compound_pincoun
 #define PAGE_FRAG_CACHE_MAX_ORDER	get_order(PAGE_FRAG_CACHE_MAX_SIZE)
 
 #define page_private(page)		((page)->private)
-#define set_page_private(page, v)	((page)->private = (v))
+
+static inline void set_page_private(struct page *page, unsigned long private)
+{
+	page->private = private;
+}
 
 struct page_frag_cache {
 	void * va;
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are

include-linux-pagemaph-introduce-attach-detach_page_private.patch
md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
btrfs-use-attach-detach_page_private.patch
fs-bufferc-use-attach-detach_page_private.patch
f2fs-use-attach-detach_page_private.patch
iomap-use-attach-detach_page_private.patch
ntfs-replace-attach_page_buffers-with-attach_page_private.patch
orangefs-use-attach-detach_page_private.patch
buffer_headh-remove-attach_page_buffers.patch
mm-migratec-call-detach_page_private-to-cleanup-code.patch
mm_typesh-change-set_page_private-to-inline-function.patch
