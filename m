Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45079C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiEMT12 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383955AbiEMT0C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:26:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860AC3AA4B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E6461653
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5DEC34113;
        Fri, 13 May 2022 19:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469823;
        bh=DiioLIrQh68opMp+6UhrzqAtii1brhPnddqNgucSVUk=;
        h=Date:To:From:Subject:From;
        b=W/hERkL16+glKgEWRGE2xGCJFWaBlJTGw5QKwWlGIgADzPZwi/3NidT/MoAJ5Ii9g
         ZKt1Vq3Uh9X6dkK3ojR37fK7a2W/sPSPYtdMgzyPgp8XEL2ngvyYlThai2aSlkYkaZ
         hK7ORGaHQc24frsvKKWpf1R/oK4C68K9O/8JkimE=
Date:   Fri, 13 May 2022 12:23:42 -0700
To:     mm-commits@vger.kernel.org, kvalo@codeaurora.org, hch@lst.de,
        axboe@kernel.dk, colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] relay-remove-redundant-assignment-to-pointer-buf.patch removed from -mm tree
Message-Id: <20220513192343.7A5DEC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: relay: remove redundant assignment to pointer buf
has been removed from the -mm tree.  Its filename was
     relay-remove-redundant-assignment-to-pointer-buf.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: relay: remove redundant assignment to pointer buf

Pointer buf is being assigned a value that is not being read, buf is being
re-assigned in the next starement.  The assignment is redundant and can be
removed.

Cleans up clang scan build warning:
kernel/relay.c:443:8: warning: Although the value stored to 'buf' is
used in the enclosing expression, the value is never actually read
from 'buf' [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220508212152.58753-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/relay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/relay.c~relay-remove-redundant-assignment-to-pointer-buf
+++ a/kernel/relay.c
@@ -440,7 +440,7 @@ int relay_prepare_cpu(unsigned int cpu)
 
 	mutex_lock(&relay_channels_mutex);
 	list_for_each_entry(chan, &relay_channels, list) {
-		if ((buf = *per_cpu_ptr(chan->buf, cpu)))
+		if (*per_cpu_ptr(chan->buf, cpu))
 			continue;
 		buf = relay_open_buf(chan, cpu);
 		if (!buf) {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


