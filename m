Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B08C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009B8207DE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865529;
	bh=h+/nRuv/WvsUV/HxQeq1fyFlkA8g0yo8H58+MZ8b9WU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Jm0NtihD5FZmg7Y0l4PsiYaDF/xxxsoeN+cHqq7jW/lF5awtW44trAb4j6IHiehBE
	 Hko4Vbslb30oTeFeFyMTfiQdF+4mwjidaCHTjrA1DixltBMjJ6liVUEahtJR1dm1yL
	 QcRVWvsPC4Gw+pScei7+SP9PVmYbrU4/YpWnHq6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHSTcI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:32:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgHSTcI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:32:08 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89DD3207BB;
        Wed, 19 Aug 2020 19:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865527;
        bh=h+/nRuv/WvsUV/HxQeq1fyFlkA8g0yo8H58+MZ8b9WU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=i6InbGVYHZ2GvJyYOvs3u3JJCTPqD8e/8e/A2lqvfWJEm+2QFrC5nnw+PmzfMCSN4
         MHNU35UKNaNGM4ItLModxNIJHDEKrHy3fyou1h8yGR82zsIVZOGbi8ehoHhbASlPoZ
         L1NJNqPgzVwMSnGea7y3jMi8vHPrVwli0OM5sRbo=
Date:   Wed, 19 Aug 2020 12:32:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hch@lst.de, jlbec@evilplan.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  + fs-configfs-delete-repeated-words-in-comments.patch
 added to -mm tree
Message-ID: <20200819193207.MnrmqeL-Y%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: configfs: delete repeated words in comments
has been added to the -mm tree.  Its filename is
     fs-configfs-delete-repeated-words-in-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-configfs-delete-repeated-words-in-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-configfs-delete-repeated-words-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs: configfs: delete repeated words in comments

Drop duplicated words {the, that} in comments.

Link: https://lkml.kernel.org/r/20200811021826.25032-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c  |    2 +-
 fs/configfs/file.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/configfs/dir.c~fs-configfs-delete-repeated-words-in-comments
+++ a/fs/configfs/dir.c
@@ -1168,7 +1168,7 @@ EXPORT_SYMBOL(configfs_depend_item);
 
 /*
  * Release the dependent linkage.  This is much simpler than
- * configfs_depend_item() because we know that that the client driver is
+ * configfs_depend_item() because we know that the client driver is
  * pinned, thus the subsystem is pinned, and therefore configfs is pinned.
  */
 void configfs_undepend_item(struct config_item *target)
--- a/fs/configfs/file.c~fs-configfs-delete-repeated-words-in-comments
+++ a/fs/configfs/file.c
@@ -267,7 +267,7 @@ flush_write_buffer(struct file *file, st
  *	There is no easy way for us to know if userspace is only doing a partial
  *	write, so we don't support them. We expect the entire buffer to come
  *	on the first write.
- *	Hint: if you're writing a value, first read the file, modify only the
+ *	Hint: if you're writing a value, first read the file, modify only
  *	the value you're changing, then write entire buffer back.
  */
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

fs-ocfs2-delete-repeated-words-in-comments.patch
fs-configfs-delete-repeated-words-in-comments.patch

