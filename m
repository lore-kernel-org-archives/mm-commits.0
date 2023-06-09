Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B864C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjFIX3p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjFIX2h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741603AAA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEE365CF9
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681AFC433D2;
        Fri,  9 Jun 2023 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353291;
        bh=71PPN0miPvyjUgd9Hu3PX/mVZMvG8GsvXAeBjMNAAqw=;
        h=Date:To:From:Subject:From;
        b=Lx1W+ftJ7RQONTJu7Y766j5Wsbr52GIKCfIGe9B8f4h/DF6UgSQWk/VYPr4czGJgQ
         zCH/YlnCn8CvAvdJhwEHf3vzNy5SzOpnOJKsOfmAt5ThdGqeU1dK6QjV1qZhZujh4S
         WtxlQjrafah5teYgP9F/sEnMe/UD7CcXqyoMku/U=
Date:   Fri, 09 Jun 2023 16:28:10 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, Liam.Howlett@oracle.com,
        dcb314@hotmail.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-convert-bug_on-to-mt_bug_on.patch removed from -mm tree
Message-Id: <20230609232811.681AFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: convert BUG_ON() to MT_BUG_ON()
has been removed from the -mm tree.  Its filename was
     maple_tree-convert-bug_on-to-mt_bug_on.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: convert BUG_ON() to MT_BUG_ON()
Date: Thu, 18 May 2023 10:55:16 -0400

Use MT_BUG_ON() to get more information when running with MAPLE_TREE_DEBUG
enabled.

Link: https://lkml.kernel.org/r/20230518145544.1722059-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-convert-bug_on-to-mt_bug_on
+++ a/lib/maple_tree.c
@@ -194,7 +194,7 @@ static void mas_set_height(struct ma_sta
 	unsigned int new_flags = mas->tree->ma_flags;
 
 	new_flags &= ~MT_FLAGS_HEIGHT_MASK;
-	BUG_ON(mas->depth > MAPLE_HEIGHT_MAX);
+	MT_BUG_ON(mas->tree, mas->depth > MAPLE_HEIGHT_MAX);
 	new_flags |= mas->depth << MT_FLAGS_HEIGHT_OFFSET;
 	mas->tree->ma_flags = new_flags;
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


