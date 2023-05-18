Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2DEC77B7D
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjERVbZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbjERVa6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:30:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457D31BE3
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B172061AE4
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B7BC433D2;
        Thu, 18 May 2023 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445347;
        bh=rGyKSny8TgkGz1cF2//HRn1Xvy7h9reat1vIuqViePk=;
        h=Date:To:From:Subject:From;
        b=P299lwD6c+YqZEtjIBk4YMlSZJi3AVIQjTvx2Fq9MRUUAZjtsb+VBpK01/xp4+lUz
         zbM4ji1RKJrfkXFBH6KhyspM0Lbc6jKIjhFN/WHyioDvVheDMAkZEwn3hc3H+nrwcS
         WqBRmCjGnnpGdazSP0y7KZlt9GVYv4QBfSGIWXDA=
Date:   Thu, 18 May 2023 14:29:06 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, Liam.Howlett@oracle.com,
        dcb314@hotmail.com, Liam.Howlett@Oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-convert-bug_on-to-mt_bug_on.patch added to mm-unstable branch
Message-Id: <20230518212907.14B7BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: convert BUG_ON() to MT_BUG_ON()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-convert-bug_on-to-mt_bug_on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-convert-bug_on-to-mt_bug_on.patch

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

maple_tree-clean-up-mas_parent_enum-and-rename-to-mas_parent_type.patch
maple_tree-add-format-option-to-mt_dump.patch
maple_tree-convert-bug_on-to-mt_bug_on.patch
maple_tree-change-rcu-checks-to-warn_on-instead-of-bug_on.patch
maple_tree-convert-debug-code-to-use-mt_warn_on-and-mas_warn_on.patch

