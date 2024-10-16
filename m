Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009E518D62D
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 20:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729110780; cv=none; b=Y3WnjZzStfe24EvnchFRbxcB2KkwUpQBvWwPPT8n0YYTeacI40tjcLwnPdSu+voG8AshC7Q+N5DyKXTYLS93zreVlBmkRBdmjSD79fqILfif6GmGsjtnCqu+UbHSN28RjP2uA8fIMCiqdn7OSpvCststa0qtI8FWxwk2yuhCbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729110780; c=relaxed/simple;
	bh=lkYNo2Ds0CpIRA3Usifm2NyjxFNiOQdXhZ5AMUZAcMo=;
	h=Date:To:From:Subject:Message-Id; b=caEeOfwuF3p5zgtITxJL3negG0fL3OvhmcyfHpvLR3Biq1I6sAOuN26A1Pl3fy/71mSmunq/KlsHZMwc99bPNv24tQnRrkTs03vj0NoDKTJhG1JjsGbxD6NJMQgVaRjEmD7dEDqn3ruK+PfN33BYwSSrgxcHqwV1zUv2b8kazgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NBjmdoQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NBjmdoQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830CFC4CEC5;
	Wed, 16 Oct 2024 20:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729110779;
	bh=lkYNo2Ds0CpIRA3Usifm2NyjxFNiOQdXhZ5AMUZAcMo=;
	h=Date:To:From:Subject:From;
	b=NBjmdoQQx/mIHP66tKgL5OKEOij5mGWQ2+qmu8oEuMTy/kQC/h1m4tQ1VmfrR58Jc
	 6i7WbZMPxZA51RIBwYoaNUZEF+jkEpuIfHTajX7AxNWGPyNd75RonRnTY/oN+Y6TFc
	 suv5tEQgh9aCDt3WlwxDyI9+vXJtDo7AlKkISAuM=
Date: Wed, 16 Oct 2024 13:32:58 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maple_tree-not-necessary-to-check-index-last-again.patch removed from -mm tree
Message-Id: <20241016203259.830CFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: not necessary to check index/last again
has been removed from the -mm tree.  Its filename was
     maple_tree-not-necessary-to-check-index-last-again.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: not necessary to check index/last again
Date: Tue, 15 Oct 2024 23:39:08 +0000

Patch series "fix mas_new_root()".

When overwriting the whole range with NULL, current behavior is not correct.


This patch (of 2):

Before calling mas_new_root(), the range has been checked.

Link: https://lkml.kernel.org/r/20241015233909.23592-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20241015233909.23592-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-not-necessary-to-check-index-last-again
+++ a/lib/maple_tree.c
@@ -3670,7 +3670,7 @@ static inline void mas_new_root(struct m
 	void __rcu **slots;
 	unsigned long *pivots;
 
-	if (!entry && !mas->index && mas->last == ULONG_MAX) {
+	if (!entry) {
 		mas->depth = 0;
 		mas_set_height(mas);
 		rcu_assign_pointer(mas->tree->ma_root, entry);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch
maple_tree-remove-maple_big_nodeparent.patch
maple_tree-memset-maple_big_node-as-a-whole.patch
maple_tree-root-node-could-be-handled-by-p_slot-too.patch
maple_tree-clear-request_count-for-new-allocated-one.patch
maple_tree-total-is-not-changed-for-nomem_one-case.patch
maple_tree-simplify-mas_push_node.patch
maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

