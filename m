Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A18EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjFSXWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjFSXVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:21:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C8C10C7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:21:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9A460F38
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FCDC433C0;
        Mon, 19 Jun 2023 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216882;
        bh=+eluov/BBSRddKgf/MadMqQcIr6l3EZTuzUnGNB/694=;
        h=Date:To:From:Subject:From;
        b=mrRAa24aln8f2P9xcVIfAgaynsw8+9p6KD/lXohu+TTYfwOl7Q1vsCgJZ3Z3n01bX
         q4axADLFmfxhspfMM+x7ADrHWoshsJFDI2JShP9c0WSHNYDG2qeu/iDIy02rn5G5Zl
         9Me5gE/LUtLb54bLZXUrmyCGkZ8LL1eVtn1GIcOk=
Date:   Mon, 19 Jun 2023 16:21:22 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@infradead.org, david@redhat.com, luhongfei@vivo.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch removed from -mm tree
Message-Id: <20230619232122.84FCDC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: replace the ternary conditional operator with min()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lu Hongfei <luhongfei@vivo.com>
Subject: mm/vmalloc: replace the ternary conditional operator with min()
Date: Fri, 9 Jun 2023 17:30:57 +0800

It would be better to replace the traditional ternary conditional
operator with min() in zero_iter

Link: https://lkml.kernel.org/r/20230609093057.27777-1-luhongfei@vivo.com
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-replace-the-ternary-conditional-operator-with-min
+++ a/mm/vmalloc.c
@@ -3562,7 +3562,7 @@ static size_t zero_iter(struct iov_iter
 	while (remains > 0) {
 		size_t num, copied;
 
-		num = remains < PAGE_SIZE ? remains : PAGE_SIZE;
+		num = min_t(size_t, remains, PAGE_SIZE);
 		copied = copy_page_to_iter_nofault(ZERO_PAGE(0), 0, num, iter);
 		remains -= copied;
 
_

Patches currently in -mm which might be from luhongfei@vivo.com are


