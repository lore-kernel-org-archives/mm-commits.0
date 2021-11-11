Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335B9C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1752861989
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKKCoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234005AbhKKCod (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938226187A;
        Thu, 11 Nov 2021 02:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598504;
        bh=hQky4RxJ7jKIOb2QiWrKlvMQ9pq6P0MIGgFpdv9W8Zw=;
        h=Date:From:To:Subject:From;
        b=YqELR9MHE2Yql3pOJI+NR22H9bdDPieWxzOBHRiHQR+cgZ4nPE8IMX/G6yicsffO1
         n306Suwf8++Ic7MqNS8mzeo+iB8nnOcHPgbf9SJmLuiD4cnIRG4LK8kXjTpHoiPJo7
         J1E11Oq2+s+EAuBGe/mzVBZNlCsadrKFZPD5DPNM=
Date:   Wed, 10 Nov 2021 18:41:44 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, vulab@iscas.ac.cn
Subject:  [merged]
 mm-swapfile-remove-needless-request_queue-null-pointer-check.patch removed
 from -mm tree
Message-ID: <20211111024144.Yhb2nalT3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: remove needless request_queue NULL pointer check
has been removed from the -mm tree.  Its filename was
     mm-swapfile-remove-needless-request_queue-null-pointer-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vulab@iscas.ac.cn are


