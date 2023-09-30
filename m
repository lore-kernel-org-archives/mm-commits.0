Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F735E7734F
	for <mm-commits@archiver.kernel.org>; Sat, 30 Sep 2023 00:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjI3AVV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 20:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbjI3AVT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 20:21:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB31B6;
        Fri, 29 Sep 2023 17:21:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176A6C433CC;
        Sat, 30 Sep 2023 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696033277;
        bh=BOXFOmCjhGVUPIv7MNkaYg9RArm5d9WXK1IfFQrn7HA=;
        h=Date:To:From:Subject:From;
        b=euL0Vy3qhLMGjwbWzBxSENtlj7xOBsyU4vz4mjQ+mpTr4awBDWwOVaEcU/6K4qGmM
         5IiZOoPInOmrAJLH9DNOcYVEFaNqT3unPP5z5UtWBHLAStCpXLVZqNueVhd9gO/PeG
         yHs3nYpGXLDYPAe0ywmNXuSUg+f6Xf+a0VeKHuoI=
Date:   Fri, 29 Sep 2023 17:21:16 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        pedro.falcato@gmail.com, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maple_tree-add-mas_active-to-detect-in-tree-walks.patch removed from -mm tree
Message-Id: <20230930002117.176A6C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add mas_is_active() to detect in-tree walks
has been removed from the -mm tree.  Its filename was
     maple_tree-add-mas_active-to-detect-in-tree-walks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add mas_is_active() to detect in-tree walks
Date: Thu, 21 Sep 2023 14:12:35 -0400

Patch series "maple_tree: Fix mas_prev() state regression".

Pedro Falcato retported an mprotect regression [1] which was bisected back
to the iterator changes for maple tree.  Root cause analysis showed the
mas_prev() running off the end of the VMA space (previous from 0) followed
by mas_find(), would skip the first value.

This patchset introduces maple state underflow/overflow so the sequence of
calls on the maple state will return what the user expects.

Users who encounter this bug may see mprotect(), userfaultfd_register(),
and mlock() fail on VMAs mapped with address 0.


This patch (of 2):

Instead of constantly checking each possibility of the maple state,
create a fast path that will skip over checking unlikely states.

Link: https://lkml.kernel.org/r/20230921181236.509072-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230921181236.509072-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-mas_active-to-detect-in-tree-walks
+++ a/include/linux/maple_tree.h
@@ -511,6 +511,15 @@ static inline bool mas_is_paused(const s
 	return mas->node == MAS_PAUSE;
 }
 
+/* Check if the mas is pointing to a node or not */
+static inline bool mas_is_active(struct ma_state *mas)
+{
+	if ((unsigned long)mas->node >= MAPLE_RESERVED_RANGE)
+		return true;
+
+	return false;
+}
+
 /**
  * mas_reset() - Reset a Maple Tree operation state.
  * @mas: Maple Tree operation state.
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-add-mas_underflow-and-mas_overflow-states.patch
mm-mempolicy-fix-set_mempolicy_home_node-previous-vma-pointer.patch
mmap-fix-vma_iterator-in-error-path-of-vma_merge.patch
mmap-fix-error-paths-with-dup_anon_vma.patch
mmap-add-clarifying-comment-to-vma_merge-code.patch
radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

