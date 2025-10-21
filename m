Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6500D34D929
	for <mm-commits@vger.kernel.org>; Tue, 21 Oct 2025 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761071774; cv=none; b=Q6Vmog7FxNeVBIpNBigCI0coIJKmpWjY8XwKHuOhYloEbCNdyRtHnAYyP4Cr7m9s96IUC1ZaFj3Y3WIUgeIIwpxeMVKeKJJb6aZCjh0Vq8bCvy2MfiHGOetuhlvbPSYxyIbZe8tPZ8lW+4ipMtPUBgc/jpkZrNaopMnjrOVCJ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761071774; c=relaxed/simple;
	bh=0gXOOC6XhcI9upjRvm/Ul/vHFM0cr1PLY7XSUV3phsA=;
	h=Date:To:From:Subject:Message-Id; b=syD7xueKg6PHszOtvJCAtJTm/nVewlO++AYpCB/u5xsc8Syvpg/INoHHpWLeFz7YOurVZr3t+SH4mBXMSuGWRZbGgLa87aWc3seF2g2+/ZeG4M1kOootFXJHEH8FJRH+B3cAWBcfyy00ldTq8Il5d+OgTzjJpSBp0ImgjFSB+go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Dr9Wdwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Dr9Wdwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A6DC4CEF7;
	Tue, 21 Oct 2025 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761071773;
	bh=0gXOOC6XhcI9upjRvm/Ul/vHFM0cr1PLY7XSUV3phsA=;
	h=Date:To:From:Subject:From;
	b=0Dr9Wdwza8wTTAOrkYjU2MO5mTXEfebWKVxsAaL+xLXpQxwOAtyoYLQsuIxy/4pNS
	 g1Jqo4MxqxSZotgT4atAyOMZGo1VH5P7T5zt/03opp48rnjcmj0/cmKaaLaGANrLLY
	 6rNiwUYOTdg4nGIbbJ3VABC6DVQDERCXr0WUB6po=
Date: Tue, 21 Oct 2025 11:36:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david.hunter.linux@gmail.com,swarajgaikwad1925@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch added to mm-new branch
Message-Id: <20251021183613.C4A6DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove misleading todo comment in nid_show()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: mm/damon/sysfs: remove misleading todo comment in nid_show()
Date: Tue, 21 Oct 2025 21:53:24 +0000

The TODO comment in nid_show() suggested returning an error if the goal
was not using nid.  However, this comment was found to be inaccurate and
misleading.This patch removes the TODO comment without changing any
existing behavior.

This change follows feedback from SJ who pointed out [1] that wiring-order
independence is expected and the function should simply show the last set
value.  and [2] checkpatch.pl complain about number of chars per line

No functional code changes were made.

Tested with KUnit:
- Built kernel with KUnit and DAMON sysfs tests enabled.
- Executed KUnit tests:
  ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests/
- All 25 tests passed, including damon_sysfs_test_add_targets.

Link: https://lkml.kernel.org/r/20251021215323.29734-2-swarajgaikwad1925@gmail.com
Link: https://lore.kernel.org/lkml/20251020151315.66260-1-sj@kernel.org/ [1]
Link: https://lore.kernel.org/lkml/20251021010847.68473-1-sj@kernel.org/ [2]
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show
+++ a/mm/damon/sysfs-schemes.c
@@ -1121,7 +1121,6 @@ static ssize_t nid_show(struct kobject *
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);
 
-	/* todo: return error if the goal is not using nid */
 
 	return sysfs_emit(buf, "%d\n", goal->nid);
 }
_

Patches currently in -mm which might be from swarajgaikwad1925@gmail.com are

mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch

