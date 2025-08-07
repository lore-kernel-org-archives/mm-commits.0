Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F231DE4C9
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754537684; cv=none; b=boSPdy1YVADw2+074RlwzE1YWE6H6LnfrYg0cO6NezzaamA8lyHgt6tbJP4nemutH9FmBGw2mj+IhIwGHZNjpneJ6aRUOMGuEQIbosFFwmBjCmZX38+SB0LHlnBaC1rvTtYcKJt255fqORoQ5xIYb/VFHsv2xL35iiMNi9/n48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754537684; c=relaxed/simple;
	bh=q3UnnwqXF/JSN/mioZiuxqab3OP/ZuQ3X3PZNb9dYHo=;
	h=Date:To:From:Subject:Message-Id; b=RtG4J276UUyZ7d7WMGb7cpUn9GroU4ZHga1fwWUrMLL038sDU2f6g838Dl3dIRqn9JzyfIYByH80Zw/GYowKvraErALEUQPU+OKn5DiijwFdY/Bg5yP+LAqMMuuesfKNdfyV4+HuQyUzYtfZwwqTSBb15rmSoSugCLGF4SFYcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=idcVtcq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="idcVtcq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD30FC4CEEB;
	Thu,  7 Aug 2025 03:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754537683;
	bh=q3UnnwqXF/JSN/mioZiuxqab3OP/ZuQ3X3PZNb9dYHo=;
	h=Date:To:From:Subject:From;
	b=idcVtcq49w7Qh0T/0rDUv4bZXQfayIYFUQ9ZhbzYt+rJ7s59QecndUYqJTzKKHQZw
	 w0g7VUs3svLqm81na4SpJ89u0QBbSd/OgTVtah6p0US5jKPcQsN5eYnRbv25qOO3QV
	 S8hH6wTuLCGBgLjCcj+ifCaO+gQ6ejjD++NBtrl4=
Date: Wed, 06 Aug 2025 20:34:43 -0700
To: mm-commits@vger.kernel.org,bijantabatab@micron.com,bijan311@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch added to mm-new branch
Message-Id: <20250807033443.BD30FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
Date: Wed Aug  6 08:32:40 PM PDT 2025

fix whitespace, per SeongJae

Link: https://lkml.kernel.org/r/20250807001924.76275-1-sj@kernel.org
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: Bijan Tabatabai <bijantabatab@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
+++ a/mm/damon/core.c
@@ -585,7 +585,6 @@ static bool damon_attrs_equals(const str
 		ig1->aggrs == ig2->aggrs &&
 		ig1->min_sample_us == ig2->min_sample_us &&
 		ig1->max_sample_us == ig2->max_sample_us;
-
 }
 
 static unsigned int damon_age_for_new_attrs(unsigned int age,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch

