Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869EFC0015E
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjGQSZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjGQSYn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:24:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ED51BCD
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 112636120B
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A64EC433C8;
        Mon, 17 Jul 2023 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689618254;
        bh=iUrLDEe+r41F/Dhfuyt5936Ak4/rasfppmG/EkjxYsQ=;
        h=Date:To:From:Subject:From;
        b=bG6LCIFhsgu1f0HOU5H4LrjNYgBQ1ofssBymvVzNbfXVfgINaAtg26C6Kiu4c97mg
         wKNugf2K0pYUc1t8cECCyML7a2K4ZuP/9nrAmHLufHTbD0pnLMTcm1szHzY4c0jVIu
         T4TkvW62vK8EMEiIFs1jbXjd9h7ChOtCqdxp3wxg=
Date:   Mon, 17 Jul 2023 11:24:13 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch added to mm-unstable branch
Message-Id: <20230717182414.6A64EC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: mtree_insert*: fix typo in kernel-doc description
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch

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
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: maple_tree: mtree_insert*: fix typo in kernel-doc description
Date: Sat, 15 Jul 2023 17:39:20 +0300

Replace "Insert and entry at a give index" with "Insert an entry at a
given index"

Link: https://lkml.kernel.org/r/20230715143920.994812-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-mtree_insert-fix-typo-in-kernel-doc-description
+++ a/lib/maple_tree.c
@@ -6274,7 +6274,7 @@ int mtree_store(struct maple_tree *mt, u
 EXPORT_SYMBOL(mtree_store);
 
 /**
- * mtree_insert_range() - Insert an entry at a give range if there is no value.
+ * mtree_insert_range() - Insert an entry at a given range if there is no value.
  * @mt: The maple tree
  * @first: The start of the range
  * @last: The end of the range
@@ -6310,7 +6310,7 @@ retry:
 EXPORT_SYMBOL(mtree_insert_range);
 
 /**
- * mtree_insert() - Insert an entry at a give index if there is no value.
+ * mtree_insert() - Insert an entry at a given index if there is no value.
  * @mt: The maple tree
  * @index : The index to store the value
  * @entry: The entry to store
_

Patches currently in -mm which might be from rppt@kernel.org are

maple_tree-mtree_insert-fix-typo-in-kernel-doc-description.patch

