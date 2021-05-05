Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F015DC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D299F61422
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhEEBlA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhEEBlA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D9C61029;
        Wed,  5 May 2021 01:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178804;
        bh=CUrs0Trl7U1xf4ZyeHRoLM2LurT+KMulxyYIr1LYdDY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cWi0ivq5oxy5Dx9c3OhJLkp2UADhwNW4oD81aTlLlYb99DnPZlp4dQuPQBLpP620z
         t0XKE48OENSZhl62ZBBjoEUmNaAzHUOOYjfuyWBTxlhzVJ9DKOQR6j1fE4zQBlCk6K
         Rhr4NQ2dBf+CncQn1uoLvx0ZQ3GXoySN5gpfEOVQ=
Date:   Tue, 04 May 2021 18:40:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chaitanya.kulkarni@wdc.com, clm@fb.com,
        dsterba@suse.com, ira.weiny@intel.com, josef@toxicpanda.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 135/143] iov_iter: lift memzero_page() to
 highmem.h
Message-ID: <20210505014003.m_wTgKpwc%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: iov_iter: lift memzero_page() to highmem.h

Patch series "btrfs: Convert kmap/memset/kunmap to memzero_user()".

Lifting memzero_user(), convert it to kmap_local_page() and then use it in
btrfs.


This patch (of 3):

memzero_page() can replace the kmap/memset/kunmap pattern in other places
in the code.  While zero_user() has the same interface it is not the same
call and its use should be limited and some of those calls may be better
converted from zero_user() to memzero_page().[1] But that is not addressed
in this series.

Lift memzero_page() to highmem.

[1] https://lore.kernel.org/lkml/CAHk-=wijdojzo56FzYqE5TOYw2Vws7ik3LEMGj9SPQaJJ+Z73Q@mail.gmail.com/

Link: https://lkml.kernel.org/r/20210309212137.2610186-1-ira.weiny@intel.com
Link: https://lkml.kernel.org/r/20210309212137.2610186-2-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    7 +++++++
 lib/iov_iter.c          |    8 +-------
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/highmem.h~iov_iter-lift-memzero_page-to-highmemh
+++ a/include/linux/highmem.h
@@ -332,4 +332,11 @@ static inline void memcpy_to_page(struct
 	kunmap_local(to);
 }
 
+static inline void memzero_page(struct page *page, size_t offset, size_t len)
+{
+	char *addr = kmap_atomic(page);
+	memset(addr + offset, 0, len);
+	kunmap_atomic(addr);
+}
+
 #endif /* _LINUX_HIGHMEM_H */
--- a/lib/iov_iter.c~iov_iter-lift-memzero_page-to-highmemh
+++ a/lib/iov_iter.c
@@ -5,6 +5,7 @@
 #include <linux/fault-inject-usercopy.h>
 #include <linux/uio.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/splice.h>
@@ -507,13 +508,6 @@ void iov_iter_init(struct iov_iter *i, u
 }
 EXPORT_SYMBOL(iov_iter_init);
 
-static void memzero_page(struct page *page, size_t offset, size_t len)
-{
-	char *addr = kmap_atomic(page);
-	memset(addr + offset, 0, len);
-	kunmap_atomic(addr);
-}
-
 static inline bool allocated(struct pipe_buffer *buf)
 {
 	return buf->ops == &default_pipe_buf_ops;
_
