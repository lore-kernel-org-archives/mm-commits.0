Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A5427CB35
	for <mm-commits@vger.kernel.org>; Thu, 16 Apr 2026 05:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776318578; cv=none; b=loqGExaePRUOuhicGhqVn0o8Qh/UFb2FGfUEOULpxBDwnvijqNe1KclqWqWGnptTR0wKh6uh/zLT54b+gdEoHF161fYrYLzCU+QLx90x9LrvCmk0M/ufXAAHTjV0ExkWqVoH9/HCtj0MhBGb5490rim6eWbegJeVdeRqOR8YdqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776318578; c=relaxed/simple;
	bh=AxfshaDb15T397m+3TMtaaAADpU4CoDBbXXiD2EeETg=;
	h=Date:To:From:Subject:Message-Id; b=XYm+Csr01npiQepVBj2vIIxqgf4LIgqHDtG0ivEEIKtTASZ1nlZpFxOI/T79CANz9VV8CxZepH8FiBWJx+lROP9PLNddLK0HpaLyMRBN0mn1yyj/bGWlhi6RpHb6WIeCi4Ej/YUFDPcQJTPs8C1NYtLT9ZGg2fSINlC7HSlF0bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N3DABEIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N3DABEIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8DAC2BCAF;
	Thu, 16 Apr 2026 05:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776318578;
	bh=AxfshaDb15T397m+3TMtaaAADpU4CoDBbXXiD2EeETg=;
	h=Date:To:From:Subject:From;
	b=N3DABEIb8q/Kx691bO/PxEfziz5vZGoNpsunsdGstvS1CsdRec/oxP4CmTzpaxhIT
	 DjvyoUmV/50cSGA/uH1L9Z/yPwUmeIXdRDRlqCcGiTCZr+7nyMmc1WhNavRFXo91LJ
	 np/f08Yk3c4F1+FxB3g93San04Bxae3SIJiw4cOw=
Date: Wed, 15 Apr 2026 22:49:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,jack@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-page-cache-reviewer.patch added to mm-unstable branch
Message-Id: <20260416054937.9B8DAC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add page cache reviewer
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-page-cache-reviewer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-page-cache-reviewer.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Jan Kara <jack@suse.cz>
Subject: MAINTAINERS: add page cache reviewer
Date: Wed, 15 Apr 2026 19:40:40 +0200

Add myself as a page cache reviewer since I tend to review changes in
these areas anyway.

Link: https://lkml.kernel.org/r/20260415174039.13016-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-page-cache-reviewer
+++ a/MAINTAINERS
@@ -19964,6 +19964,7 @@ F:	kernel/padata.c
 
 PAGE CACHE
 M:	Matthew Wilcox (Oracle) <willy@infradead.org>
+R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
 T:	git git://git.infradead.org/users/willy/pagecache.git
_

Patches currently in -mm which might be from jack@suse.cz are

maintainers-add-page-cache-reviewer.patch

