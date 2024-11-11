Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07CD165EED
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313724; cv=none; b=W+e5r9K+d4JSkj6zktf1hPFAlC9hx53FtAJWHE1pafKbcLYqcuH9EcboO00t2k6iv+uS44c8f0LHipIpbEmuVFs2rL85dw9XQ4V0bsU/4wPurnus6vbO4kmvNzlUQC2Ny3uxTe7eYuiuavdDHoK67lPmJ4Zumiaf2uzggSPau4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313724; c=relaxed/simple;
	bh=XSd7mRGXdkmt5JSghhJGrHRX1lLr9YEt5o4NnndMUAs=;
	h=Date:To:From:Subject:Message-Id; b=aM5tHusj8p4hEJ5YTa26G1NAlfbsp5rfFqSvVatTT0H1pa/139Z4m/PH9jfBsxAl2ioS5IhEcoRz1T/4abVnrpPlVCPxmSlN+yOElRLZcVD+6a7I6tIBWUn8PlgdGIcePKD7sy5NducpGV7/Sws0f8TYmZuERLYaFRqrMp9Rjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TLPpaWre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TLPpaWre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7D7C4CED0;
	Mon, 11 Nov 2024 08:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313724;
	bh=XSd7mRGXdkmt5JSghhJGrHRX1lLr9YEt5o4NnndMUAs=;
	h=Date:To:From:Subject:From;
	b=TLPpaWreWpBamuzmsrz9xjK6Vbva1zUhzdsQzkoDmpJ1mCb5DYSWGqObKuRkijIfZ
	 TJZdInBB9/C/SA3XQbHGoiih1EeOwLluaIwRZokFsLsPY8Wp5BINZqDVyXAUuThXCq
	 LIdC8UNeIp/6QUPnajC49qEr8nya2Q6sKNRhsVgs=
Date: Mon, 11 Nov 2024 00:28:43 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-a-test-checking-storing-null.patch removed from -mm tree
Message-Id: <20241111082844.4A7D7C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add a test checking storing null
has been removed from the -mm tree.  Its filename was
     maple_tree-add-a-test-checking-storing-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: add a test checking storing null
Date: Thu, 31 Oct 2024 23:16:27 +0000

Add a test to assert that, when storing null to am empty tree or a
single entry tree it will not result into:

  * a root node with range [0, ULONG_MAX] set to NULL
  * a root node with consecutive slot set to NULL

[akpm@linux-foundation.org: work around build error (mas_root)]
Link: https://lkml.kernel.org/r/20241031231627.14316-6-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_maple_tree.c |   90 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

--- a/lib/test_maple_tree.c~maple_tree-add-a-test-checking-storing-null
+++ a/lib/test_maple_tree.c
@@ -1387,6 +1387,92 @@ static noinline void __init check_prev_e
 	mas_unlock(&mas);
 }
 
+static noinline void __init check_store_null(struct maple_tree *mt)
+{
+	MA_STATE(mas, mt, 0, ULONG_MAX);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to an empty tree should result
+	 * in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at any range to an empty tree should result in an empty
+	 * tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set_range(&mas, 3, 10);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to a single entry tree should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 0, ULONG_MAX);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, n] to a single entry tree should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 0, 5);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [m, n] where m > 0 to a single entry tree
+	 * should still be a single entry tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set(&mas, 0);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+	mas_set_range(&mas, 2, 5);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, mtree_empty(mt));
+//	MT_BUG_ON(mt, xa_is_node(mas_root(&mas)));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+
+	/*
+	 * Store NULL at range [0, ULONG_MAX] to a tree with node should
+	 * result in an empty tree
+	 */
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	mas_lock(&mas);
+	mas_set_range(&mas, 1, 3);
+	mas_store_gfp(&mas, &mas, GFP_KERNEL);
+//	MT_BUG_ON(mt, !xa_is_node(mas_root(&mas)));
+	mas_set_range(&mas, 0, ULONG_MAX);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	MT_BUG_ON(mt, !mtree_empty(mt));
+	mas_unlock(&mas);
+	mtree_destroy(mt);
+}
+
 static noinline void __init check_root_expand(struct maple_tree *mt)
 {
 	MA_STATE(mas, mt, 0, 0);
@@ -3711,6 +3797,10 @@ static int __init maple_tree_seed(void)
 #endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_store_null(&tree);
+	mtree_destroy(&tree);
+
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_root_expand(&tree);
 	mtree_destroy(&tree);
 
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


