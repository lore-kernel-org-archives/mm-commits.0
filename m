Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F2FCE79A8
	for <mm-commits@archiver.kernel.org>; Tue, 19 Sep 2023 20:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjISUWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbjISUWP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Sep 2023 16:22:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3595FBA
        for <mm-commits@vger.kernel.org>; Tue, 19 Sep 2023 13:22:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83DFC433C7;
        Tue, 19 Sep 2023 20:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695154929;
        bh=YXlccuZgIm53Hpc4/AL0ZB58WdBexzWHulRDNVjJKBM=;
        h=Date:To:From:Subject:From;
        b=zNEtXnY7nQFud92QZuyooRp8bQMCc8gBGL2POTgosf72Eu8myQCFSGn8AcxMWabd4
         cD3hR6KUb2+c02Xe8caXMkzqx6WA4707ijDaERZbV/cX6A8LuKWAdUjTogyI/N10V/
         7t8on3p6xW5vibwgV8yVlloK+wbImw+oX1C6O0lE=
Date:   Tue, 19 Sep 2023 13:22:09 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scatterlist-add-missing-function-params-to-kernel-doc.patch removed from -mm tree
Message-Id: <20230919202209.B83DFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scatterlist: add missing function params to kernel-doc
has been removed from the -mm tree.  Its filename was
     scatterlist-add-missing-function-params-to-kernel-doc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: scatterlist: add missing function params to kernel-doc
Date: Mon, 11 Sep 2023 23:08:48 -0700

Describe missing function parameters to prevent kernel-doc warnings:

lib/scatterlist.c:288: warning: Function parameter or member 'first_chunk' not described in '__sg_alloc_table'
lib/scatterlist.c:800: warning: Function parameter or member 'flags' not described in 'sg_miter_start'

Link: https://lkml.kernel.org/r/20230912060848.4673-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/scatterlist.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/scatterlist.c~scatterlist-add-missing-function-params-to-kernel-doc
+++ a/lib/scatterlist.c
@@ -265,7 +265,8 @@ EXPORT_SYMBOL(sg_free_table);
  * @table:	The sg table header to use
  * @nents:	Number of entries in sg list
  * @max_ents:	The maximum number of entries the allocator returns per call
- * @nents_first_chunk: Number of entries int the (preallocated) first
+ * @first_chunk: first SGL if preallocated (may be %NULL)
+ * @nents_first_chunk: Number of entries in the (preallocated) first
  * 	scatterlist chunk, 0 means no such preallocated chunk provided by user
  * @gfp_mask:	GFP allocation mask
  * @alloc_fn:	Allocator to use
@@ -788,6 +789,7 @@ EXPORT_SYMBOL(__sg_page_iter_dma_next);
  * @miter: sg mapping iter to be started
  * @sgl: sg list to iterate over
  * @nents: number of sg entries
+ * @flags: sg iterator flags
  *
  * Description:
  *   Starts mapping iterator @miter.
_

Patches currently in -mm which might be from rdunlap@infradead.org are


