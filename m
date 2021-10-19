Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC2DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5988610A3
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 21:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhJSVic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhJSVic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 17:38:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAD7A60FDA;
        Tue, 19 Oct 2021 21:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634679378;
        bh=vr1Cx0UHjyGT+oJLGFmancW20tKDp8FYZ5jp22e2uLA=;
        h=Date:From:To:Subject:From;
        b=Dj3e4RcGd1slkccwtnSGqgZvws5eMoI3cbqusYN+g1DhlHig68G0IQAtvZE29YCq5
         pta0M7cRJKZxrV4kJSefPHgcFWMkv+cxtByADBWEiPzzlDY+HnfuleGMUGQPXCtmPt
         KErGn75dEF67RLjlurhuzeM8BiXjqtwCNW/TjUj0=
Date:   Tue, 19 Oct 2021 14:36:18 -0700
From:   akpm@linux-foundation.org
To:     linf@wangsu.com, mm-commits@vger.kernel.org
Subject:  +
 mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch added to
 -mm tree
Message-ID: <20211019213618.DTPx9UTok%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/readahead.c: fix incorrect comments for get_init_ra_size
has been added to the -mm tree.  Its filename is
     mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-readaheadc-fix-incorrect-comments-for-get_init_ra_size.patch

