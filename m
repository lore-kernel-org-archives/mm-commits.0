Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4668AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317CF61357
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhKEUq3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233055AbhKEUq2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:46:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 413416135A;
        Fri,  5 Nov 2021 20:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145028;
        bh=J9KwG6Wm/mjzVYdnRDnygEce6+0CjcxTUg3/kbFl698=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BOUliP9UgAhw9xlvin+k+WhXlZEfFAGP5i3FhgSGH6Re4fJUaVtzOLxhYuAoj8crz
         thnPhfyxaiFWxKczYFh6qsQsTnkut1OAtth7eQKWdK7KIoBP3PcnL3QoduPv0nZLSc
         NBRj6Sv/GVmc9XDxw+qbeoMyau+Wfa5AWwohhzvs=
Date:   Fri, 05 Nov 2021 13:43:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linf@wangsu.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 175/262] mm/readahead.c: fix incorrect comments
 for get_init_ra_size
Message-ID: <20211105204347.ezf3f-ajG%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
