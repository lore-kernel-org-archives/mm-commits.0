Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C920C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiCYWnF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbiCYWnD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4DB208C14
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E83861585
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FADC004DD;
        Fri, 25 Mar 2022 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248088;
        bh=x9ztkvxjl6ssldB2jInJr3/0IsvwsZ3iY1tD8E8UwMs=;
        h=Date:To:From:Subject:From;
        b=GVW9446h2IP6iVIfRq5gMHHN4dbU7S5QOd9SYwlSKKe3B9Lid/4yusIeau5ZJRwJq
         AhvBpmBQYClpYJubgMywZYAU46DXdQJ7bduya9F6YjtowijuhX5YbE/tCm+UL9PP70
         0oQAR9qNXnOEQX7oGZ0rf6DrLvoFb3Ap0NmTUAN0=
Date:   Fri, 25 Mar 2022 15:41:27 -0700
To:     mm-commits@vger.kernel.org, hanshenghong2019@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-vm-page_owner_sortc-two-trivial-fixes.patch removed from -mm tree
Message-Id: <20220325224128.01FADC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: two trivial fixes
has been removed from the -mm tree.  Its filename was
     tools-vm-page_owner_sortc-two-trivial-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


