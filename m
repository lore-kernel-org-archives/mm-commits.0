Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B0C2FD69E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 18:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782757615; cv=none; b=T6PSbq8AcZ3fjqciNVzJKsUtZXF4taoUbjxJ2lIJgWfj9muCSXOt+UQcI3yraJNBaMxaHkxmaem3Rktx61ZyKAmjaeUbWVHjZ27w/EUNE2oAAZuXKrV0+Cv+CwVLIiDVjZiotqlKNABPwnWc76OGb+ivY7KkKsH2+LqD58KXGzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782757615; c=relaxed/simple;
	bh=OSLpneBUDQzNAUqbRUZv0rcEDxC6W1in7KMqAW08yoU=;
	h=Date:To:From:Subject:Message-Id; b=lHu01BXC40+JboW+BSTgSA58g+28pvM2bNxEOoYFy4dKIRWi/AD/DYoZWduIj82ddmjoxZ00MkpJBanBWOs6miAi1jj7fCQLjUGfG36QvL+43uOPkx8dDA6I2+dX6JKgqTuZdE/lj+mPPstVCupKGItvU0cwVRnY23befA7kjVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P149yxkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P149yxkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FCD1F000E9;
	Mon, 29 Jun 2026 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782757612;
	bh=fJArxIdccEDZITU78uIRgFPeV6JKmUBLOhl8CExut7M=;
	h=Date:To:From:Subject;
	b=P149yxkDvg0KgOC02Y6L2a5X+XuP+OqZzqiJNOjnAu23ij59Ct/BF2dnPny8xttF8
	 ulTXdVb33zNWQMGge+Q/urJVxy4KaA68AKL8XpJ2UeOhwlOuXfiwAMFMziIA3jb7Z9
	 8VG4UOBEuBgLXFcPWNMuBFB9AccDpfQQhPecIuow=
Date: Mon, 29 Jun 2026 11:26:52 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kkernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,doehyunbaek@gmail.com,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,akinobu.mita@gmail.com,plafer@proton.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch added to mm-new branch
Message-Id: <20260629182652.D3FCD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch

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
From: Philippe Laferriere <plafer@proton.me>
Subject: mm/damon/stat: use secs_to_jiffies() instead of msecs_to_jiffies()
Date: Mon, 29 Jun 2026 07:55:33 -0700

The conversion of a duration expressed in seconds reads as
msecs_to_jiffies(5 * MSEC_PER_SEC), which obscures the intent and
needlessly goes through milliseconds.  Use the dedicated secs_to_jiffies()
helper, which expresses the 5-second refresh interval directly.  No
functional change.

Found using Coccinelle (scripts/coccinelle/misc/secs_to_jiffies.cocci).

Link: https://lore.kernel.org/20260629145538.134832-3-sj@kernel.org
Signed-off-by: Philippe Laferriere <plafer@proton.me>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: SJ Park <sj@kkernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies
+++ a/mm/damon/stat.c
@@ -138,7 +138,7 @@ static int damon_stat_damon_call_fn(void
 
 	/* avoid unnecessarily frequent stat update */
 	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
-				msecs_to_jiffies(5 * MSEC_PER_SEC)))
+				secs_to_jiffies(5)))
 		return 0;
 	damon_stat_last_refresh_jiffies = jiffies;
 
_

Patches currently in -mm which might be from plafer@proton.me are

mm-damon-stat-use-secs_to_jiffies-instead-of-msecs_to_jiffies.patch

