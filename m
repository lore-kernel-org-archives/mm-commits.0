Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B96AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7051761260
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhKKCtk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhKKCti (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:49:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A74D6103C;
        Thu, 11 Nov 2021 02:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598810;
        bh=OfVzsNYnIN3YQIrFi0o5L9NOtUvfkIzAtXXD2qxwhes=;
        h=Date:From:To:Subject:From;
        b=uFdb+4noyEGSU/4/yBHpZqOQIPbyHVBGk/tz5lB4ypOR4nsY9E/McfKnW43Z3smVd
         /MJCtzXpEYBCOg61Dr+Cbi5xVJZG67Xz/orJY8NnEBRXrjS5GUOJd1MfGGs3IGkT/3
         yOCbiAMyx6xeZMPebMZqcj/RHAtXasvGEL7JVWqk=
Date:   Wed, 10 Nov 2021 18:46:50 -0800
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch removed
 from -mm tree
Message-ID: <20211111024650.0N89rMKsB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead.c: fix incorrect comments for get_init_ra_size
has been removed from the -mm tree.  Its filename was
     mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lin Feng <linf@wangsu.com>
Subject: mm/readahead.c: fix incorrect comments for get_init_ra_size

In fact, formated values returned by get_init_ra_size are not that
intuitive.  This patch make the comments reflect its truth.

Link: https://lkml.kernel.org/r/20211019104812.135602-1-linf@wangsu.com
Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/readahead.c~mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size
+++ a/mm/readahead.c
@@ -309,7 +309,7 @@ void force_page_cache_ra(struct readahea
  * Set the initial window size, round to next power of 2 and square
  * for small size, x 4 for medium, and x 2 for large
  * for 128k (32 page) max ra
- * 1-8 page = 32k initial, > 8 page = 128k initial
+ * 1-2 page = 16k, 3-4 page 32k, 5-8 page = 64k, > 8 page = 128k initial
  */
 static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
 {
_

Patches currently in -mm which might be from linf@wangsu.com are


