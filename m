Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5793272E6D
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641494; cv=none; b=gFHSlkocxHj222khusLlEx5UPyd7VbT8RFsjr1jHF3M1Shdk/G+7nG/B+FhfCkuyRnLGjnj0BE/KxNuX9WgVduAUU7YLZJYQL2idAr119Lc+1nLl9HnMEWisdfG+rSSRcuZlImgNdkdMgZdRXSdZd9OgC54f9+oRu/SSlxZZPB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641494; c=relaxed/simple;
	bh=z/CpVvs/kAC1VxSTLJywB0o/J4ceX/kKBagidosgIgA=;
	h=Date:To:From:Subject:Message-Id; b=aFcCJaB/xw2/SmLBUh2A7fWnUlMEVqnJzEnWlmWdswLZXh8c5VXCzlrLSa3e02E0fVUM0W4ie6D7UqI5zNFz1RZY9qep/fxLhB/XmlLaXdQJU0i23X0m10tTb1843R/g2BGm6MR9gVurvHwDt3KINjobGMxmtiFJ2w3WiUT89no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R7aa76sm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R7aa76sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3CAC2BCB4;
	Fri,  1 May 2026 13:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777641494;
	bh=z/CpVvs/kAC1VxSTLJywB0o/J4ceX/kKBagidosgIgA=;
	h=Date:To:From:Subject:From;
	b=R7aa76smdoGJez/hYw6WX+Jwe5IgzlP1iHuHLEMRMvUtuncXQH+sceUkCJTEupsJb
	 iDfNoQN36H9Gaf8CK277BWaIQa5tcdRHma4oQuJ0q1h4ogb+t7tiba+Mes3gDpEKDo
	 31ATCj4wR2g0TZPfEwgHQ1/vxlKX8/lZ84BbMwtk=
Date: Fri, 01 May 2026 06:18:13 -0700
To: mm-commits@vger.kernel.org,devnexen@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20260501131814.6A3CAC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
Date: Fri May  1 06:17:38 AM PDT 2026

WARNING: Unknown commit id '8e6e0d845823', maybe rebased or not pulled?
#28: 
Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device")

WARNING: Assisted-by expects 'AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]' format
#29: 
Assisted-by: Codex (gpt-5-codex)

ERROR: code indent should use tabs where possible
#54: FILE: include/linux/swap.h:440:
+                                       sector_t offset);$

WARNING: please, no spaces at the start of a line
#54: FILE: include/linux/swap.h:440:
+                                       sector_t offset);$

total: 1 errors, 3 warnings, 106 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Carlier <devnexen@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes
+++ a/include/linux/swap.h
@@ -437,7 +437,7 @@ extern void si_swapinfo(struct sysinfo *
 extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
 extern void unpin_hibernation_swap_type(int type);
 extern int repin_hibernation_swap_type(int old_type, dev_t device,
-                                       sector_t offset);
+				       sector_t offset);
 extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch

