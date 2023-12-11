Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B83184C
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WraEyaqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D75C433C7;
	Mon, 11 Dec 2023 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256029;
	bh=apuAnmPmQhc1nuDvZKGDlC9py+sVD5yrO7UNLDXu7lM=;
	h=Date:To:From:Subject:From;
	b=WraEyaqc57vGf4hpg/cIi6aNhkC99nmnrn17y8QaZJrGIxen4fYhrsT/mOiIcH19h
	 0tYGrf6HX1xglDq4fpzlXcbOjIPMBMkDvaCx0ni50mBnq2Cx6hal9385vlwhtySy9s
	 FB6Wuu64HulS1o3bX9Yk7qNNq/WWUcyzy5ptPCQs=
Date: Sun, 10 Dec 2023 16:53:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterz@infradead.org,npiggin@gmail.com,mst@redhat.com,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,Liam.Howlett@oracle.com,corbet@lwn.net,brauner@kernel.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-introduce-mtreemas_lock_nested.patch removed from -mm tree
Message-Id: <20231211005349.C7D75C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: introduce {mtree,mas}_lock_nested()
has been removed from the -mm tree.  Its filename was
     maple_tree-introduce-mtreemas_lock_nested.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: introduce {mtree,mas}_lock_nested()
Date: Fri, 27 Oct 2023 11:38:37 +0800

In some cases, nested locks may be needed, so {mtree,mas}_lock_nested is
introduced.  For example, when duplicating maple tree, we need to hold the
locks of two trees, in which case nested locks are needed.

At the same time, add the definition of spin_lock_nested() in tools for
testing.

Link: https://lkml.kernel.org/r/20231027033845.90608-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h     |    4 ++++
 tools/include/linux/spinlock.h |    1 +
 2 files changed, 5 insertions(+)

--- a/include/linux/maple_tree.h~maple_tree-introduce-mtreemas_lock_nested
+++ a/include/linux/maple_tree.h
@@ -256,6 +256,8 @@ struct maple_tree {
 	struct maple_tree name = MTREE_INIT(name, 0)
 
 #define mtree_lock(mt)		spin_lock((&(mt)->ma_lock))
+#define mtree_lock_nested(mas, subclass) \
+		spin_lock_nested((&(mt)->ma_lock), subclass)
 #define mtree_unlock(mt)	spin_unlock((&(mt)->ma_lock))
 
 /*
@@ -406,6 +408,8 @@ struct ma_wr_state {
 };
 
 #define mas_lock(mas)           spin_lock(&((mas)->tree->ma_lock))
+#define mas_lock_nested(mas, subclass) \
+		spin_lock_nested(&((mas)->tree->ma_lock), subclass)
 #define mas_unlock(mas)         spin_unlock(&((mas)->tree->ma_lock))
 
 
--- a/tools/include/linux/spinlock.h~maple_tree-introduce-mtreemas_lock_nested
+++ a/tools/include/linux/spinlock.h
@@ -11,6 +11,7 @@
 #define spin_lock_init(x)	pthread_mutex_init(x, NULL)
 
 #define spin_lock(x)			pthread_mutex_lock(x)
+#define spin_lock_nested(x, subclass)	pthread_mutex_lock(x)
 #define spin_unlock(x)			pthread_mutex_unlock(x)
 #define spin_lock_bh(x)			pthread_mutex_lock(x)
 #define spin_unlock_bh(x)		pthread_mutex_unlock(x)
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

