Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA6AC7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbjFIXc7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjFIXbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B3F469F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7387963EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCE7C433D2;
        Fri,  9 Jun 2023 23:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353370;
        bh=FGdpIMI94vPnDvXdYuruSsGQsHMmEw4c3pC6rpgW+Pk=;
        h=Date:To:From:Subject:From;
        b=PddwMa1YDH2YZ2v1NYyHTuck+ADH53ikFlCz9jreNQjEKbRSvdHISAa9kiq71pZIc
         K1DCAwBZpk4+7KonjoPyVBzNt+6JTOMFmyy9cCZ0Pi4N0WGeCmAjzYW4fnbiNs1Pix
         SbOGyM7GtsbXdZ2wYOHIEbubMqURUYJhxUFKaGYQ=
Date:   Fri, 09 Jun 2023 16:29:30 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-the-arguments-to-__must_hold.patch removed from -mm tree
Message-Id: <20230609232930.CCCE7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: fix the arguments to __must_hold()
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-the-arguments-to-__must_hold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: fix the arguments to __must_hold()
Date: Wed, 24 May 2023 11:12:40 +0800

Fix the arguments to __must_hold() to make sparse work.

Link: https://lkml.kernel.org/r/20230524031247.65949-4-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-the-arguments-to-__must_hold
+++ a/lib/maple_tree.c
@@ -1752,7 +1752,7 @@ static inline void mas_adopt_children(st
  * leave the node (true) and handle the adoption and free elsewhere.
  */
 static inline void mas_replace(struct ma_state *mas, bool advanced)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	struct maple_node *mn = mas_mn(mas);
 	struct maple_enode *old_enode;
@@ -1792,7 +1792,7 @@ static inline void mas_replace(struct ma
  * @child: the maple state to store the child.
  */
 static inline bool mas_new_child(struct ma_state *mas, struct ma_state *child)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	enum maple_type mt;
 	unsigned char offset;
@@ -6204,7 +6204,7 @@ EXPORT_SYMBOL_GPL(mas_erase);
  * Return: true on allocation, false otherwise.
  */
 bool mas_nomem(struct ma_state *mas, gfp_t gfp)
-	__must_hold(mas->tree->lock)
+	__must_hold(mas->tree->ma_lock)
 {
 	if (likely(mas->node != MA_ERROR(-ENOMEM))) {
 		mas_destroy(mas);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


