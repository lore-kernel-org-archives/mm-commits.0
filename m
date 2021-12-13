Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 379D0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 20:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhLMUuy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 15:50:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbhLMUux (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 15:50:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3079460FAA
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 20:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E14C34600;
        Mon, 13 Dec 2021 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639428652;
        bh=cSKGSvWD10sz5U2CZP/mBpshMbVm/5ozeNADLcAiw44=;
        h=Date:From:To:Subject:From;
        b=OJEnI8ciToM9HW4PyqfvKRzNMjlBKEtLIZamUh0AQ3AWFE52jkMESs6cfBKXZZmtF
         htd6GOfG4YmeXUyY15yuoKt0DXrmqWAyoI10TgAZbHE4zLCyeEG/BB7hZmNIdY6SqQ
         KYp/oDN0Z8zb6w0T+GonSRaBt86HYWCkPLx6G/Kg=
Date:   Mon, 13 Dec 2021 12:50:51 -0800
From:   akpm@linux-foundation.org
To:     hanshenghong2019@email.szu.edu.cn, mm-commits@vger.kernel.org
Subject:  + tools-vm-page_owner_sortc-two-trivial-fixes.patch added
 to -mm tree
Message-ID: <20211213205051.eVbg4UB9r%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: two trivial fixes
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-two-trivial-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-two-trivial-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-two-trivial-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: two trivial fixes

1) There is an unused variable. It's better to delete it.
2) One case is missing in the usage().

Link: https://lkml.kernel.org/r/20211213164518.2461-1-hanshenghong2019@email.szu.edu.cn
Signed-off-by: Shenghong Han <hanshenghong2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-two-trivial-fixes
+++ a/tools/vm/page_owner_sort.c
@@ -41,8 +41,6 @@ static struct block_list *list;
 static int list_size;
 static int max_size;
 
-struct block_list *block_head;
-
 int read_block(char *buf, int buf_size, FILE *fin)
 {
 	char *curr = buf, *const buf_end = buf + buf_size;
@@ -249,7 +247,8 @@ static void usage(void)
 		"-p	Sort by pid.\n"
 		"-a	Sort by memory allocate time.\n"
 		"-r	Sort by memory release time.\n"
-		"-c	cull by comparing stacktrace instead of total block.\n"
+		"-c	Cull by comparing stacktrace instead of total block.\n"
+		"-f	Filter out the information of blocks whose memory has not been released.\n"
 	);
 }
 
_

Patches currently in -mm which might be from hanshenghong2019@email.szu.edu.cn are

tools-vm-page_owner_sortc-two-trivial-fixes.patch

