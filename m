Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844831494B3
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248824; cv=none; b=dJYN8rL3c/LWnYc/fPtx6bKwkHN6axK5BmuT6FEKSj2t3lFi6LMLjOUWuk1YeuMG3WtBkPlMVcxPQ8mynr8CF6aawPJqAVXfdqGMl8+NRMAa+SIPIFXMywCG4d0BHgjcauEqYEbfzzKPmAMei1fke1KK920hAFAqaURhSYdEwEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248824; c=relaxed/simple;
	bh=VfckF0045yTNgjHJozFCCnIDYlDcP1FS2xPWONho5FQ=;
	h=Date:To:From:Subject:Message-Id; b=Jg88Sb2CoH8Uqk7uIQ/GEM0jqI7XOe7kJe/2sgDL5cJQ0p0AbwoEiv/pvmolGCzozj9Rc3bF5IPjaXMR5xhm/cqBUk3abU/D/d7Scr9/n4/JBqit0zMQs91SFgeKN3lzmIVE2HLQen7J/+2tLaBhPPrjTD7Lfj8ef6xEvO2Gfs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOAH3Mxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOAH3Mxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4DBC4CEC2;
	Mon,  2 Sep 2024 03:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248824;
	bh=VfckF0045yTNgjHJozFCCnIDYlDcP1FS2xPWONho5FQ=;
	h=Date:To:From:Subject:From;
	b=kOAH3Mxly7bTGPg1+2ej0zb7Y3Byxf7yZl6SgFN6TIHfwBI/1Umep/xGN7xY+Hn8e
	 TMADpIRN8k48oR1sQPe8pN6r9brjBULUp7BpGqrQgjM53m0obQI0ud8pTk3jqoEz41
	 KhfgYqDDYCyhsKmA8xjrVT3DwR0/MwVI/4khKH6I=
Date: Sun, 01 Sep 2024 20:47:03 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch removed from -mm tree
Message-Id: <20240902034704.5C4DBC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: add missing description of nilfs_btree_path structure
has been removed from the -mm tree.  Its filename was
     nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: add missing description of nilfs_btree_path structure
Date: Fri, 16 Aug 2024 16:43:16 +0900

Add missing kernel-doc comment for the 'bp_ctxt' member variable of the
nilfs_btree_path structure, and eliminate the following warning output by
the kenrel-doc script:

 fs/nilfs2/btree.h:39: warning: Function parameter or struct member
  'bp_ctxt' not described in 'nilfs_btree_path'

Link: https://lkml.kernel.org/r/20240816074319.3253-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/btree.h~nilfs2-add-missing-description-of-nilfs_btree_path-structure
+++ a/fs/nilfs2/btree.h
@@ -24,6 +24,7 @@
  * @bp_index: index of child node
  * @bp_oldreq: ptr end request for old ptr
  * @bp_newreq: ptr alloc request for new ptr
+ * @bp_ctxt: context information for changing the key of a b-tree node block
  * @bp_op: rebalance operation
  */
 struct nilfs_btree_path {
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


