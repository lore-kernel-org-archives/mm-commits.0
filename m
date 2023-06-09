Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE8BC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 18:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjFISfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjFISfA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 14:35:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE263A9E
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 11:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D58C65AC0
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 18:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5AC433EF;
        Fri,  9 Jun 2023 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686335695;
        bh=dnN3rV5kgHZsFrdNW1rOa5tCJQli1Lcv7QA/5rWycwM=;
        h=Date:To:From:Subject:From;
        b=0I39R6LthdTGE8+f3LcTJVBD+o4ln5megIwLUqPWcdXZ7tdRg2XEQ0WiVVpxiO4PZ
         /48BUGS5VgYczm3GugsRao6wuUjKRm6kVuzN8NU/h/3FHaXwie/MBw6a0XJco2CtPV
         FR5nbExcD9n3PBapYf9qReO/dognudua8mBz++/U=
Date:   Fri, 09 Jun 2023 11:34:54 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lstoakes@gmail.com,
        hch@infradead.org, luhongfei@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch added to mm-unstable branch
Message-Id: <20230609183455.6DD5AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: Replace the ternary conditional operator with min()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch

This patch will later appear in the mm-unstable branch at
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
From: Lu Hongfei <luhongfei@vivo.com>
Subject: mm/vmalloc: Replace the ternary conditional operator with min()
Date: Fri, 9 Jun 2023 17:30:57 +0800

It would be better to replace the traditional ternary conditional
operator with min() in zero_iter

Link: https://lkml.kernel.org/r/20230609093057.27777-1-luhongfei@vivo.com
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-replace-the-ternary-conditional-operator-with-min
+++ a/mm/vmalloc.c
@@ -3571,7 +3571,7 @@ static size_t zero_iter(struct iov_iter
 	while (remains > 0) {
 		size_t num, copied;
 
-		num = remains < PAGE_SIZE ? remains : PAGE_SIZE;
+		num = min_t(size_t, remains, PAGE_SIZE);
 		copied = copy_page_to_iter_nofault(ZERO_PAGE(0), 0, num, iter);
 		remains -= copied;
 
_

Patches currently in -mm which might be from luhongfei@vivo.com are

mm-vmalloc-replace-the-ternary-conditional-operator-with-min.patch

