Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1AFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 18:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350472AbiDSStm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349093AbiDSStl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 14:49:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6603B37AAA
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 11:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D071B81A06
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 18:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF769C385A5;
        Tue, 19 Apr 2022 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650394015;
        bh=c7ksAyBJXPRdJujH3c15ZkoobpTi7zjtI/Kggc8eKNA=;
        h=Date:To:From:Subject:From;
        b=idjZFswTHjkwiwa94/bhFYtcA16QCp46zdXPSNuNEboF63CiTFopaADSt7XE6PNY6
         cGlL7QG19/jxXDMdGa3BPWqGZ/tSD9RSM+mYv1LXkph2UrO9Tod3Svw7BJpiDRRsYS
         0TMWsV+u3BZEspvrf2W7awoAMVjwjiY1HZSbZO28=
Date:   Tue, 19 Apr 2022 11:46:54 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        liam.howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix.patch added to -mm tree
Message-Id: <20220419184655.BF769C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: clean up after bulk allocation failure in mas_alloc_nodes()
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
Subject: maple_tree: clean up after bulk allocation failure in mas_alloc_nodes()

Link: https://lkml.kernel.org/r/20220419155055.qf52xpcftqb3r5nj@revolver
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix
+++ a/lib/maple_tree.c
@@ -1206,6 +1206,8 @@ static inline void mas_alloc_nodes(struc
 	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
 	unsigned int count;
+	void **slots = NULL;
+	unsigned int max_req = 0;
 
 	if (!requested)
 		return;
@@ -1214,7 +1216,7 @@ static inline void mas_alloc_nodes(struc
 	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS - 1) {
 		node = (struct maple_alloc *)mt_alloc_one(gfp);
 		if (!node)
-			goto nomem;
+			goto nomem_one;
 
 		if (allocated)
 			node->slot[0] = mas->alloc;
@@ -1226,20 +1228,20 @@ static inline void mas_alloc_nodes(struc
 
 	node = mas->alloc;
 	while (requested) {
-		void **slots = (void **)&node->slot;
-		unsigned int max_req = MAPLE_NODE_SLOTS - 1;
-
+		max_req = MAPLE_NODE_SLOTS - 1;
 		if (node->slot[0]) {
 			unsigned int offset = node->node_count + 1;
 
 			slots = (void **)&node->slot[offset];
 			max_req -= offset;
+		} else {
+			slots = (void **)&node->slot;
 		}
 
-		count = mt_alloc_bulk(gfp, min(requested, max_req),
-				      slots);
+		max_req = min(requested, max_req);
+		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
-			goto nomem;
+			goto nomem_bulk;
 
 		node->node_count += count;
 		/* zero indexed. */
@@ -1253,7 +1255,11 @@ static inline void mas_alloc_nodes(struc
 	}
 	mas->alloc->total = success;
 	return;
-nomem:
+
+nomem_bulk:
+	/* Clean up potential freed allocations on bulk failure */
+	memset(slots, 0, max_req * sizeof(unsigned long));
+nomem_one:
 	mas_set_alloc_req(mas, requested);
 	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
 		mas->alloc->total = success;
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

radix-tree-test-suite-add-lockdep_is_held-to-header.patch
mips-rename-mt_init-to-mips_mt_init.patch
maple-tree-add-new-data-structure-fix.patch
lib-test_maple_tree-add-testing-for-maple-tree.patch
mmap-change-zeroing-of-maple-tree-in-__vma_adjust.patch
riscv-use-vma-iterator-for-vdso.patch
mm-mmapc-pass-in-mapping-to-__vma_link_file.patch
mglru-vs-maple-tree-fix.patch

