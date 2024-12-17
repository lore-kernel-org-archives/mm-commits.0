Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46731F9EA0;
	Tue, 17 Dec 2024 18:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461540; cv=none; b=L6zUiuyB7QC1o6lXdw0C6gekK+zhS2CL0smwALHxfqFg0iBsotyYGUimoM4UTz9PekEVSRFvppHoayfGWNCP+EI6jY56SKdFnypjDmR9FSo0FOZtMH2a0+Cl6HFKU5BoZFAdtK+SBNod1P7SyFiIAB2kxFd+p2On/iKlBR6OiiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461540; c=relaxed/simple;
	bh=qqJQgKvUKg1EhjCZ7E+pAM7lK2k/bl8Z+QJsFtnxvUA=;
	h=Date:To:From:Subject:Message-Id; b=JiXnuicKkueOvkvqMyXVQa3AkMvLpuhtJmviTOXgt9YwMBDuYKIB4kS2JUihpohdp7zPl6/WHweXx3NX+4MzobRzvbHyQ4VnkmDQadqY869x6zf0Y4H0UFRFuf2kfUH9ahJbhsNsKvZ2kuJFr9aFFhedktHq82B/sGsZc/46/jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mh7tI5Mu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mh7tI5Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D045C4CEE2;
	Tue, 17 Dec 2024 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734461540;
	bh=qqJQgKvUKg1EhjCZ7E+pAM7lK2k/bl8Z+QJsFtnxvUA=;
	h=Date:To:From:Subject:From;
	b=mh7tI5MuYHz6gXGBmr5KdvR7DvCsjKgKoWYRZ5x54JE6b/fmyiH6gFgsCmX+xuZ3C
	 PZS4JduO4q5vrq+ct3Rgxc4Og6+zgMLSsE6YDjFfRoEI/2rcLZmfVI96oU1JYs7B+g
	 M/ahH4mjXivUcrGlRA2oEPY3kEhoYL2aTzeuU03g=
Date: Tue, 17 Dec 2024 10:52:19 -0800
To: mm-commits@vger.kernel.org,yangerkun@huawei.com,stable@vger.kernel.org,chuck.lever@oracle.com,brauner@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241217185220.5D045C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix mas_alloc_cyclic() second search
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: maple_tree: fix mas_alloc_cyclic() second search
Date: Mon, 16 Dec 2024 14:01:12 -0500

The first search may leave the maple state in an error state.  Reset the
maple state before the second search so that the search has a chance of
executing correctly after an exhausted first search.

Link: https://lore.kernel.org/all/20241216060600.287B4C4CED0@smtp.kernel.org/
Link: https://lkml.kernel.org/r/20241216190113.1226145-2-Liam.Howlett@oracle.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix
+++ a/lib/maple_tree.c
@@ -4346,7 +4346,6 @@ int mas_alloc_cyclic(struct ma_state *ma
 {
 	unsigned long min = range_lo;
 	int ret = 0;
-	struct ma_state m = *mas;
 
 	range_lo = max(min, *next);
 	ret = mas_empty_area(mas, range_lo, range_hi, 1);
@@ -4355,7 +4354,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
-		*mas = m;
+		mas_reset(mas);
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-reload-mas-before-the-second-call-for-mas_empty_area-fix.patch
test_maple_tree-test-exhausted-upper-limit-of-mtree_alloc_cyclic.patch

