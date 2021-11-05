Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2D3C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5525160E05
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhKEUkA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhKEUkA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0E660E08;
        Fri,  5 Nov 2021 20:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144640;
        bh=ocH+yVvAf4/EjIgaD54nWyy2pMZQ33fGsi9sbCMjpyE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xxCgZkbByb/JuEgUC5tr6XhrDYrM1o7zYSDwgKHGFdzeRdfE+EFaAjpvBaOTwWtzx
         a5caNLO1CwtourKpBSV6MSk5S2p3nqYEMFG3v/VDirSTlt7n/qFhHrRPMEnNU6w33G
         JNnZNtEdOrfY5FeYFStFLfYuo9R+Rf4ZwX1ORQbY=
Date:   Fri, 05 Nov 2021 13:37:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vulab@iscas.ac.cn
Subject:  [patch 051/262] mm/swapfile: remove needless
 request_queue NULL pointer check
Message-ID: <20211105203719.-ssTsYg32%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Subject: mm/swapfile: remove needless request_queue NULL pointer check

The request_queue pointer returned from bdev_get_queue() shall never be
NULL, so the null check is unnecessary, just remove it.

Link: https://lkml.kernel.org/r/20210917082111.33923-1-vulab@iscas.ac.cn
Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-remove-needless-request_queue-null-pointer-check
+++ a/mm/swapfile.c
@@ -3118,7 +3118,7 @@ static bool swap_discardable(struct swap
 {
 	struct request_queue *q = bdev_get_queue(si->bdev);
 
-	if (!q || !blk_queue_discard(q))
+	if (!blk_queue_discard(q))
 		return false;
 
 	return true;
_
