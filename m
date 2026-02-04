Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7098D29993F
	for <mm-commits@vger.kernel.org>; Wed,  4 Feb 2026 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234998; cv=none; b=cUn6A0iafWXfUWdDQbZFScQIUv2jqybM1DSN206NIsv4VC/8PIonjIcSx63u40G2lv9do0NRtYGdrw2LAtRS8xbkjCSKiOEJu+k21plCATsM+J4iIQ3uhStI7omnoYEYY+PHR5QWW89EfZYKEK5n8CKXoLsTdEMkpLEtWEmgakE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234998; c=relaxed/simple;
	bh=p/72iFidKRHPdQ0FD2gkgbgh9lBq+u8aU67OOlS/fvo=;
	h=Date:To:From:Subject:Message-Id; b=cYezRVQnfxSPDtNUHECd/5SNG8xXDF3/DJAycG/pbZLCtRBGILR6+RmVV8lOmKOQ7Lm/EHzRRIU35HMu7cYeE9r2prmx5Ew5hp8rB4jgJ8ZDe28RZfDUfuzmcE18O48k9O5k8rZwNS4jJB4gOdOvrWD7bK52X8ocYiYw/kEI/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Td8nnNsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Td8nnNsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B13C4CEF7;
	Wed,  4 Feb 2026 19:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770234998;
	bh=p/72iFidKRHPdQ0FD2gkgbgh9lBq+u8aU67OOlS/fvo=;
	h=Date:To:From:Subject:From;
	b=Td8nnNsPvcUomf/ZdbDMODhiFKVw4R9sFVfZASsMO9jLCaY0ODiUP1HlUJyepjsgj
	 21Y1cGUv+j84YrbBywif2hZ/fcGV20ibTX4hf3tZ6H3l8a2dFYyzBNsd6SX9s3j97M
	 ZvvrUfBZncvinca2m4Tg3NzbCSpN4tZ96KRH/snQ=
Date: Wed, 04 Feb 2026 11:56:37 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,Liam.Howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-add-cp_is_new_root-helper-fix-fix.patch added to mm-new branch
Message-Id: <20260204195637.F2B13C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-add-cp_is_new_root-helper-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-add-cp_is_new_root-helper-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maple_tree-add-cp_is_new_root-helper-fix-fix
Date: Wed Feb  4 11:54:03 AM PST 2026

s/cp->slot[0]/&cp->slot[0]/, per Liam

Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-add-cp_is_new_root-helper-fix-fix
+++ a/lib/maple_tree.c
@@ -3361,7 +3361,7 @@ static inline bool cp_is_new_root(struct
 		 * read-side operations that can view it until it is insert into
 		 * the tree after an rcu_assign_pointer() call.
 		 */
-		ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
+		ma_init_slot(&cp->slot[0], cp->dst[0].node, mt);
 		cp->height++;
 	}
 	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

