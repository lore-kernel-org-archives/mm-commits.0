Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBD4223311
	for <mm-commits@vger.kernel.org>; Mon, 18 Aug 2025 01:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755481890; cv=none; b=SdT2tJfWEDVBE1izJyzBwZWbi0hdwuWjtb5GXGkrPEEHxMKsWTz+1Fsg+iv/uxJC1Qk0NsGg4rDYpQS0epDPq/0XwhxSXJXM6PGoprOXGKz/NHVACnxvblFsWua6zuo2v5fNoh8qGpJ3IhsRCC+aqNea+tSJ5HfYh5PGLmWeGno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755481890; c=relaxed/simple;
	bh=ScNv7EY5KxUwGrVKVldx4TjtMaicVAX8X6GTsrUxPsw=;
	h=Date:To:From:Subject:Message-Id; b=N2lwkb1ZM6PBrTJHmhwm1OwwLgKTuSPuMiJkpTqYsVJBRrWM9+8nxRzqEUlbT0vlw2yTO3im/NjyxW+bRQMawMvbvcyn/DUSXakwsFCx4jdQqkIoesNIG/M5a1U4kPAokI68XkOu0VsNwWyze88QZeIUzSrXrULh0K7sF1XpmLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvlWk/LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvlWk/LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC3BC4CEF4;
	Mon, 18 Aug 2025 01:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755481890;
	bh=ScNv7EY5KxUwGrVKVldx4TjtMaicVAX8X6GTsrUxPsw=;
	h=Date:To:From:Subject:From;
	b=FvlWk/LH6a/jczaDo3AIb7Ng4whjFO4AvuhXxzjx2PNCQBuJWM0Phqxo8XvwuLbef
	 v5v/K+ATAXTLMCg80OxEwrq0NMRz0BJNRN1w72T8EQeW8ZQhKz+DNzPSLmIVFgE9pB
	 oKyIfWDWlT5sLtK0cPIxECQ6+n1ypsSLb9Cqemzc=
Date: Sun, 17 Aug 2025 18:51:29 -0700
To: mm-commits@vger.kernel.org,alexghiti@rivosinc.com,alex@ghiti.fr,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch added to mm-hotfixes-unstable branch
Message-Id: <20250818015130.1DC3BC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: put damos dests dir after removing its files
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch

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
Subject: mm/damon/sysfs-schemes: put damos dests dir after removing its files
Date: Sat, 16 Aug 2025 09:55:59 -0700

damon_sysfs_scheme_rm_dirs() puts dests directory kobject before removing
its internal files.  Sincee putting the kobject frees its container
struct, and the internal files removal accesses the container,
use-after-free happens.  Fix it by putting the reference _after_ removing
the files.

Link: https://lkml.kernel.org/r/20250816165559.2601-1-sj@kernel.org
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Alexandre Ghiti <alex@ghiti.fr>
Closes: https://lore.kernel.org/2d39a734-320d-4341-8f8a-4019eec2dbf2@ghiti.fr
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files
+++ a/mm/damon/sysfs-schemes.c
@@ -2158,8 +2158,8 @@ static void damon_sysfs_scheme_rm_dirs(s
 {
 	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
-	kobject_put(&scheme->dests->kobj);
 	damos_sysfs_dests_rm_dirs(scheme->dests);
+	kobject_put(&scheme->dests->kobj);
 	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	kobject_put(&scheme->watermarks->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-put-damos-dests-dir-after-removing-its-files.patch
mm-zswap-store-page_size-compression-failed-page-as-is.patch

