Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E515C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Apr 2022 17:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244175AbiD0Roh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Apr 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244758AbiD0RoU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2022 13:44:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBDF9F399
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 10:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDE5961E7D
        for <mm-commits@vger.kernel.org>; Wed, 27 Apr 2022 17:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1ACC385A9;
        Wed, 27 Apr 2022 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651081266;
        bh=KZxTOkquqnKvjvFbOjoLtZ0oZPQfuRt3ygHtt5avB+M=;
        h=Date:To:From:Subject:From;
        b=nyUxj2iRyeJy+9WUDxzZT6lPjICFcFewDcIZEJnOsBsCS16rlnDDM4qMxT9LW1al9
         uxXwrg9fetp8P5VAk3tEWiHuUu2OtOCez+aEeaRTMQEJY7YhZx2xA4+RXCv9deBA6Q
         g8n/j5OFa8+tBKfDeorhLDXdp4+/iXOsJtXIPWEw=
Date:   Wed, 27 Apr 2022 10:41:05 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to -mm tree
Message-Id: <20220427174106.4E1ACC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mas_store_prealloc() documentation
has been added to the -mm tree.  Its filename is
     maple-tree-add-new-data-structure-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maple-tree-add-new-data-structure-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maple-tree-add-new-data-structure-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mas_store_prealloc() documentation

Add gfp flags to the docs

Link: https://lkml.kernel.org/r/20220427141528.4thdegotfheuhfdu@revolver
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -5571,6 +5571,7 @@ void mas_store_prealloc(struct ma_state
  * mas_preallocate() - Preallocate enough nodes for a store operation
  * @mas: The maple state
  * @entry: The entry that will be stored
+ * @gfp: The GFP_FLAGS to use for allocations.
  *
  * Return: 0 on success, -ENOMEM if memory could not be allocated.
  */
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch

