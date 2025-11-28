Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C12C3277
	for <mm-commits@vger.kernel.org>; Fri, 28 Nov 2025 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355818; cv=none; b=n9ZCQphtsxGcFFp1S/OwSq9bBby9o+DtQW5f5NuNorLXnvlIo3934rUWOOIaen0MaemcFR/ORx0AW/dTmV2ujc+pQp2oyBzuYRGD0+4x2VJzByF1FvC2iQLtqJUMijAej4oWyiRwa7pxfiMvKd+IELRyXTJNVH8hWPyCDkIUfWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355818; c=relaxed/simple;
	bh=xhCmKLkteQD15NVvTjdiIeorkvCPIFeijSbntorpsms=;
	h=Date:To:From:Subject:Message-Id; b=LNq41oAbnxY7E1WlOuxeOiTfGzTv9CiHqFKC5teBTZoVbpzGjMTOmXhWDHYVWcVuLKUkTr6hhgbn2wSjnUe92DtfexiSorO5mb76EJgSdeij+txp2JifoBvzXKLto3hw+bMEjDe2jezAkzZ3kED3pOYPLzh961cDPJoCyPdCZ1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2aQKQWEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2aQKQWEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E62C4CEF1;
	Fri, 28 Nov 2025 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764355816;
	bh=xhCmKLkteQD15NVvTjdiIeorkvCPIFeijSbntorpsms=;
	h=Date:To:From:Subject:From;
	b=2aQKQWEg6u2u+tIS9zd+cey9ZHZKy1uURf+bY48httijx7yzAebShBo45XEqgl+yR
	 7ibbE0cQir3WXxFHUjq3a+46l6UgGsobLSIXjgg13jWt2MKs5J7TBUER6/rxaJz7c3
	 ckkYrEZENP0m4fB3ldxVeAqdQED0CfHEFWUByg7o=
Date: Fri, 28 Nov 2025 10:50:15 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-dont-use-invalid-list-iterator.patch added to mm-nonmm-unstable branch
Message-Id: <20251128185016.47E62C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_file: don't use invalid list iterator
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_file-dont-use-invalid-list-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-dont-use-invalid-list-iterator.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: liveupdate: luo_file: don't use invalid list iterator
Date: Fri, 28 Nov 2025 10:17:07 +0300

If we exit a list_for_each_entry() without hitting a break then the list
iterator points to an offset from the list_head.  It's a non-NULL but
invalid pointer and dereferencing it isn't allowed.

Introduce a new "found" variable to test instead.

Link: https://lkml.kernel.org/r/aSlMc4SS09Re4_xn@stanley.mountain
Fixes: 3ee1d673194e ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202511280420.y9O4fyhX-lkp@intel.com/
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-dont-use-invalid-list-iterator
+++ a/kernel/liveupdate/luo_file.c
@@ -561,17 +561,20 @@ int luo_retrieve_file(struct luo_file_se
 {
 	struct liveupdate_file_op_args args = {0};
 	struct luo_file *luo_file;
+	bool found = false;
 	int err;
 
 	if (list_empty(&file_set->files_list))
 		return -ENOENT;
 
 	list_for_each_entry(luo_file, &file_set->files_list, list) {
-		if (luo_file->token == token)
+		if (luo_file->token == token) {
+			found = true;
 			break;
+		}
 	}
 
-	if (luo_file->token != token)
+	if (!found)
 		return -ENOENT;
 
 	guard(mutex)(&luo_file->mutex);
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

liveupdate-luo_file-dont-use-invalid-list-iterator.patch

