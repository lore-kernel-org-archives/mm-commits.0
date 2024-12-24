Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCB7372;
	Tue, 24 Dec 2024 01:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735002551; cv=none; b=lmFaPyfPgJldILB6CdtCYNccl/ldFpfPiwRIpY/t2JyQzQ8cV4SOcupfD0DgEdC5kFHdz13NkO037WfViC9qdQlL+btvUsKuJnFPL+282F0LtsnhyzjwZUf8JAl8EssSiRhe0RcE3MxfpwTV0eZMYidrZz8gPLhjLvv7q9A1Z1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735002551; c=relaxed/simple;
	bh=Kr/+4B5L79XPyQ3i5e4ZvHG1fIHyqshiqLWcGoOj3EA=;
	h=Date:To:From:Subject:Message-Id; b=SD8FEhcB8C+q9fbJFh4rOIrzfbOfk13xlKacLeF8P8PwoDXnKOifgR/aBWlhma6NlADsAzLjPJdP4QNf7hLJ0ShI0aLujFqR39oQReKFaXFwOs0vbASqkC4NOtBYVaacta/edFSs0aoWo/nMwUWYhStEXI5r0mpme8pvMKV3Bog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jqltGmka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jqltGmka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26452C4CED3;
	Tue, 24 Dec 2024 01:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735002551;
	bh=Kr/+4B5L79XPyQ3i5e4ZvHG1fIHyqshiqLWcGoOj3EA=;
	h=Date:To:From:Subject:From;
	b=jqltGmka0CLDWTWGsLRXjcj2mh7MTUizuNMxgppYm78+jwIDQCOwd0dziDXrwWXdW
	 SGL9GTwGtoBN1L3IS+bauc7DOTsNLjwELSGQU69n720MgDprvG9UerbwdxOiDvGT+M
	 D74Jj1Di9wFcEZhrcVTK8KFvlBo93tVJnbsto4rI=
Date: Mon, 23 Dec 2024 17:09:10 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch added to mm-hotfixes-unstable branch
Message-Id: <20241224010911.26452C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix new damon_target objects leaks on damon_commit_targets()
Date: Sun, 22 Dec 2024 15:12:21 -0800

Patch series "mm/damon/core: fix memory leaks and ignored inputs from
damon_commit_ctx()".

Due to two bugs in damon_commit_targets() and damon_commit_schemes(),
which are called from damon_commit_ctx(), some user inputs can be ignored,
and some mmeory objects can be leaked.  Fix those.

Note that only DAMON sysfs interface users are affected.  Other DAMON core
API user modules that more focused more on simple and dedicated production
usages, including DAMON_RECLAIM and DAMON_LRU_SORT are not using the buggy
function in the way, so not affected.


This patch (of 2):

When new DAMON targets are added via damon_commit_targets(), the newly
created targets are not deallocated when updating the internal data
(damon_commit_target()) is failed.  Worse yet, even if the setup is
successfully done, the new target is not linked to the context.  Hence,
the new targets are always leaked regardless of the internal data setup
failure.  Fix the leaks.

Link: https://lkml.kernel.org/r/20241222231222.85060-2-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets
+++ a/mm/damon/core.c
@@ -961,8 +961,11 @@ static int damon_commit_targets(
 			return -ENOMEM;
 		err = damon_commit_target(new_target, false,
 				src_target, damon_target_has_pid(src));
-		if (err)
+		if (err) {
+			damon_destroy_target(new_target);
 			return err;
+		}
+		damon_add_target(dst, new_target);
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch
mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch
samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch

