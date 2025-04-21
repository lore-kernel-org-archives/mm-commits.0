Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAFF1EEA49
	for <mm-commits@vger.kernel.org>; Mon, 21 Apr 2025 19:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745263046; cv=none; b=ro+Gu6E8xmPgBcNTxBlIIylQzb5afCpxiqOnInuyofwDRu4WVgUPMz6a5KbhLRjnLMG0LUvPAi6w3fxeaRy9U5zF4cbOO1lPKy6yuEiCLggOCcCpFJ48FnyYaYtqfY/92syHdfLlHtZBcl2gNsbjyF9VJik4cLkKorVcxV4cWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745263046; c=relaxed/simple;
	bh=LKX1BQcFU6Wnup5bVFtEs4tsufqll3XNzZOqavTyvkE=;
	h=Date:To:From:Subject:Message-Id; b=dk3a7psM2qtGEdMp1c4smwVdI/f5sqqX2UxwKyUsWbzWEBEusByT+QZdQJ3ZEsR32dcnO+q0/F0RY4Zkr69d7kCs9XZOS2gsk0RDC++M1sGec2gfZ0NauoJmV+WjFjVPzLNqA3eIasifPHRN5BpU4MgYmM30k2NpXjr31wiJW2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2XIEmr1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2XIEmr1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F63C4CEE4;
	Mon, 21 Apr 2025 19:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745263045;
	bh=LKX1BQcFU6Wnup5bVFtEs4tsufqll3XNzZOqavTyvkE=;
	h=Date:To:From:Subject:From;
	b=2XIEmr1OoAFIs1PSDhflE77XocyrjFvu2YCHVryNTGH/MlU8cpe0OFUIrKmVqsp+m
	 r7Hc8S8BleBWvw9ZDLIjLearC8J2s5At5xqeeqhDBrJb+ysnNnRLnZ6HNwfMRNmngq
	 ecL/0cL/tIM4HOQXGo/50ho0nZv4qNXj4yQPEkQ8=
Date: Mon, 21 Apr 2025 12:17:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,suhui@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch added to mm-new branch
Message-Id: <20250421191725.56F63C4CEE4@smtp.kernel.org>
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

