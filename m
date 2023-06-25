Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F58EB64DC
	for <mm-commits@archiver.kernel.org>; Sun, 25 Jun 2023 03:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjFYD5O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 24 Jun 2023 23:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjFYD5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 24 Jun 2023 23:57:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE2DE52
        for <mm-commits@vger.kernel.org>; Sat, 24 Jun 2023 20:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86600609FB
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 03:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BF6C433C0;
        Sun, 25 Jun 2023 03:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687665430;
        bh=JGtbutUhlPK+gyFDtCLmk4GfpzxkOCm9/GVKA91CONU=;
        h=Date:To:From:Subject:From;
        b=aGm/m+cu2nabhtBjAB59mn2Qau0g/q6ybrNnCl/LsHy+TEwHDm7qc2yCpX6lECfC+
         gyhyxPjzB45XyQnuSvEW3qutg6hy+FbEpRc2F6fqxMjFlH3oyH50A6Kw1LlSQxtxcU
         zSQ07YDuZ+v4guCiV1sAKyrUCCLEgMKwJCsvbPgo=
Date:   Sat, 24 Jun 2023 20:57:09 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch added to mm-unstable branch
Message-Id: <20230625035710.C0BF6C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: update obsolete comment in get_pfn_range_for_nid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mm_init.c: update obsolete comment in get_pfn_range_for_nid()
Date: Sun, 25 Jun 2023 11:33:40 +0800

Since commit 633c0666b5a5 ("Memoryless nodes: drop one memoryless node boot
warning"), the warning for a node with no available memory is removed.
Update the corresponding comment.

Link: https://lkml.kernel.org/r/20230625033340.1054103-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid
+++ a/mm/mm_init.c
@@ -1677,8 +1677,7 @@ static inline void alloc_node_mem_map(st
  *
  * It returns the start and end page frame of a node based on information
  * provided by memblock_set_node(). If called for a node
- * with no available memory, a warning is printed and the start and end
- * PFNs will be 0.
+ * with no available memory, the start and end PFNs will be 0.
  */
 void __init get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch

