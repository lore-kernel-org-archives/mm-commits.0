Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD24EC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjBJAwc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjBJAw0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6156A73E
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF7E9B82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FE4C433EF;
        Fri, 10 Feb 2023 00:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990341;
        bh=KAbl6hz/Fe7UJz9qXxloSLAOv/wGMVgm6glNIrMUFqE=;
        h=Date:To:From:Subject:From;
        b=0GYyberlyUU/DyVCXCp/Ms5BWaMI7d11cg/XQIfyKy6FZ6rcDmwfmjAodNWxvxDDP
         127QBgbmaV/19RdEHQ3tNQrYMleWyncWtpAZvxOHNdRHxZeb9BoomjTR84oOqr9j2f
         9Xj9JuNsVVyWIwsKQtxlLP0sdG8BSD4sMBp7Akzo=
Date:   Thu, 09 Feb 2023 16:52:21 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-mas_init-function.patch removed from -mm tree
Message-Id: <20230210005221.98FE4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: add mas_init() function
has been removed from the -mm tree.  Its filename was
     maple_tree-add-mas_init-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: add mas_init() function
Date: Fri, 20 Jan 2023 11:26:02 -0500

Patch series "VMA tree type safety and remove __vma_adjust()", v4.

This patchset does two things: 1.  Clean up, including removal of
__vma_adjust() and 2.  Extends the VMA iterator API to provide type safety
to the VMA operations using the maple tree, as requested by Linus [1].

It also addresses another issue of usability brought up by Linus about
needing to modify the maple state within the loops.  The maple state has
been replaced by the VMA iterator and the iterator is now modified within
the MM code so the caller should not need to worry about doing the work
themselves when tree modifications occur.

This brought up a potential inconsistency of the iterator state and what
the user expects, so the inconsistency is addressed to keep the VMA
iterator safe for use after the looping over a VMA range.  This is
addressed in patch 3 ("maple_tree: Reduce user error potential") and 4
("test_maple_tree: Test modifications while iterating").

While cleaning up the state, the duplicate locking code in mm/mmap.c
introduced by the maple tree has been address by abstracting it to two
functions: vma_prepare() and vma_complete().  These abstractions allowed
for a much simpler __vma_adjust(), which eventually leads to the removal
of the __vma_adjust() function by placing the logic into the vma_merge()
function itself.

1. https://lore.kernel.org/linux-mm/CAHk-=wg9WQXBGkNdKD2bqocnN73rDswuWsavBB7T-tekykEn_A@mail.gmail.com/


This patch (of 49):

Add a function that will zero out the maple state struct and set some
basic defaults.

Link: https://lkml.kernel.org/r/20230120162650.984577-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20230120162650.984577-2-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-add-mas_init-function
+++ a/include/linux/maple_tree.h
@@ -432,6 +432,7 @@ struct ma_wr_state {
 		.min = 0,						\
 		.max = ULONG_MAX,					\
 		.alloc = NULL,						\
+		.mas_flags = 0,						\
 	}
 
 #define MA_WR_STATE(name, ma_state, wr_entry)				\
@@ -470,6 +471,16 @@ void *mas_next(struct ma_state *mas, uns
 int mas_empty_area(struct ma_state *mas, unsigned long min, unsigned long max,
 		   unsigned long size);
 
+static inline void mas_init(struct ma_state *mas, struct maple_tree *tree,
+			    unsigned long addr)
+{
+	memset(mas, 0, sizeof(struct ma_state));
+	mas->tree = tree;
+	mas->index = mas->last = addr;
+	mas->max = ULONG_MAX;
+	mas->node = MAS_START;
+}
+
 /* Checks if a mas has not found anything */
 static inline bool mas_is_none(struct ma_state *mas)
 {
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


