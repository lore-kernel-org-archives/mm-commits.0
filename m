Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCB346BF
	for <mm-commits@vger.kernel.org>; Mon, 29 Sep 2025 22:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759186570; cv=none; b=F8T1xrWfTReQs3MOgv9jUQxXLabPEKGYi7Vr2Er1el0oQHh2MgjlwD1kbsVZtMgOoN4/nYBslX6pIY5u9ciga47jfwypFxGKwHNmdHV6Om/ZUuonKnz294klw71TnbHzWnwf5RXSFPZcVVgPsqFg1dls2wzHAuhZ8QK628ytTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759186570; c=relaxed/simple;
	bh=MkU1GNLFzRaNiLKg6/XEBSy6ZFnmnoMhacKYovODeQQ=;
	h=Date:To:From:Subject:Message-Id; b=XFgeMshB4+HXHkqovWkJavunVz/tTynevHBlQejPnN4ZNVi2s3gdtbcaEkOpSvOEF5W1EM567yFwYYCOWScZmIieRZET2Xgjj2LDc7EfKdw0G7oDEmsCtNcpt81U36CLYVAA/kkNut8Swir9xAjqMEYzq1KZdL5kjyqouX7BwTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ks9Z0hTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ks9Z0hTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E46C4CEF4;
	Mon, 29 Sep 2025 22:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759186569;
	bh=MkU1GNLFzRaNiLKg6/XEBSy6ZFnmnoMhacKYovODeQQ=;
	h=Date:To:From:Subject:From;
	b=Ks9Z0hToNqtwecIg40dj5BG4stzdDEWuRzywpNAQTUzTSCZmPX9SG0FuRDXnPehZh
	 ZACHUlrvFxuWD4f091tUTry2gdajFMQIw+Tiux/7Ok8UHxsct4M7WLqxuLd8fnusbE
	 55yKkPUSmri/kHMOtJRwPsXucxcZj+g9BpWvDNMQ=
Date: Mon, 29 Sep 2025 15:56:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,weibu@redadmin.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-correct-typo-directores.patch added to mm-new branch
Message-Id: <20250929225609.25E46C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: admin-guide/mm/damon: correct typo "directores"
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-correct-typo-directores.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-correct-typo-directores.patch

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
From: Akiyoshi Kurita <weibu@redadmin.org>
Subject: docs: admin-guide/mm/damon: correct typo "directores"
Date: Sun, 28 Sep 2025 15:46:51 +0900

The word "directores" is a typo in usage.rst.  Correct it to "directories"
to improve documentation clarity.

Link: https://lkml.kernel.org/r/20250928064651.281325-1-weibu@redadmin.org
Signed-off-by: Akiyoshi Kurita <weibu@redadmin.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-correct-typo-directores
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -360,7 +360,7 @@ The directory for the :ref:`quotas <damo
 DAMON-based operation scheme.
 
 Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directores (``weights`` and
+``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
 ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
_

Patches currently in -mm which might be from weibu@redadmin.org are

docs-admin-guide-mm-damon-correct-typo-directores.patch

