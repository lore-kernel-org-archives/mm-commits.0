Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F622170C6
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 20:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729110541; cv=none; b=PVmPUrpNR6J4jfH/MiyXTWXi3thI1l64gEyaNngX8NZItTjuvXIfPb7mFQelTbDZ8+MtK2tA9Pt8vJ7u6U4FRJt+VUGpkLHyO+uhsh37WmEgsIhdExuL6pCjPkVw//fjNM/LU7p9oxdZqnQPRFR8+MlGfwlpwdBBBAzAfN+Sl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729110541; c=relaxed/simple;
	bh=cC647cCFyyFqZWL5DvfFpguS0QaSW7AnACZFpGHDdOs=;
	h=Date:To:From:Subject:Message-Id; b=eqLPZsbBJTQ3vRVNdWBfox/6YQWmlNdjgH+QetyX2Dr/95re1taD6h/LvpnJB4AOxE+RqAhJJWyIkB57wOMyeGtacBXHpOFltohERbss+sspxBpjllY+EM5craATo34ChHJml+AqqJ7aMDUts3AnLxWfBEW15crzYKsLAAZ2+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sqlYr1YS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sqlYr1YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB15C4CEC5;
	Wed, 16 Oct 2024 20:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729110540;
	bh=cC647cCFyyFqZWL5DvfFpguS0QaSW7AnACZFpGHDdOs=;
	h=Date:To:From:Subject:From;
	b=sqlYr1YSmMvus7T+Og9kE08HR9vC03uJ9ofb20cMHDBTJ6KprxTJ6qepTo8umDPEi
	 prwxOhi8rgRgtg9/OQSN8zQsZZTF4Jm6kvqFsyeKfNPBePSErN+y5n3T46+NtTpPF8
	 i5gAwcZ7P7VwHSar8TIUmmCRZjQxlM67kTD8ieJE=
Date: Wed, 16 Oct 2024 13:28:59 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch added to mm-unstable branch
Message-Id: <20241016202900.8EB15C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove sanity check from mas_wr_slot_store()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: remove sanity check from mas_wr_slot_store()
Date: Wed, 16 Oct 2024 00:22:21 +0000

After commit 5d659bbb52a2 ("maple_tree: introduce mas_wr_store_type()"),
the check here is redundant.

Let's remove it.

Link: https://lkml.kernel.org/r/20241016002221.32428-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-sanity-check-from-mas_wr_slot_store
+++ a/lib/maple_tree.c
@@ -3888,7 +3888,7 @@ static inline void mas_wr_slot_store(str
 			wr_mas->pivots[offset] = mas->index - 1;
 			mas->offset++; /* Keep mas accurate. */
 		}
-	} else if (!mt_in_rcu(mas->tree)) {
+	} else {
 		/*
 		 * Expand the range, only partially overwriting the previous and
 		 * next ranges
@@ -3898,8 +3898,6 @@ static inline void mas_wr_slot_store(str
 		wr_mas->pivots[offset] = mas->index - 1;
 		wr_mas->pivots[offset + 1] = mas->last;
 		mas->offset++; /* Keep mas accurate. */
-	} else {
-		return;
 	}
 
 	trace_ma_write(__func__, mas, 0, wr_mas->entry);
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
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-one-single-entry-couldnt-represent-the-whole-range.patch
maple_tree-calculate-new_end-when-needed.patch
maple_tree-remove-sanity-check-from-mas_wr_slot_store.patch

