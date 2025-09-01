Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715BA223DF0
	for <mm-commits@vger.kernel.org>; Mon,  1 Sep 2025 20:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756757954; cv=none; b=OR2WZ6U2oOUvrLwlDODfd66RWz0QgJDGRrlBQUigo8BurQoPTmqxe6oIP/8KFHYjRBHamV2oRu1JBHUwLbcaj5jEm+6bmJdMDUMzibDlyvFlJi4I79bb8JMtkXzr7MdZ+TR+5bTaL/AD7Ph0CHF0f9nWjmIwRmixdhwxjk6Qg88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756757954; c=relaxed/simple;
	bh=UPE33DHgmhBd3KUIMlZwUltcGSM2oeQ8F0AbRHc/354=;
	h=Date:To:From:Subject:Message-Id; b=LYMkes+qtWoB+t+UkyIsiepHxoxMXsF9o85sMV/rZYgaWyl+OrFh2laHL5RXpo2mT+0bEaoHGWrgL4JK7+msmvZYnRfcGoq8q0rO6vc885dgXM8R7QvJO5aQ4dLid0Uw9V1rSKM+/+1AvHxTIZJyc2IZIzLOSUQfBEtPm3nONDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nqQq6qB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nqQq6qB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD1BC4CEF0;
	Mon,  1 Sep 2025 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756757954;
	bh=UPE33DHgmhBd3KUIMlZwUltcGSM2oeQ8F0AbRHc/354=;
	h=Date:To:From:Subject:From;
	b=nqQq6qB++IFGbSL1pQi4sAdyV11M8wx6almN2XEobRgbkq6Maj+xr4cBlUNJnzm0E
	 VEcCQC1rSmh3MGGUq7v9GTm2EcfkuHUbqI19FCrN/aWNR0dcVXjFPG8EvLYmoCY0i7
	 GCsZ+Ic5L8/7PuC0pPe2qiFrW6D2R3yv0QXrdBPw=
Date: Mon, 01 Sep 2025 13:19:13 -0700
To: mm-commits@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch added to mm-new branch
Message-Id: <20250901201914.1FD1BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch

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
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
Date: Mon, 1 Sep 2025 10:19:55 +0530

remove unnecessary blank line

Link: https://lkml.kernel.org/r/20250901044955.3902815-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4
+++ a/tools/mm/slabinfo.c
@@ -156,7 +156,6 @@ static void usage(void)
 static unsigned long read_obj(const char *name)
 {
 	size_t len;
-
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary.patch
tools-mm-slabinfo-fix-access-to-null-terminator-in-string-boundary-v4.patch

