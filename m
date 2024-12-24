Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94391A95E;
	Tue, 24 Dec 2024 01:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735002553; cv=none; b=OO6JOMDQPPyR/3ookofEMtEZi2ykvcV0cJSncgofzd7IXF+wPMiz63YSUg97yJZzPhEskfs+pmtDgmtro3ItX9OLDw82tK3r75Zbgqo6oc43ZrjOFqku9UrkFHPmoA4fBVsYOKDJB+6Yj3rKIG2pk4KMiwKRNM+ckx2QQzV4Yi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735002553; c=relaxed/simple;
	bh=4rDVZHD3AVDNcoO8R/b1XAopoXmn5s+omf3WqGDMjz0=;
	h=Date:To:From:Subject:Message-Id; b=BRUsd0XvDb9DI5ZarTXLopY3Nxn7OfQJdXaXx0FVDHGBncm6ZptO2i5u0eMNCsK+VwxERDyL5PjgdscSBg6EFjE+oiO7roAdlsewC6Ez0UHlLSTbsmgVOiXuMyozneIaXs5u+jmM5cXjJAGaGZ0NOqvHP7vVWUQz/sKgi157q1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yIgKyyui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yIgKyyui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0457DC4CED3;
	Tue, 24 Dec 2024 01:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735002553;
	bh=4rDVZHD3AVDNcoO8R/b1XAopoXmn5s+omf3WqGDMjz0=;
	h=Date:To:From:Subject:From;
	b=yIgKyyuivzmN3yyqQ3jWpAgeH9v1FwpkJoAXpeaabzsDis+CGLVkbTPeyXWnYCRMi
	 ZqfrgVMnhlj+XXQWoiJe5Uaevj8bE28+je83uHARMppYa4QG8HsneLSLoSjUKcu/4w
	 KChbR4/vl4NJX/1mOQFK7thXSIFq9JTwjWidwKik=
Date: Mon, 23 Dec 2024 17:09:12 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch added to mm-hotfixes-unstable branch
Message-Id: <20241224010913.0457DC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix ignored quota goals and filters of newly committed schemes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch

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
Subject: mm/damon/core: fix ignored quota goals and filters of newly committed schemes
Date: Sun, 22 Dec 2024 15:12:22 -0800

damon_commit_schemes() ignores quota goals and filters of the newly
committed schemes.  This makes users confused about the behaviors. 
Correctly handle those inputs.

Link: https://lkml.kernel.org/r/20241222231222.85060-3-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes
+++ a/mm/damon/core.c
@@ -868,6 +868,11 @@ static int damon_commit_schemes(struct d
 				NUMA_NO_NODE);
 		if (!new_scheme)
 			return -ENOMEM;
+		err = damos_commit(new_scheme, src_scheme);
+		if (err) {
+			damon_destroy_scheme(new_scheme);
+			return err;
+		}
 		damon_add_scheme(dst, new_scheme);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-fix-new-damon_target-objects-leaks-on-damon_commit_targets.patch
mm-damon-core-fix-ignored-quota-goals-and-filters-of-newly-committed-schemes.patch
samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch

