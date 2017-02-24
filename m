From: akpm@linux-foundation.org
Subject: [patch 085/124] mm/zsmalloc: fix comment in zsmalloc
Date: Fri, 24 Feb 2017 14:59:48 -0800
Message-ID: <58b0bae4.TLo81qXwODyjuF0O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdBXW7t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, guohanjun@huawei.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: mm/zsmalloc: fix comment in zsmalloc

The class index and fullness group are not encoded in (first)page->mapping
any more, after commit 3783689a1aa8 ("zsmalloc: introduce zspage
structure").  Instead, they are store in struct zspage.  Just delete this
unneeded comment.

Link: http://lkml.kernel.org/r/1486620822-36826-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-fix-comment-in-zsmalloc mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-fix-comment-in-zsmalloc
+++ a/mm/zsmalloc.c
@@ -267,10 +267,6 @@ struct zs_pool {
 #endif
 };
 
-/*
- * A zspage's class index and fullness group
- * are encoded in its (first)page->mapping
- */
 #define FULLNESS_BITS	2
 #define CLASS_BITS	8
 #define ISOLATED_BITS	3
_
