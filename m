Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C643C727AB
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbjHXXW4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244120AbjHXXWS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D164A1
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D7BF63A67
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77682C433C8;
        Thu, 24 Aug 2023 23:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919334;
        bh=Of7Q4ZtaJYKCxRhjbC1oYrEiP9kHyoTq/HXoXVh0zYM=;
        h=Date:To:From:Subject:From;
        b=UvimHtcpbfbgNB68Qz+airOej5u3gmW1+l7xRzkg4kgv0Lc59xxdw5s6iUtmrq+P8
         SZ7SH9tf4b/yceOr9Ez36gJuZWza2Kxf2ufNZYwH5OCCjkR80ep3NErDrsWt95wFDm
         PrV8jX/pqtAduFuhGeW3hIvH9BeHktMk45jCgoAk=
Date:   Thu, 24 Aug 2023 16:22:13 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-get_mctgt_type-kernel-doc.patch removed from -mm tree
Message-Id: <20230824232214.77682C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix get_mctgt_type() kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-fix-get_mctgt_type-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix get_mctgt_type() kernel-doc
Date: Fri, 18 Aug 2023 21:06:28 +0100

Convert the return values to an ReST list and tidy up the wording while
I'm touching it.

[akpm@linux-foundation.org: changes suggested by Randy]
[willy@infradead.org: another change suggested by Randy]
  Link: https://lkml.kernel.org/r/ZOUZtZizeQG7PcsM@casper.infradead.org
Link: https://lkml.kernel.org/r/20230818200630.2719595-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

--- a/mm/memcontrol.c~mm-fix-get_mctgt_type-kernel-doc
+++ a/mm/memcontrol.c
@@ -5850,25 +5850,20 @@ out:
  * @ptent: the pte to be checked
  * @target: the pointer the target page or swap ent will be stored(can be NULL)
  *
- * Returns
- *   0(MC_TARGET_NONE): if the pte is not a target for move charge.
- *   1(MC_TARGET_PAGE): if the page corresponding to this pte is a target for
- *     move charge. if @target is not NULL, the page is stored in target->page
- *     with extra refcnt got(Callers should handle it).
- *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
- *     target for charge migration. if @target is not NULL, the entry is stored
- *     in target->ent.
- *   3(MC_TARGET_DEVICE): like MC_TARGET_PAGE  but page is device memory and
- *   thus not on the lru.
- *     For now we such page is charge like a regular page would be as for all
- *     intent and purposes it is just special memory taking the place of a
- *     regular page.
- *
- *     See Documentations/vm/hmm.txt and include/linux/hmm.h
- *
- * Called with pte lock held.
+ * Context: Called with pte lock held.
+ * Return:
+ * * MC_TARGET_NONE - If the pte is not a target for move charge.
+ * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
+ *   move charge. If @target is not NULL, the page is stored in target->page
+ *   with extra refcnt taken (Caller should release it).
+ * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
+ *   target for charge migration.  If @target is not NULL, the entry is
+ *   stored in target->ent.
+ * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
+ *   thus not on the lru.  For now such page is charged like a regular page
+ *   would be as it is just special memory taking the place of a regular page.
+ *   See Documentations/vm/hmm.txt and include/linux/hmm.h
  */
-
 static enum mc_target_type get_mctgt_type(struct vm_area_struct *vma,
 		unsigned long addr, pte_t ptent, union mc_target *target)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


