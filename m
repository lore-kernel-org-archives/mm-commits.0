Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AC420FE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHW4XXGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616A5C433C7;
	Mon, 11 Dec 2023 00:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256034;
	bh=hADlPa4wy5LoO5i7vpBJAWFggAStfGuD6UgkVoXijWk=;
	h=Date:To:From:Subject:From;
	b=wHW4XXGyoWWiWNQCmTOXq7mAXkjFWabqcM8Ktq7oH50Y1BdyOkYP9f60iOjIIWLGR
	 MsorlKZuWUEc/hKBpUmvs5Hu30dR2/fCVyziZx5QClMirr8AB0JW0jd4nhmqkX6xQJ
	 5Du9qfaETshRFJ2ISll6GbKbnLORpI+RXMp1IUSY=
Date: Sun, 10 Dec 2023 16:53:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterz@infradead.org,npiggin@gmail.com,mst@redhat.com,mjguzik@gmail.com,michael.christie@oracle.com,mathieu.desnoyers@efficios.com,Liam.Howlett@oracle.com,corbet@lwn.net,brauner@kernel.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-update-the-documentation-of-maple-tree.patch removed from -mm tree
Message-Id: <20231211005354.616A5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: update the documentation of maple tree
has been removed from the -mm tree.  Its filename was
     maple_tree-update-the-documentation-of-maple-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: update the documentation of maple tree
Date: Fri, 27 Oct 2023 11:38:41 +0800

Introduce the new interface mtree_dup() in the documentation.

Link: https://lkml.kernel.org/r/20231027033845.90608-7-zhangpeng.00@bytedance.com
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

 Documentation/core-api/maple_tree.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-update-the-documentation-of-maple-tree
+++ a/Documentation/core-api/maple_tree.rst
@@ -81,6 +81,9 @@ section.
 Sometimes it is necessary to ensure the next call to store to a maple tree does
 not allocate memory, please see :ref:`maple-tree-advanced-api` for this use case.
 
+You can use mtree_dup() to duplicate an entire maple tree. It is a more
+efficient way than inserting all elements one by one into a new tree.
+
 Finally, you can remove all entries from a maple tree by calling
 mtree_destroy().  If the maple tree entries are pointers, you may wish to free
 the entries first.
@@ -112,6 +115,7 @@ Takes ma_lock internally:
  * mtree_insert()
  * mtree_insert_range()
  * mtree_erase()
+ * mtree_dup()
  * mtree_destroy()
  * mt_set_in_rcu()
  * mt_clear_in_rcu()
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch
maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch
maple_tree-remove-an-unused-parameter-for-ma_meta_end.patch
maple_tree-delete-one-of-the-two-identical-checks.patch
maple_tree-simplify-mas_leaf_set_meta.patch

