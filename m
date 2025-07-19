Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D5C20101F
	for <mm-commits@vger.kernel.org>; Sat, 19 Jul 2025 23:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752967914; cv=none; b=WMUqP0gY7xJTHO4DUe5o75tOrHojKIawW3XBQRhE1TU1R9FaUuL1LRJKpBMeA5LxKkC2Kmz60Y0N/MJoJwoQptyvBpiDtBxhLiPMK7RhwHIkGP6frW/wrTK0Iq3xtyfYBFrWVpaeTxzDLEDIXnJaKbid0LbBcThPAGlo7BxMhMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752967914; c=relaxed/simple;
	bh=Ogu0qNWaPjLkBbKWr//Gu7yp5uzNjmW9j4iUUN1rbSg=;
	h=Date:To:From:Subject:Message-Id; b=Sgn6lhhlrn1MkrBsshMwPFNFV5HrMplh6keMed2VB33agO7kp+AVtKMJoLDDArhR+5NT7NxeknWxAQzkUW1wBFpEnYoFqIOm+BFe2TJGxTvzpedi19RLirSYUJn6WmIGo/sh5noMLO92vUdiPnqgrFhZ8g3M4TSgTY3S+KCxuM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RzkyUohN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RzkyUohN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC36C4CEE3;
	Sat, 19 Jul 2025 23:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752967913;
	bh=Ogu0qNWaPjLkBbKWr//Gu7yp5uzNjmW9j4iUUN1rbSg=;
	h=Date:To:From:Subject:From;
	b=RzkyUohNcndsi41X4LM/q8K0Zt5jhNRPaXEZ/jpuagNkDWd9PO4RzwdVmppJ5gy12
	 ekWeI67o5NKleF8aiw76pQX0Ea7O53ey7kF7Ny8okxlefSp8OuDvJgfiIhDeEaNzkr
	 tAMvFHTgwmV9ycBkwdN4D1CJc6kaxkfOChOuAZyE=
Date: Sat, 19 Jul 2025 16:31:52 -0700
To: mm-commits@vger.kernel.org,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resource-fix-false-warning-in-__request_region.patch added to mm-nonmm-unstable branch
Message-Id: <20250719233153.1DC36C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource: fix false warning in __request_region()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     resource-fix-false-warning-in-__request_region.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resource-fix-false-warning-in-__request_region.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: resource: fix false warning in __request_region()
Date: Sat, 19 Jul 2025 20:26:04 +0900

A warning is raised when __request_region() detects a conflict with a
resource whose resource.desc is IORES_DESC_DEVICE_PRIVATE_MEMORY.

But this warning is only valid for iomem_resources.
The hmem device resource uses resource.desc as the numa node id, which can
cause spurious warnings.

This change fixes this by restricting the warning to only iomem_resource.
This also adds a missing new line to the warning message.

Link: https://lkml.kernel.org/r/20250719112604.25500-1-akinobu.mita@gmail.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/resource.c~resource-fix-false-warning-in-__request_region
+++ a/kernel/resource.c
@@ -1279,8 +1279,9 @@ static int __request_region_locked(struc
 		 * become unavailable to other users.  Conflicts are
 		 * not expected.  Warn to aid debugging if encountered.
 		 */
-		if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-			pr_warn("Unaddressable device %s %pR conflicts with %pR",
+		if (parent == &iomem_resource &&
+		    conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
+			pr_warn("Unaddressable device %s %pR conflicts with %pR\n",
 				conflict->name, conflict, res);
 		}
 		if (conflict != parent) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

resource-fix-false-warning-in-__request_region.patch

