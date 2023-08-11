Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDCEC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbjHKXBz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237029AbjHKXAg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A043C0A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3E57634A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AA8C433C8;
        Fri, 11 Aug 2023 23:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794820;
        bh=BRZL67lmh/F/LnkvxoCvKTD7rMZQc3vf61n1wfeBWJY=;
        h=Date:To:From:Subject:From;
        b=kZPVAf72k53m21nSXRszR36rIoVX7h2jM/NP7mXa/YB5pju0KB4XEWcgvlAbrf9Ir
         1QukHlEn9QX9bWA+040I05Tmasrj9R9wbUYVn7qls6xrYy5V2Cjtp9vyLY36OAizfV
         a4WIWnGLad+RF3nvA6afXqrX6AmTbZL7alckCE3w=
Date:   Fri, 11 Aug 2023 16:00:19 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        geert@linux-m68k.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-update-mt_validate.patch removed from -mm tree
Message-Id: <20230811230020.25AA8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: update mt_validate()
has been removed from the -mm tree.  Its filename was
     maple_tree-update-mt_validate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: update mt_validate()
Date: Tue, 11 Jul 2023 11:54:42 +0800

Instead of using mas_first_entry() to find the leftmost leaf, use a simple
loop instead.  Remove an unneeded check for root node.  To make the error
message more accurate, check pivots first and then slots, because checking
slots depend on the node limit pivot to break the loop.

Link: https://lkml.kernel.org/r/20230711035444.526-7-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/lib/maple_tree.c~maple_tree-update-mt_validate
+++ a/lib/maple_tree.c
@@ -7244,21 +7244,20 @@ void mt_validate(struct maple_tree *mt)
 	if (!mas_searchable(&mas))
 		goto done;
 
-	mas_first_entry(&mas, mas_mn(&mas), ULONG_MAX, mte_node_type(mas.node));
+	while (!mte_is_leaf(mas.node))
+		mas_descend(&mas);
+
 	while (!mas_is_none(&mas)) {
 		MAS_WARN_ON(&mas, mte_dead_node(mas.node));
-		if (!mte_is_root(mas.node)) {
-			end = mas_data_end(&mas);
-			if (MAS_WARN_ON(&mas,
-					(end < mt_min_slot_count(mas.node)) &&
-					(mas.max != ULONG_MAX))) {
-				pr_err("Invalid size %u of %p\n", end,
-				       mas_mn(&mas));
-			}
+		end = mas_data_end(&mas);
+		if (MAS_WARN_ON(&mas, (end < mt_min_slot_count(mas.node)) &&
+				(mas.max != ULONG_MAX))) {
+			pr_err("Invalid size %u of %p\n", end, mas_mn(&mas));
 		}
+
 		mas_validate_parent_slot(&mas);
-		mas_validate_child_slot(&mas);
 		mas_validate_limits(&mas);
+		mas_validate_child_slot(&mas);
 		if (mt_is_alloc(mt))
 			mas_validate_gaps(&mas);
 		mas_dfs_postorder(&mas, ULONG_MAX);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


