Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5CF4084E
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576960; cv=none; b=Yey+G7qqMoxHoEpOnzo4odjD1MaN6Ny3W6U9Vu0CcvNL86wpIfB3apBMAHPZc2BvHK+xF8e4hlEL7huviLj0EBGbzwof16xPhMxPibKirtiqdMxTdyBYqf0a6IJ8Qj25HtmFt9jL3WOfiznQ1v4WPNZAGhxX2r34xxJOnKfvN1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576960; c=relaxed/simple;
	bh=90P0rAUXGi0X+qlpnHoCe7V9JOAPQkG+IVUA0hbyFb0=;
	h=Date:To:From:Subject:Message-Id; b=oh5m6s4Qpo2x2qeWygWwBsP/05+lSZYi7tyoXvbvHgWOvYYAPCHC2SDJ9Rqfgo1g4ioZwzi5hedPCxQ8Jp61xmEnufnfEOqvqolZjRscoiCNo9ohVC7yjrhyxiW+v/ulGOpuy1SHOQH9aLSfTyWs4z9YvaVeIDKMZMWVB9ziEKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uaXlxzAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uaXlxzAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376BDC2BBFC;
	Fri, 24 May 2024 18:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576960;
	bh=90P0rAUXGi0X+qlpnHoCe7V9JOAPQkG+IVUA0hbyFb0=;
	h=Date:To:From:Subject:From;
	b=uaXlxzAiufnV20btvssDZWTiFK3Tg+C/gbpgTXAFYtfT4UpWVPIPyNelvY25oW8KA
	 BQmvfW08hpOVjerYUgjZYTSp2k+VaoNeX9zIPVKex7Y3Da0BboSu7x7uFFM9LBm0OK
	 rwi6jgr6tVYMkZgw4YvCVupwRYhxwOAgqnjjjuNw=
Date: Fri, 24 May 2024 11:55:59 -0700
To: mm-commits@vger.kernel.org,shr@devkernel.io,hughd@google.com,david@redhat.com,aarcange@redhat.com,chengming.zhou@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-possible-uaf-of-stable_node.patch removed from -mm tree
Message-Id: <20240524185600.376BDC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix possible UAF of stable_node
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-possible-uaf-of-stable_node.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengming Zhou <chengming.zhou@linux.dev>
Subject: mm/ksm: fix possible UAF of stable_node
Date: Mon, 13 May 2024 11:07:56 +0800

The commit 2c653d0ee2ae ("ksm: introduce ksm_max_page_sharing per page
deduplication limit") introduced a possible failure case in the
stable_tree_insert(), where we may free the new allocated stable_node_dup
if we fail to prepare the missing chain node.

Then that kfolio return and unlock with a freed stable_node set...  And
any MM activities can come in to access kfolio->mapping, so UAF.

Fix it by moving folio_set_stable_node() to the end after stable_node
is inserted successfully.

Link: https://lkml.kernel.org/r/20240513-b4-ksm-stable-node-uaf-v1-1-f687de76f452@linux.dev
Fixes: 2c653d0ee2ae ("ksm: introduce ksm_max_page_sharing per page deduplication limit")
Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-possible-uaf-of-stable_node
+++ a/mm/ksm.c
@@ -2153,7 +2153,6 @@ again:
 
 	INIT_HLIST_HEAD(&stable_node_dup->hlist);
 	stable_node_dup->kpfn = kpfn;
-	folio_set_stable_node(kfolio, stable_node_dup);
 	stable_node_dup->rmap_hlist_len = 0;
 	DO_NUMA(stable_node_dup->nid = nid);
 	if (!need_chain) {
@@ -2172,6 +2171,8 @@ again:
 		stable_node_chain_add_dup(stable_node_dup, stable_node);
 	}
 
+	folio_set_stable_node(kfolio, stable_node_dup);
+
 	return stable_node_dup;
 }
 
_

Patches currently in -mm which might be from chengming.zhou@linux.dev are


