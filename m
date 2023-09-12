Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF3BEE3F06
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbjILRhJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbjILRhI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:37:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E282510E9
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:37:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E8C433C8;
        Tue, 12 Sep 2023 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694540224;
        bh=tE9mztKgjz8eu2tPrU1EadLNtRnp+KtrONh+v3s8jqw=;
        h=Date:To:From:Subject:From;
        b=oP5Ol6r2+qOQvbIEVJZW1sdNyNkOCiYDjxKVzlgvSlf7VG/gGyYIKQ0hqXXyGK6m0
         mmkL3omdaeo8yTIh9lhs07iRo6dKRJscsJLLgp0i5d3LQro3dKK6QF2ZvRejoFjxNY
         PCVxTlvOatIEA+C58T7vhTDjhoxZVKz5448bqbSo=
Date:   Tue, 12 Sep 2023 10:37:03 -0700
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-add-missing-function-params-to-kernel-doc.patch added to mm-hotfixes-unstable branch
Message-Id: <20230912173704.6B1E8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: add missing function params to kernel-doc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scatterlist-add-missing-function-params-to-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-add-missing-function-params-to-kernel-doc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

scatterlist-add-missing-function-params-to-kernel-doc.patch

