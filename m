Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0452701B8
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151393; cv=none; b=IlyplmeW1XKaCAumEd+qr8B4XNA9uDstrkUv8r7oP2kCCWok/YvypKoejr1Gh1rAb5YZmZbmVjAbALTrgkD+AsENGDdOolOHLJwohiye+U0+SPp+wzjRIiOeyqp0q1ggcMdC2O/1K2SQ6tItvc8ma9i7EhJNFB9UDZOb3H9mo0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151393; c=relaxed/simple;
	bh=+5xgrlDF+ghms9n8aDxIdH48Cn7rHfTbveWAh2pn5m8=;
	h=Date:To:From:Subject:Message-Id; b=Kfb8eaEZbRg8mNJEpZ7pSREYlLTjGHbtX/FWpABgK400qLIRs5vcM/PW2xBKQ6eg65rOszwTEsGc2FwKujRrTKHfmAVTUsqGX1VtJsJjjDFfY2DvInY9cD/W7RcFk/M4S60JL5t0K0iiLiKn6dL6z5jH+WFt2sIK0sONfsnXCLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=11HIuDfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="11HIuDfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B2CC2BCB7;
	Tue, 19 May 2026 00:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779151392;
	bh=+5xgrlDF+ghms9n8aDxIdH48Cn7rHfTbveWAh2pn5m8=;
	h=Date:To:From:Subject:From;
	b=11HIuDfl9zkS0U+28YMuLpgReqAiqMiPTOEuj1kbA9Z/Xx63iaGCpRv2qmeETPlFT
	 hrCXJvv5jSliJ5/FL5zPM78iEJRuUfibbH0KJI0JZPrtCjc5PU13k6rp24J6xGZ+B1
	 VdvXQCxJCviu0rmIBicC9T93h7VaL+bFM1dvcnnE=
Date: Mon, 18 May 2026 17:43:12 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,ingyujang25@korea.ac.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + error-inject-use-is_err-check-for-debugfs_create_file.patch added to mm-nonmm-unstable branch
Message-Id: <20260519004312.C8B2CC2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: error-inject: use IS_ERR() check for debugfs_create_file()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     error-inject-use-is_err-check-for-debugfs_create_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/error-inject-use-is_err-check-for-debugfs_create_file.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Ingyu Jang <ingyujang25@korea.ac.kr>
Subject: error-inject: use IS_ERR() check for debugfs_create_file()
Date: Fri, 15 May 2026 04:32:14 +0900

debugfs_create_file() returns an error pointer on failure, never NULL, so
the !file check in ei_debugfs_init() never triggers and the
debugfs_remove() cleanup cannot run.

Use IS_ERR() and propagate the actual error via PTR_ERR().

Link: https://lore.kernel.org/20260514193214.2432769-1-ingyujang25@korea.ac.kr
Signed-off-by: Ingyu Jang <ingyujang25@korea.ac.kr>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/error-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/error-inject.c~error-inject-use-is_err-check-for-debugfs_create_file
+++ a/lib/error-inject.c
@@ -219,9 +219,9 @@ static int __init ei_debugfs_init(void)
 	dir = debugfs_create_dir("error_injection", NULL);
 
 	file = debugfs_create_file("list", 0444, dir, NULL, &ei_fops);
-	if (!file) {
+	if (IS_ERR(file)) {
 		debugfs_remove(dir);
-		return -ENOMEM;
+		return PTR_ERR(file);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from ingyujang25@korea.ac.kr are

error-inject-use-is_err-check-for-debugfs_create_file.patch

