Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB44D20ED
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 00:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722214561; cv=none; b=urQljPQyR87lsRCvBVb5Dyq7dYGazrv9kmhY0y28N0VAd/DP761MCJnHHg6NgUJB5VbAXCWFFxB+rQjg5zimipIEneWZDZPGzhgh8CjuSzY9WvIDW+9db9HBk9kUWvSSiXhvdi5vgkTjwz6HByOaMoIjplsDIe0cMhsJuo/hGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722214561; c=relaxed/simple;
	bh=ggIsESRDF8KDpDxPGglWdCRKJBT5Q3MmPTXphfFxXvE=;
	h=Date:To:From:Subject:Message-Id; b=LkegSwTrRMF1R6Y7ME2sCYF7g8w/ACKcWePZbXTHYnpx+eFRvXqVKG0DkoQOPGXkIF63P+A4OLdlcViG5Bf+8NJ6mnG21/haE08pWfsNp5L2blx0OY23WREsSL7cAOaBK05X/teDfoH7k/mJR7zjnaTWYTi19V2MxsJ39p35JQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bvqYhxYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bvqYhxYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A08AC116B1;
	Mon, 29 Jul 2024 00:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722214561;
	bh=ggIsESRDF8KDpDxPGglWdCRKJBT5Q3MmPTXphfFxXvE=;
	h=Date:To:From:Subject:From;
	b=bvqYhxYDX9daCxiDj/C6bLS7+MJ1jIpT06TBcvX/u8UAorMsOtOqBVN9R5Vj7Us7I
	 xMaroF2Ys0R9TDZfFEiPT01pmqZJTprSea0XLsrUBhll7uTwZ0l+6OGCgWNqiU0a0Z
	 +SDNi6ZOmEEgtf9AEzkw4PKOUB7Lj2u3sLCXQX6U=
Date: Sun, 28 Jul 2024 17:56:00 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch added to mm-unstable branch
Message-Id: <20240729005601.1A08AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: test_hmm: use min() to improve dmirror_exclusive()
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch

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
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: lib: test_hmm: use min() to improve dmirror_exclusive()
Date: Fri, 26 Jul 2024 15:12:46 +0200

Use min() to simplify the dmirror_exclusive() function and improve its
readability.

Link: https://lkml.kernel.org/r/20240726131245.161695-1-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-use-min-to-improve-dmirror_exclusive
+++ a/lib/test_hmm.c
@@ -799,10 +799,7 @@ static int dmirror_exclusive(struct dmir
 		unsigned long mapped = 0;
 		int i;
 
-		if (end < addr + (ARRAY_SIZE(pages) << PAGE_SHIFT))
-			next = end;
-		else
-			next = addr + (ARRAY_SIZE(pages) << PAGE_SHIFT);
+		next = min(end, addr + (ARRAY_SIZE(pages) << PAGE_SHIFT));
 
 		ret = make_device_exclusive_range(mm, addr, next, pages, NULL);
 		/*
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are

lib-test_hmm-use-min-to-improve-dmirror_exclusive.patch
lib-checksum-use-array_size-to-improve-assert_setup_correct.patch

