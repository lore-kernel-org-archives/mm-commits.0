Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7123120DD52
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 03:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765854457; cv=none; b=OkNNB0jc3ZnDESuswPCDuN3lEdIwFHItUbTImTm3ErqNTS80KlCgSTYWQ/WIwPCc8o6ubCtw7iNpteqAorzLODtd6nLSeqJbTBIVmDiFEEINzICZbRYUE5ce2a4RxaQVingqHxmLFl9ERsR5UZBu4JGGB15+BdaIIF5MCNI0vNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765854457; c=relaxed/simple;
	bh=OfhLXtNugX3q/CYMZF2dBhPaki+jQbLyVUz+aI9g5rM=;
	h=Date:To:From:Subject:Message-Id; b=Mw1scfagPXKH62C9+eUCisWBGRwa4WlsuMR3fSQiYonMC8kd77CrGM+2dQuBD2Gi6omGBzsUCaHtoVHxddD47g4Wib6KD4fbiB80iVHw99LQtx6Yo5r9omRC9NjeF6PPt4ZhYfDLQ0zOAWGxOp7DD2flWs9hV6FhELVQcCVq6gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+K0M2BW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+K0M2BW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46F8C4CEF5;
	Tue, 16 Dec 2025 03:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765854456;
	bh=OfhLXtNugX3q/CYMZF2dBhPaki+jQbLyVUz+aI9g5rM=;
	h=Date:To:From:Subject:From;
	b=O+K0M2BWxPFy7iMXv3TvKM59M8qSSiV1mGAOaNLYgeQVlma1vB7lVgkGQcNMtaJwb
	 0K9tj70mQHhcujFVD0yyyA6VUZBDczCB/ilD8gF7Zf8zI85ZXJzpckCLM6kx10ZCGj
	 yM3fYep16ESY0GB35oSYoqx580+CnORqvl6MtdJ8=
Date: Mon, 15 Dec 2025 19:07:36 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,swarajgaikwad1925@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch added to mm-new branch
Message-Id: <20251216030736.D46F8C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: remove outdated TODO in target_nid_store()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch

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
Subject: mm/damon/sysfs-schemes: remove outdated TODO in target_nid_store()
Date: Thu, 11 Dec 2025 03:27:22 +0000

The TODO comment in target_nid_store() suggested adding range validation
for target_nid.  As discussed in [1], the current behavior of accepting
any integer value is intentional.  DAMON sysfs aims to remain flexible,
including supporting users who prepare node IDs before future NUMA hotplug
events.

Because this behavior matches the broader design philosophy of the DAMON
sysfs interface, the TODO comment is now misleading.  This patch removes
the comment without introducing any behavioral change.

No functional changes.

Link: https://lkml.kernel.org/r/20251211032722.4928-2-swarajgaikwad1925@gmail.com
Link: https://lore.kernel.org/lkml/20251210150930.57679-1-sj@kernel.org/ [1]
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store
+++ a/mm/damon/sysfs-schemes.c
@@ -2286,7 +2286,6 @@ static ssize_t target_nid_store(struct k
 			struct damon_sysfs_scheme, kobj);
 	int err = 0;
 
-	/* TODO: error handling for target_nid range. */
 	err = kstrtoint(buf, 0, &scheme->target_nid);
 
 	return err ? err : count;
_

Patches currently in -mm which might be from swarajgaikwad1925@gmail.com are

mm-damon-sysfs-schemes-remove-outdated-todo-in-target_nid_store.patch

