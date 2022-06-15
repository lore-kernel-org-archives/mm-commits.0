Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5A7C43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 20:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbiFOUMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 16:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbiFOUMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 16:12:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867534B1C9
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 13:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 420A4B82176
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 20:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFDBC3411A;
        Wed, 15 Jun 2022 20:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655323935;
        bh=njwme5eLvDFVzzlYYo0xWDjKAqTrS5yF8upWq2Od+aI=;
        h=Date:To:From:Subject:From;
        b=PkDNDXwj/LR0zRP9ZcwYMFV6LuoDlF3JmCqijLjLd9eD85gFdQZj27k0Nxju7UwYU
         x6kivZMJF1L28iU9gY4qM91qsPV4b2hp8EtuykkBhPijFVCu055EB3Lmxd7c2XAMeg
         It54/dpL0/b4fitaolUeNYyJUYBJqR6hIjti9/3o=
Date:   Wed, 15 Jun 2022 13:12:15 -0700
To:     mm-commits@vger.kernel.org, quic_qiancai@quicinc.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-new-data-structure-fix-7.patch added to mm-unstable branch
Message-Id: <20220615201215.BAFDBC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: fix mt_destroy_walk() on full non-leaf non-alloc nodes
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-add-new-data-structure-fix-7.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-new-data-structure-fix-7.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: maple_tree: fix mt_destroy_walk() on full non-leaf non-alloc nodes
Date: Wed, 15 Jun 2022 14:19:38 +0000

It is possible to iterate over the metadata of full non-leaf nodes when
operating in non-alloc mode.

Link: https://lkml.kernel.org/r/20220615141921.417598-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple-tree-add-new-data-structure-fix-7
+++ a/lib/maple_tree.c
@@ -5429,11 +5429,15 @@ static void mt_destroy_walk(struct maple
 			goto start_slots_free;
 		type = mte_node_type(mas.node);
 		slots = ma_slots(mte_to_node(mas.node), type);
-		if ((offset < mt_slots[type]) && (slots[offset])) {
-			struct maple_enode *parent = mas.node;
+		if ((offset < mt_slots[type])) {
+			struct maple_enode *next = slots[offset];
 
-			mas.node = mas_slot_locked(&mas, slots, offset);
-			slots = mas_destroy_descend(&mas, parent, offset);
+			if (mte_node_type(next) && mte_to_node(next)) {
+				struct maple_enode *parent = mas.node;
+
+				mas.node = mas_slot_locked(&mas, slots, offset);
+				slots = mas_destroy_descend(&mas, parent, offset);
+			}
 		}
 		node = mas_mn(&mas);
 	} while (start != mas.node);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

maple-tree-add-new-data-structure-fix.patch
maple-tree-add-new-data-structure-fix-2.patch
maple-tree-add-new-data-structure-fix-3.patch
maple-tree-add-new-data-structure-fix-4.patch
maple-tree-add-new-data-structure-fix-7.patch
maple-tree-add-new-data-structure-fix-8.patch
lib-test_maple_tree-add-testing-for-maple-tree-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix-2.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-2.patch
mm-mmap-change-do_brk_munmap-to-use-do_mas_align_munmap-fix.patch
mm-remove-the-vma-linked-list-fix.patch

