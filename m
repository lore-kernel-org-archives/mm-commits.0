Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD213C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244504AbiCYBKa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244500AbiCYBK0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:10:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C58B443FE
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2951EB8270B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ACFC340ED;
        Fri, 25 Mar 2022 01:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170530;
        bh=VLhfRR9r/5SSkltTPbMxeOKGTFsZOOoGY/nRfOITTy4=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=jE+T3OXif7iz+nH//ki4w4Il/k5WsId8YNZjFzZlI0V8R26bvhgoCKhDzueQ+6d7e
         ZJ/4gg7NLp+qeKV3BhFw+JLDpHXGgdbBFX7bxjFwq6z4OK1/bsbjBKG+GHOChgpzwM
         v50J2QuUZQD8Sta06FCpLAXjn9ybIkx41I7YewJg=
Date:   Thu, 24 Mar 2022 18:08:50 -0700
To:     hanshenghong2019@email.szu.edu.cn, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 005/114] tools/vm/page_owner_sort.c: two trivial fixes
Message-Id: <20220325010850.D3ACFC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
