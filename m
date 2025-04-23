Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF940139566
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 22:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745448549; cv=none; b=r0IxNHzGPrUuyHd6RWzsEyq5dSouBDqrwDoIbVusABwUJ+/YuV8uvGNVJffNud7CrHKIKBDRU7EqTgQXeQPIkEnIupbj4RpPMlxcdaA4l51888mbxlC3hxqZVdrrecjwRw0Dj6Vg6PXElTHqRGaIOTM4Pnj1FQmNnZMX4+7j90s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745448549; c=relaxed/simple;
	bh=LKX1BQcFU6Wnup5bVFtEs4tsufqll3XNzZOqavTyvkE=;
	h=Date:To:From:Subject:Message-Id; b=geXfJZYHm5H+u3HlqfJEi5qX0Ppo2IEfA4Ul6RVI3Ctnp8h2K27Rc/jxQmRtTFQ51FHnO3sD4z5wtlnA5Ts6J729h0wd0WMZhI67movAgtx4+T+ot3Jq5YYpewhDDkeeqCQz4JzfQK9qgxkW7prpDdwXd4jFPcXRbgmvaJrlgQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qu3pEK58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qu3pEK58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8AC4CEE2;
	Wed, 23 Apr 2025 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745448548;
	bh=LKX1BQcFU6Wnup5bVFtEs4tsufqll3XNzZOqavTyvkE=;
	h=Date:To:From:Subject:From;
	b=Qu3pEK58U7cPXeKTqBSyE8s9OXSmakzF13+FYwA0dsSqRXOXT+vZFRGaUcLBYkMH0
	 +oo8SeEoPolELCPuqI4nwG6IqfIvH9mjEUir0IGwDHdTqMBJQhDeYrjKuabL8MrCEm
	 h4v7tvrGRd7M4p/booRSPU7hCBvfD2nnPkNfMVhA=
Date: Wed, 23 Apr 2025 15:49:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch added to mm-new branch
Message-Id: <20250423224908.54D8AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch

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
From: Su Hui <suhui@nfschina.com>
Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
Date: Mon, 21 Apr 2025 14:24:24 +0800

It's safer to use kmalloc_array() and size_add() because it can prevent
possible overflow problem.

Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
Signed-off-by: Su Hui <suhui@nfschina.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add
+++ a/mm/damon/sysfs-schemes.c
@@ -465,7 +465,8 @@ static ssize_t memcg_path_store(struct k
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	char *path = kmalloc(sizeof(*path) * (count + 1), GFP_KERNEL);
+	char *path = kmalloc_array(size_add(count, 1), sizeof(*path),
+				   GFP_KERNEL);
 
 	if (!path)
 		return -ENOMEM;
@@ -2064,7 +2065,7 @@ static int damon_sysfs_memcg_path_to_id(
 	if (!memcg_path)
 		return -EINVAL;
 
-	path = kmalloc(sizeof(*path) * PATH_MAX, GFP_KERNEL);
+	path = kmalloc_array(PATH_MAX, sizeof(*path), GFP_KERNEL);
 	if (!path)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from suhui@nfschina.com are

mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch

