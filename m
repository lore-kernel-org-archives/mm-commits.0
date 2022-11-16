Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3855DC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 23:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiKPXCs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 18:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiKPXCr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 18:02:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EB54FF98
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 15:02:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09C862034
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 23:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20013C433C1;
        Wed, 16 Nov 2022 23:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668639765;
        bh=VWgFsgGeRmQKdrqz0rZScJHGznYkBUUbKv/kb5242Uw=;
        h=Date:To:From:Subject:From;
        b=oLtCdU0AHUBpiGbc1p6rt+fi5wV4VBTFgVDkZr0/w4kKRBoprmLav8aPDvDEfxLqH
         g0BdAON0CRxWjUKueU7LUTpbyIzTZHGXjiM2Qoj2BxfUFdXLYb5ryWkapBLn32CKIL
         hsKeRuHMJdxRPAtpNGQnzuMurLV0+OMIJ3thq7GU=
Date:   Wed, 16 Nov 2022 15:02:44 -0800
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-stop-using-0-as-null-pointer.patch added to mm-unstable branch
Message-Id: <20221116230245.20013C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: stop using 0 as NULL pointer
has been added to the -mm mm-unstable branch.  Its filename is
     migrate-stop-using-0-as-null-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-stop-using-0-as-null-pointer.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: mm/migrate.c: stop using 0 as NULL pointer
Date: Wed, 16 Nov 2022 09:23:45 +0800

mm/migrate.c:1198:24: warning: Using plain integer as NULL pointer

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3080
Link: https://lkml.kernel.org/r/20221116012345.84870-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c~migrate-stop-using-0-as-null-pointer
+++ a/mm/migrate.c
@@ -1186,7 +1186,7 @@ static int unmap_and_move(new_page_t get
 		return -ENOMEM;
 	dst = page_folio(newpage);
 
-	dst->private = 0;
+	dst->private = NULL;
 	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(&dst->page, reason);
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

migrate-stop-using-0-as-null-pointer.patch
lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

