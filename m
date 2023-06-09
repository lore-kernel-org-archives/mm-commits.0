Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683E5C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjFIXc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbjFIXbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF6E469D
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A1C265CFE
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCB1C433EF;
        Fri,  9 Jun 2023 23:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353368;
        bh=CfQd+uNUZv6wjLE8rDKdc2nHskUL02RqFIRXgn068+k=;
        h=Date:To:From:Subject:From;
        b=m780miV6qiEHQFLBRARhIq4aifZ1gvTp10UhY5e2PBofN6TVo+REffKwEcWV2lh57
         zhFr+qfPy6xIqKPJRF0TLQNGrIK/gzoba4wbfu3UN+sNuO6Vl111XZ3o56zuimAj4b
         80BGMOhQbV+RkJ135aGjJ0FNch9LKmiSEjZCEwFw=
Date:   Fri, 09 Jun 2023 16:29:28 -0700
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        zhangpeng.00@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-rework-mtree_alloc_rangerrange.patch removed from -mm tree
Message-Id: <20230609232928.AFCB1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: rework mtree_alloc_{range,rrange}()
has been removed from the -mm tree.  Its filename was
     maple_tree-rework-mtree_alloc_rangerrange.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: rework mtree_alloc_{range,rrange}()
Date: Wed, 24 May 2023 11:12:38 +0800

Patch series "Clean ups for maple tree", v4.

Some clean ups, mainly to make the code of maple tree more concise.
This patchset has passed the self-test.


This patch (of 10):

Use mas_empty_area{_rev}() to refactor mtree_alloc_{range,rrange}()

Link: https://lkml.kernel.org/r/20230524031247.65949-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   57 +++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 25 deletions(-)

--- a/lib/maple_tree.c~maple_tree-rework-mtree_alloc_rangerrange
+++ a/lib/maple_tree.c
@@ -6493,31 +6493,33 @@ int mtree_alloc_range(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, min);
+	MA_STATE(mas, mt, 0, 0);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(mt_is_reserved(entry)))
 		return -EINVAL;
 
-	if (min > max)
-		return -EINVAL;
-
-	if (max < size)
-		return -EINVAL;
-
-	if (!size)
-		return -EINVAL;
-
 	mtree_lock(mt);
 retry:
-	mas.offset = 0;
-	mas.index = min;
-	mas.last = max - size + 1;
-	ret = mas_alloc(&mas, entry, size, startp);
+	ret = mas_empty_area(&mas, min, max, size);
+	if (ret)
+		goto unlock;
+
+	mas_insert(&mas, entry);
+	/*
+	 * mas_nomem() may release the lock, causing the allocated area
+	 * to be unavailable, so try to allocate a free area again.
+	 */
 	if (mas_nomem(&mas, gfp))
 		goto retry;
 
+	if (mas_is_err(&mas))
+		ret = xa_err(mas.node);
+	else
+		*startp = mas.index;
+
+unlock:
 	mtree_unlock(mt);
 	return ret;
 }
@@ -6529,28 +6531,33 @@ int mtree_alloc_rrange(struct maple_tree
 {
 	int ret = 0;
 
-	MA_STATE(mas, mt, min, max - size + 1);
+	MA_STATE(mas, mt, 0, 0);
 	if (!mt_is_alloc(mt))
 		return -EINVAL;
 
 	if (WARN_ON_ONCE(mt_is_reserved(entry)))
 		return -EINVAL;
 
-	if (min > max)
-		return -EINVAL;
-
-	if (max < size - 1)
-		return -EINVAL;
-
-	if (!size)
-		return -EINVAL;
-
 	mtree_lock(mt);
 retry:
-	ret = mas_rev_alloc(&mas, min, max, entry, size, startp);
+	ret = mas_empty_area_rev(&mas, min, max, size);
+	if (ret)
+		goto unlock;
+
+	mas_insert(&mas, entry);
+	/*
+	 * mas_nomem() may release the lock, causing the allocated area
+	 * to be unavailable, so try to allocate a free area again.
+	 */
 	if (mas_nomem(&mas, gfp))
 		goto retry;
 
+	if (mas_is_err(&mas))
+		ret = xa_err(mas.node);
+	else
+		*startp = mas.index;
+
+unlock:
 	mtree_unlock(mt);
 	return ret;
 }
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


