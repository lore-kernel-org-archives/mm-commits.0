Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D7E7604F
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942879; cv=none; b=cmv7jE+fTlLbFI2g0m8dTkYQNrGycq8bxC1RCNBI49EwnFaXcV7InTf35n+t+ThEMFNaEr+p464fw0HZ0xe7J5kEmrpsYWSdSnjdOhwBvihx1QKk+wkSxXnmsNVXIn7ofrPDcuzwOtKnHOMvtO4RD7LbeTZ8ns/DHmfXlCBo5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942879; c=relaxed/simple;
	bh=RAJGovtfUIQBXt+SJS1wP9Sg+EkRBc57A+9WUOyGOLk=;
	h=Date:To:From:Subject:Message-Id; b=n7beywUHS0Gh4lur0EALpRpSGlOiyCxvcSOZgS+ZBFxcBcHITw7XT6ES6BHNzu8Fc7vFSC9deo0x3FJNTLvPcMM0aZMIUoICZ1SBbwqFpDsRcUvX7dq6GhdntKd8SS548GuNNd+d45Hx2TSj8fVCItYwK6hBIkcUTVv5A7lAk2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JEwZ7Vl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JEwZ7Vl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE7AC116B1;
	Sun,  5 May 2024 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942879;
	bh=RAJGovtfUIQBXt+SJS1wP9Sg+EkRBc57A+9WUOyGOLk=;
	h=Date:To:From:Subject:From;
	b=JEwZ7Vl3MXMsQf7RtNpsRxjZqfM0g1p3VlwhBQlEe9PgrUIzZdFTfhGgL9WATfFG4
	 zHcc4NObXPL4Cj6+2X2syh3It4V7fwDn07U3XWYwjGj22UXPGoosGzOoEcDW6yxnwx
	 UGvQZiBAyt9UhCrLH5q1NXLrga9ep58V8VXe/ziQ=
Date: Sun, 05 May 2024 14:01:18 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch added to mm-unstable branch
Message-Id: <20240505210119.3BE7AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: initialize ->esz_bp from damos_quota_init_priv()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: initialize ->esz_bp from damos_quota_init_priv()
Date: Fri, 3 May 2024 11:03:09 -0700

Patch series "mm/damon: misc fixes and improvements".

Add miscelleneous and non-urgent fixes and improvements for DAMON code,
selftests, and documents.


This patch (of 10):

damos_quota_init_priv() function should initialize all private fields of
struct damos_quota.  However, it is not initializing ->esz_bp field.  This
could result in use of uninitialized variable from
damon_feed_loop_next_input() function.  There is no such issue at the
moment because every caller of the function is passing damos_quota object
that already having the field zero value.  But we cannot guarantee the
future, and the function is not doing what it is promising.  A bug is a
bug.  This fix is for preventing possible future issues.

Link: https://lkml.kernel.org/r/20240503180318.72798-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240503180318.72798-2-sj@kernel.org
Fixes: 9294a037c015 ("mm/damon/core: implement goal-oriented feedback-driven quota auto-tuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv
+++ a/mm/damon/core.c
@@ -346,6 +346,7 @@ static struct damos_quota *damos_quota_i
 	quota->charged_from = 0;
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
+	quota->esz_bp = 0;
 	return quota;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

