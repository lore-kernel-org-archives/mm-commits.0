Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0111740DFA7
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 17:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777052826; cv=none; b=VMG8FItiYnHvTEgK91d7w0nHLDltaBcUFC8gtq18IiJWeaCzFWdr/7UNV3stFmUpBptxohh4rhJNL4lmHenZdqQwYcamKC+na4z8+6Xh6Fmb0Wk6OPzXawJ+iZuE+DxiNmTMFVRqI7wXX4D72ojDzsKppLaYCYeS+K+Rc8y/DxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777052826; c=relaxed/simple;
	bh=XKPBCt6pZwxoWn254FtX6NwyN33xtQyCb9snQJN7CRg=;
	h=Date:To:From:Subject:Message-Id; b=a4MH2bVYP4jDuInn3KX1Ru/r1kvDgj6+ChxE7jc4Gj25NdONp51APBLpLx8cO7TU89OCFe9TtnHxIFjFyAVJ4r5xHL7HWGfQkWnEnmc3DVHhLCVsWKoAzdW3DlcjyAcMjcUL7AHIN2icZ3MpKpL4yM+8vYurgZeYxBfn5NKYldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YjXWR+j9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YjXWR+j9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F789C19425;
	Fri, 24 Apr 2026 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777052825;
	bh=XKPBCt6pZwxoWn254FtX6NwyN33xtQyCb9snQJN7CRg=;
	h=Date:To:From:Subject:From;
	b=YjXWR+j9eQr3iSeVs7hoTIUdO5STGjwQ1xfegd3hlk53TKjjwGZQs0RpkKslS9J79
	 6wl7ik72rV0qxXVhnPZHo1Gp2e8rD4zCEIu3oCYqnIJJb1Ydo/J4LPlJca/0bhTmM0
	 avFE4DeZAnPy0f3wZ4ohVaRSCCuQFv/lyRnsZy8g=
Date: Fri, 24 Apr 2026 10:47:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-use-bool-for-forcekill-state.patch added to mm-new branch
Message-Id: <20260424174705.9F789C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: use bool for forcekill state
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-use-bool-for-forcekill-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-use-bool-for-forcekill-state.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/memory-failure: use bool for forcekill state
Date: Fri, 10 Apr 2026 15:47:39 +0800

'forcekill' is used as a boolean flag to control whether processes should
be forcibly killed.  It is only assigned from boolean expressions and
never used in arithmetic or bitmask operations.

Convert it from int to bool.

No functional change intended.

Link: https://lore.kernel.org/20260410074740.2524718-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liu Ye <liuye@kylinos.cn>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-use-bool-for-forcekill-state
+++ a/mm/memory-failure.c
@@ -470,7 +470,7 @@ void add_to_kill_ksm(struct task_struct
  * Only do anything when FORCEKILL is set, otherwise just free the
  * list (this is used for clean pages which do not need killing)
  */
-static void kill_procs(struct list_head *to_kill, int forcekill,
+static void kill_procs(struct list_head *to_kill, bool forcekill,
 		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
@@ -1665,7 +1665,7 @@ static bool hwpoison_user_mappings(struc
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int forcekill;
+	bool forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
 	/*
@@ -1786,7 +1786,7 @@ static void unmap_and_kill(struct list_h
 		unmap_mapping_range(mapping, start, size, 0);
 	}
 
-	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
+	kill_procs(to_kill, !!(flags & MF_MUST_KILL), pfn, flags);
 }
 
 /*
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-memory-failure-use-bool-for-forcekill-state.patch

