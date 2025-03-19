Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E569E552
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742350474; cv=none; b=I1vmpRizsD0E8oL0yG7z81n90QrT2Iz4luC4ejGF5OutNOlcKXKKZFRuRIUsjVxosk3Rf67n6uwHhUZFCWzUl4jkwbO8aDxS3k8dbShKvUun6LmHB0zpXIM4O8mTMfg650vybcA2iLyQFKtnQ7sT75+pyl5TMaFCbcOUn4xzaXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742350474; c=relaxed/simple;
	bh=CTxCxpI0L7ZDeixYHUPddq5OgaYeTkX2apUq4Zvw8qc=;
	h=Date:To:From:Subject:Message-Id; b=C0sP055XLGI1RW4dlsMMmYQh6UcHD5veCSj8Z9neuDNHaisLf5Q1+q2WmJpnNp1S3JxReH6tK9R8Cr6/QzIW9WCUIlHPrYUDuZiZdJc05v+2oLWSCt1hmN6KvLoOG4cijovU3NjKEiG8LxVkMCYNdhAycrtb7yEO5cUcFBBCahI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BAWZrzwZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BAWZrzwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA8C4CEDD;
	Wed, 19 Mar 2025 02:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742350474;
	bh=CTxCxpI0L7ZDeixYHUPddq5OgaYeTkX2apUq4Zvw8qc=;
	h=Date:To:From:Subject:From;
	b=BAWZrzwZaZZPeqGW2MxCWMZrO3q9okhUiZkbdxgMiojakCKkriszNsBCsj5HyrR8K
	 gLw6tAUPHjwtsRip5rWbiJhRc9CjXGkBj13vJjQtcDFt9VZR2L9UbtGA1bLGNDmcxg
	 cDE4kGmZKNCjOD78H2X/ID996KN9xFJhasKZvsw4=
Date: Tue, 18 Mar 2025 19:14:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,nphamcs@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-active-damos-filter-type.patch added to mm-unstable branch
Message-Id: <20250319021433.DFCA8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs/mm/damon/design: document active DAMOS filter type
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-active-damos-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-active-damos-filter-type.patch

This patch will later appear in the mm-unstable branch at
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
From: Nhat Pham <nphamcs@gmail.com>
Subject: docs/mm/damon/design: document active DAMOS filter type
Date: Tue, 18 Mar 2025 11:30:29 -0700

Document availability and meaning of "active" DAMOS filter type on design
document.  Since introduction of the type requires no additional user ABI,
usage and ABI document need no update.

Link: https://lkml.kernel.org/r/20250318183029.2062917-3-nphamcs@gmail.com
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-active-damos-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -656,6 +656,8 @@ Below ``type`` of filters are currently
 - Operations layer handled, supported by only ``paddr`` operations set.
     - anon
         - Applied to pages that containing data that not stored in files.
+    - active
+        - Applied to active pages.
     - memcg
         - Applied to pages that belonging to a given cgroup.
     - young
_

Patches currently in -mm which might be from nphamcs@gmail.com are

mm-damon-implement-a-new-damos-filter-type-for-active-pages.patch
docs-mm-damon-design-document-active-damos-filter-type.patch

