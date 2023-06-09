Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAB9C7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjFIXbK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjFIX3J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0004215
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:28:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9221361782
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4362C433D2;
        Fri,  9 Jun 2023 23:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353324;
        bh=UYe54cva5yRdRGakkMmThWH2DmEppO26v6AKWmplqeU=;
        h=Date:To:From:Subject:From;
        b=Cl7LSKnvrakbg/pDIXFsMeqkayyK9Ll8Vlu60kngtPM8jHnBLItsJtWS/bbLjCTOB
         oxbeXDkV48k0XQJ4nzgAWaCA/tZJzino5BC2fEDR/motbiUJc+FCf1Uc2dtCYwTZ3X
         PyGaTbu9/NKw4jGGl5CZ9derXz1yjiRGhSp7h9Ac=
Date:   Fri, 09 Jun 2023 16:28:43 -0700
To:     mm-commits@vger.kernel.org, zhangpeng.00@bytedance.com,
        vernon2gm@gmail.com, senozhatsky@chromium.org,
        richard.weiyang@gmail.com, dcb314@hotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-update-testing-code-for-mas_nextprevwalk.patch removed from -mm tree
Message-Id: <20230609232843.E4362C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maple_tree: update testing code for mas_{next,prev,walk}
has been removed from the -mm tree.  Its filename was
     maple_tree-update-testing-code-for-mas_nextprevwalk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: update testing code for mas_{next,prev,walk}
Date: Thu, 18 May 2023 10:55:42 -0400

Now that the functions have changed the limits, update the testing of the
maple tree to test these new settings.

Link: https://lkml.kernel.org/r/20230518145544.1722059-34-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Binderman <dcb314@hotmail.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |  638 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 633 insertions(+), 5 deletions(-)

--- a/lib/test_maple_tree.c~maple_tree-update-testing-code-for-mas_nextprevwalk
+++ a/lib/test_maple_tree.c
@@ -1322,6 +1322,7 @@ static noinline void __init check_root_e
 	mas_lock(&mas);
 	mas_set(&mas, 3);
 	ptr = mas_walk(&mas);
+	MT_BUG_ON(mt, mas.index != 0);
 	MT_BUG_ON(mt, ptr != NULL);
 	MT_BUG_ON(mt, mas.index != 0);
 	MT_BUG_ON(mt, mas.last != ULONG_MAX);
@@ -1391,7 +1392,7 @@ static noinline void __init check_root_e
 	mas_store_gfp(&mas, ptr, GFP_KERNEL);
 	ptr = mas_next(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, ptr != NULL);
-	MT_BUG_ON(mt, (mas.index != 1) && (mas.last != ULONG_MAX));
+	MT_BUG_ON(mt, (mas.index != ULONG_MAX) && (mas.last != ULONG_MAX));
 
 	mas_set(&mas, 1);
 	ptr = mas_prev(&mas, 0);
@@ -1800,7 +1801,6 @@ static noinline void __init check_iterat
 			mas.index = 760;
 			mas.last = 765;
 			mas_store(&mas, val);
-			mas_next(&mas, ULONG_MAX);
 		}
 		i++;
 	}
@@ -2011,7 +2011,7 @@ static noinline void __init next_prev_te
 
 	val = mas_next(&mas, ULONG_MAX);
 	MT_BUG_ON(mt, val != NULL);
-	MT_BUG_ON(mt, mas.index != ULONG_MAX);
+	MT_BUG_ON(mt, mas.index != 0x7d6);
 	MT_BUG_ON(mt, mas.last != ULONG_MAX);
 
 	val = mas_prev(&mas, 0);
@@ -2035,7 +2035,8 @@ static noinline void __init next_prev_te
 	val = mas_prev(&mas, 0);
 	MT_BUG_ON(mt, val != NULL);
 	MT_BUG_ON(mt, mas.index != 0);
-	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.last != 5);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
 
 	mas.index = 0;
 	mas.last = 5;
@@ -2047,7 +2048,7 @@ static noinline void __init next_prev_te
 	val = mas_prev(&mas, 0);
 	MT_BUG_ON(mt, val != NULL);
 	MT_BUG_ON(mt, mas.index != 0);
-	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.last != 9);
 	mas_unlock(&mas);
 
 	mtree_destroy(mt);
@@ -2750,6 +2751,629 @@ static noinline void __init check_empty_
 	mt_set_non_kernel(0);
 }
 
+/*
+ * Check MAS_START, MAS_PAUSE, active (implied), and MAS_NONE transitions.
+ *
+ * The table below shows the single entry tree (0-0 pointer) and normal tree
+ * with nodes.
+ *
+ * Function	ENTRY	Start		Result		index & last
+ *     ┬          ┬       ┬               ┬                ┬
+ *     │          │       │               │                └─ the final range
+ *     │          │       │               └─ The node value after execution
+ *     │          │       └─ The node value before execution
+ *     │          └─ If the entry exists or does not exists (DNE)
+ *     └─ The function name
+ *
+ * Function	ENTRY	Start		Result		index & last
+ * mas_next()
+ *  - after last
+ *			Single entry tree at 0-0
+ *			------------------------
+ *		DNE	MAS_START	MAS_NONE	1 - oo
+ *		DNE	MAS_PAUSE	MAS_NONE	1 - oo
+ *		DNE	MAS_ROOT	MAS_NONE	1 - oo
+ *			when index = 0
+ *		DNE	MAS_NONE	MAS_ROOT	0
+ *			when index > 0
+ *		DNE	MAS_NONE	MAS_NONE	1 - oo
+ *
+ *			Normal tree
+ *			-----------
+ *		exists	MAS_START	active		range
+ *		DNE	MAS_START	active		set to last range
+ *		exists	MAS_PAUSE	active		range
+ *		DNE	MAS_PAUSE	active		set to last range
+ *		exists	MAS_NONE	active		range
+ *		exists	active		active		range
+ *		DNE	active		active		set to last range
+ *
+ * Function	ENTRY	Start		Result		index & last
+ * mas_prev()
+ * - before index
+ *			Single entry tree at 0-0
+ *			------------------------
+ *				if index > 0
+ *		exists	MAS_START	MAS_ROOT	0
+ *		exists	MAS_PAUSE	MAS_ROOT	0
+ *		exists	MAS_NONE	MAS_ROOT	0
+ *
+ *				if index == 0
+ *		DNE	MAS_START	MAS_NONE	0
+ *		DNE	MAS_PAUSE	MAS_NONE	0
+ *		DNE	MAS_NONE	MAS_NONE	0
+ *		DNE	MAS_ROOT	MAS_NONE	0
+ *
+ *			Normal tree
+ *			-----------
+ *		exists	MAS_START	active		range
+ *		DNE	MAS_START	active		set to min
+ *		exists	MAS_PAUSE	active		range
+ *		DNE	MAS_PAUSE	active		set to min
+ *		exists	MAS_NONE	active		range
+ *		DNE	MAS_NONE	MAS_NONE	set to min
+ *		any	MAS_ROOT	MAS_NONE	0
+ *		exists	active		active		range
+ *		DNE	active		active		last range
+ *
+ * Function	ENTRY	Start		Result		index & last
+ * mas_find()
+ *  - at index or next
+ *			Single entry tree at 0-0
+ *			------------------------
+ *				if index >  0
+ *		DNE	MAS_START	MAS_NONE	0
+ *		DNE	MAS_PAUSE	MAS_NONE	0
+ *		DNE	MAS_ROOT	MAS_NONE	0
+ *		DNE	MAS_NONE	MAS_NONE	0
+ *				if index ==  0
+ *		exists	MAS_START	MAS_ROOT	0
+ *		exists	MAS_PAUSE	MAS_ROOT	0
+ *		exists	MAS_NONE	MAS_ROOT	0
+ *
+ *			Normal tree
+ *			-----------
+ *		exists	MAS_START	active		range
+ *		DNE	MAS_START	active		set to max
+ *		exists	MAS_PAUSE	active		range
+ *		DNE	MAS_PAUSE	active		set to max
+ *		exists	MAS_NONE	active		range
+ *		exists	active		active		range
+ *		DNE	active		active		last range (max < last)
+ *
+ * Function	ENTRY	Start		Result		index & last
+ * mas_find_rev()
+ *  - at index or before
+ *			Single entry tree at 0-0
+ *			------------------------
+ *				if index >  0
+ *		exists	MAS_START	MAS_ROOT	0
+ *		exists	MAS_PAUSE	MAS_ROOT	0
+ *		exists	MAS_NONE	MAS_ROOT	0
+ *				if index ==  0
+ *		DNE	MAS_START	MAS_NONE	0
+ *		DNE	MAS_PAUSE	MAS_NONE	0
+ *		DNE	MAS_NONE	MAS_NONE	0
+ *		DNE	MAS_ROOT	MAS_NONE	0
+ *
+ *			Normal tree
+ *			-----------
+ *		exists	MAS_START	active		range
+ *		DNE	MAS_START	active		set to min
+ *		exists	MAS_PAUSE	active		range
+ *		DNE	MAS_PAUSE	active		set to min
+ *		exists	MAS_NONE	active		range
+ *		exists	active		active		range
+ *		DNE	active		active		last range (min > index)
+ *
+ * Function	ENTRY	Start		Result		index & last
+ * mas_walk()
+ * - Look up index
+ *			Single entry tree at 0-0
+ *			------------------------
+ *				if index >  0
+ *		DNE	MAS_START	MAS_ROOT	1 - oo
+ *		DNE	MAS_PAUSE	MAS_ROOT	1 - oo
+ *		DNE	MAS_NONE	MAS_ROOT	1 - oo
+ *		DNE	MAS_ROOT	MAS_ROOT	1 - oo
+ *				if index ==  0
+ *		exists	MAS_START	MAS_ROOT	0
+ *		exists	MAS_PAUSE	MAS_ROOT	0
+ *		exists	MAS_NONE	MAS_ROOT	0
+ *		exists	MAS_ROOT	MAS_ROOT	0
+ *
+ *			Normal tree
+ *			-----------
+ *		exists	MAS_START	active		range
+ *		DNE	MAS_START	active		range of NULL
+ *		exists	MAS_PAUSE	active		range
+ *		DNE	MAS_PAUSE	active		range of NULL
+ *		exists	MAS_NONE	active		range
+ *		DNE	MAS_NONE	active		range of NULL
+ *		exists	active		active		range
+ *		DNE	active		active		range of NULL
+ */
+
+#define mas_active(x)		(((x).node != MAS_ROOT) && \
+				 ((x).node != MAS_START) && \
+				 ((x).node != MAS_PAUSE) && \
+				 ((x).node != MAS_NONE))
+static noinline void __init check_state_handling(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, 0);
+	void *entry, *ptr = (void *) 0x1234500;
+	void *ptr2 = &ptr;
+	void *ptr3 = &ptr2;
+
+	/* Check MAS_ROOT First */
+	mtree_store_range(mt, 0, 0, ptr, GFP_KERNEL);
+
+	mas_lock(&mas);
+	/* prev: Start -> none */
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* prev: Start -> root */
+	mas_set(&mas, 10);
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* prev: pause -> root */
+	mas_set(&mas, 10);
+	mas_pause(&mas);
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* next: start -> none */
+	mas_set(&mas, 0);
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* next: start -> none */
+	mas_set(&mas, 10);
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find: start -> root */
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* find: root -> none */
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find: none -> none */
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find: start -> none */
+	mas_set(&mas, 10);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find_rev: none -> root */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* find_rev: start -> root */
+	mas_set(&mas, 0);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* find_rev: root -> none */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find_rev: none -> none */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* find_rev: start -> root */
+	mas_set(&mas, 10);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* walk: start -> none */
+	mas_set(&mas, 10);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* walk: pause -> none*/
+	mas_set(&mas, 10);
+	mas_pause(&mas);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* walk: none -> none */
+	mas.index = mas.last = 10;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* walk: none -> none */
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* walk: start -> root */
+	mas_set(&mas, 0);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* walk: pause -> root */
+	mas_set(&mas, 0);
+	mas_pause(&mas);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* walk: none -> root */
+	mas.node = MAS_NONE;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* walk: root -> root */
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	/* walk: root -> none */
+	mas_set(&mas, 10);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 1);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, mas.node != MAS_NONE);
+
+	/* walk: none -> root */
+	mas.index = mas.last = 0;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0);
+	MT_BUG_ON(mt, mas.node != MAS_ROOT);
+
+	mas_unlock(&mas);
+
+	/* Check when there is an actual node */
+	mtree_store_range(mt, 0, 0, NULL, GFP_KERNEL);
+	mtree_store_range(mt, 0x1000, 0x1500, ptr, GFP_KERNEL);
+	mtree_store_range(mt, 0x2000, 0x2500, ptr2, GFP_KERNEL);
+	mtree_store_range(mt, 0x3000, 0x3500, ptr3, GFP_KERNEL);
+
+	mas_lock(&mas);
+
+	/* next: start ->active */
+	mas_set(&mas, 0);
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next: pause ->active */
+	mas_set(&mas, 0);
+	mas_pause(&mas);
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next: none ->active */
+	mas.index = mas.last = 0;
+	mas.offset = 0;
+	mas.node = MAS_NONE;
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next:active ->active */
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr2);
+	MT_BUG_ON(mt, mas.index != 0x2000);
+	MT_BUG_ON(mt, mas.last != 0x2500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next:active -> active out of range*/
+	entry = mas_next(&mas, 0x2999);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x2501);
+	MT_BUG_ON(mt, mas.last != 0x2fff);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* Continue after out of range*/
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr3);
+	MT_BUG_ON(mt, mas.index != 0x3000);
+	MT_BUG_ON(mt, mas.last != 0x3500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next:active -> active out of range*/
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x3501);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* next: none -> active, skip value at location */
+	mas_set(&mas, 0);
+	entry = mas_next(&mas, ULONG_MAX);
+	mas.node = MAS_NONE;
+	mas.offset = 0;
+	entry = mas_next(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr2);
+	MT_BUG_ON(mt, mas.index != 0x2000);
+	MT_BUG_ON(mt, mas.last != 0x2500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* prev:active ->active */
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* prev:active -> active out of range*/
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0x0FFF);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* prev: pause ->active */
+	mas_set(&mas, 0x3600);
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr3);
+	mas_pause(&mas);
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr2);
+	MT_BUG_ON(mt, mas.index != 0x2000);
+	MT_BUG_ON(mt, mas.last != 0x2500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* prev:active -> active out of range*/
+	entry = mas_prev(&mas, 0x1600);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1501);
+	MT_BUG_ON(mt, mas.last != 0x1FFF);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* prev: active ->active, continue*/
+	entry = mas_prev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find: start ->active */
+	mas_set(&mas, 0);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find: pause ->active */
+	mas_set(&mas, 0);
+	mas_pause(&mas);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find: start ->active on value */;
+	mas_set(&mas, 1200);
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find:active ->active */
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != ptr2);
+	MT_BUG_ON(mt, mas.index != 0x2000);
+	MT_BUG_ON(mt, mas.last != 0x2500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+
+	/* find:active -> active (NULL)*/
+	entry = mas_find(&mas, 0x2700);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x2501);
+	MT_BUG_ON(mt, mas.last != 0x2FFF);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find: none ->active */
+	entry = mas_find(&mas, 0x5000);
+	MT_BUG_ON(mt, entry != ptr3);
+	MT_BUG_ON(mt, mas.index != 0x3000);
+	MT_BUG_ON(mt, mas.last != 0x3500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find:active -> active (NULL) end*/
+	entry = mas_find(&mas, ULONG_MAX);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x3501);
+	MT_BUG_ON(mt, mas.last != ULONG_MAX);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find_rev: active (END) ->active */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr3);
+	MT_BUG_ON(mt, mas.index != 0x3000);
+	MT_BUG_ON(mt, mas.last != 0x3500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find_rev:active ->active */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr2);
+	MT_BUG_ON(mt, mas.index != 0x2000);
+	MT_BUG_ON(mt, mas.last != 0x2500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find_rev: pause ->active */
+	mas_pause(&mas);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find_rev:active -> active */
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0);
+	MT_BUG_ON(mt, mas.last != 0x0FFF);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* find_rev: start ->active */
+	mas_set(&mas, 0x1200);
+	entry = mas_find_rev(&mas, 0);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk start ->active */
+	mas_set(&mas, 0x1200);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk start ->active */
+	mas_set(&mas, 0x1600);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1501);
+	MT_BUG_ON(mt, mas.last != 0x1fff);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk pause ->active */
+	mas_set(&mas, 0x1200);
+	mas_pause(&mas);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk pause -> active */
+	mas_set(&mas, 0x1600);
+	mas_pause(&mas);
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1501);
+	MT_BUG_ON(mt, mas.last != 0x1fff);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk none -> active */
+	mas_set(&mas, 0x1200);
+	mas.node = MAS_NONE;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk none -> active */
+	mas_set(&mas, 0x1600);
+	mas.node = MAS_NONE;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1501);
+	MT_BUG_ON(mt, mas.last != 0x1fff);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk active -> active */
+	mas.index = 0x1200;
+	mas.last = 0x1200;
+	mas.offset = 0;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != ptr);
+	MT_BUG_ON(mt, mas.index != 0x1000);
+	MT_BUG_ON(mt, mas.last != 0x1500);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	/* mas_walk active -> active */
+	mas.index = 0x1600;
+	mas.last = 0x1600;
+	entry = mas_walk(&mas);
+	MT_BUG_ON(mt, entry != NULL);
+	MT_BUG_ON(mt, mas.index != 0x1501);
+	MT_BUG_ON(mt, mas.last != 0x1fff);
+	MT_BUG_ON(mt, !mas_active(mas));
+
+	mas_unlock(&mas);
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -3011,6 +3635,10 @@ static int __init maple_tree_seed(void)
 	mtree_destroy(&tree);
 
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_state_handling(&tree);
+	mtree_destroy(&tree);
+
 #if defined(BENCH)
 skip:
 #endif
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mprotect-fix-do_mprotect_pkey-limit-check.patch
maple_tree-add-benchmarking-for-mas_for_each.patch
maple_tree-add-benchmarking-for-mas_prev.patch
mm-move-unmap_vmas-declaration-to-internal-header.patch
mm-change-do_vmi_align_munmap-side-tree-index.patch
mm-remove-prev-check-from-do_vmi_align_munmap.patch
maple_tree-introduce-__mas_set_range.patch
mm-remove-re-walk-from-mmap_region.patch
maple_tree-re-introduce-entry-to-mas_preallocate-arguments.patch
mm-use-vma_iter_clear_gfp-in-nommu.patch
mm-set-up-vma-iterator-for-vma_iter_prealloc-calls.patch
maple_tree-move-mas_wr_end_piv-below-mas_wr_extend_null.patch
maple_tree-update-mas_preallocate-testing.patch
maple_tree-refine-mas_preallocate-node-calculations.patch
mm-mmap-change-vma-iteration-order-in-do_vmi_align_munmap.patch
userfaultfd-fix-regression-in-userfaultfd_unmap_prep.patch

