Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3A0380FDF
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755618; cv=none; b=cj1+GGAmOTbwyrg6Wm5Gs1gM0Wm7beUyP64MGtwmE+ssKlt28oY9RZtrGQw5pXcrfEuVl1Sj5DfMG0c2PIUqaeKiPz1mJrL5xSRWDHyDM1ppIFhaozXSKHHlR9Hc/nIHk1x5QRwAEkoonycQBl9iUqrvVhXKi80qclH5TCrStdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755618; c=relaxed/simple;
	bh=lpq0mllg35fwQdfunK/39nszGXNmblKaADI6o+SGVBM=;
	h=Date:To:From:Subject:Message-Id; b=RX6ML9DHTmhvJI7NFsjQz6PC4D9WhGkprdyDfPPwGdaOiPLrawvhUU+8p1tJGAVF/6ViRk1jD8uNPVhW+TBCwSEXR8orFzD+XNNR16Vb4yrVdzihiK/OAOd0DOx3UdUYIXm8CnOfPR+/0fGSNOaJsrOJThmOdPNtcp0rXYSCdvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ShVwXoQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ShVwXoQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298821F000E9;
	Mon, 29 Jun 2026 17:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782755617;
	bh=aQwq5YaEEYaKnJd9wiVDEI7tuCs3T0v+avbEukD5Dvc=;
	h=Date:To:From:Subject;
	b=ShVwXoQMsa24J16VtQCRQPYkC41JilqVqwDpEsIOj0X/kUy1jv6SKDrWWOSpWPSmB
	 rhgnBzAgHsWC4QyyaJk+u0fLhhwFhey1JB4KiPMvcTf6sE22A++KmmsxNiOU3r4XAC
	 RpoNOSbElvjWFRJCUwYKsspFnj7x80aGxO/Ej4Rs=
Date: Mon, 29 Jun 2026 10:53:36 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,niecheng1@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch added to mm-new branch
Message-Id: <20260629175337.298821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs.py: fix memcg_path assignment
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch

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
From: Cheng Nie <niecheng1@uniontech.com>
Subject: selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon, 29 Jun 2026 07:48:10 -0700

Patch series "selftests/damon: fix memcg_path staging handling", v5.

Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and add
a test case of it in sysfs.py.


This patch (of 2):

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.  This
makes memcg filter staging and follow-up validation use the written path
correctly.

Link: https://lore.kernel.org/20260629144812.134159-1-sj@kernel.org
Link: https://lore.kernel.org/464AE12D4BC6B6F4+20260601090519.240482-1-niecheng1@uniontech.com
Link: https://lore.kernel.org/20260629144812.134159-2-sj@kernel.org
Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfspy-fix-memcg_path-assignment
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
_

Patches currently in -mm which might be from niecheng1@uniontech.com are

selftests-damon-_damon_sysfspy-fix-memcg_path-assignment.patch
selftests-damon-sysfspy-validate-memcg_path-staging-readback.patch

