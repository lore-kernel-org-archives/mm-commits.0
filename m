Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181FA4052C2
	for <mm-commits@vger.kernel.org>; Sun, 11 Oct 2026 22:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757203; cv=none; b=T3S+YiuKKbnqiUNJQpVk2fRfL67MATujG9FPYODlSIgd8S3w1agkUKZdqeHeBV2qmuMsSVMkZGkQuCRX+9vBpxUORx0shC14HElCf0CNnFrT2IVkiqLqzZTnevbW4iTI7G1qFPkM9RX75TAV26rDcECEtDK531weqF+G8fuGHHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757203; c=relaxed/simple;
	bh=Q1RLb3szwTrHcqvff7uJFCcVq5Yc1ICogRHNPmtJOg8=;
	h=Date:To:From:Subject:Message-Id; b=RSR/uuJpwXlvIrHCRNzaM+RsbRHfE9Zp5BFP/1uaoahlJxzJFz7sHAY2dI+wHEzXP0PXw/RtxzVLtNy2kyY0N7y099EFo2v15GN0VgRPcneGhfj+NjKevqbZm8sPs1TqrjEIGI0qv2CFDBdjrg17o+QqFMZ+5bUcH0Aqk4CDDTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WS0hqPdg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WS0hqPdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E563F1F0089B;
	Sun, 11 Oct 2026 22:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757202;
	bh=d+n9yYlYTg3RkcNlnezVY574ioyn1WbTjKKa+EPNIow=;
	h=Date:To:From:Subject;
	b=WS0hqPdgLtS8wvRdALc1bprW9ZxX8LKgH+bYEnjcqctA17M7YN0ugfPsrc28K0p0K
	 CdQZLQMUr7CWht+xmmI70tBFLXHYHyPVZDCdDFc8SVPpeG5xGA6Z/CCduUmXpTrxwf
	 Hj5WW1MXyFqWSaashgNukI2zm7nsNk0QDcCL2Qjo=
Date: Sun, 11 Oct 2026 15:20:01 -0700
To: mm-commits@vger.kernel.org,joe@perches.com,jic23@kernel.org,apw@canonical.com,alison.schofield@intel.com,kanie@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch removed from -mm tree
Message-Id: <20261011222001.E563F1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: don't flag ACQUIRE_ERR() assignments in if conditions
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guixin Liu <kanie@linux.alibaba.com>
Subject: checkpatch: don't flag ACQUIRE_ERR() assignments in if conditions
Date: Thu, 24 Sep 2026 11:39:23 +0800

ACQUIRE_ERR() and its wrappers, PM_RUNTIME_ACQUIRE_ERR() and
IIO_DEV_ACQUIRE_FAILED(), report whether a conditional cleanup.h guard was
acquired, and drivers consume the result directly in an if condition:

	if ((rc = ACQUIRE_ERR(mutex_intr, &lock)))
		return rc;

That combined form is the established style at the 49 in-tree call sites
under drivers/cxl and drivers/pci/tsm.c, so ASSIGN_IN_IF fires there only
as a false positive, and every patch touching those lines carries noise
that reviewers have to wave off manually.

Skip the check only when every assignment in the condition assigns the
result of such a call, matched by the *_ACQUIRE_ERR() / *_ACQUIRE_FAILED()
naming convention of its wrappers.  Plain assignments, mixed conditions
and near-miss identifiers still get flagged.

Link: https://lore.kernel.org/20260924033923.4140210-1-kanie@linux.alibaba.com
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Joe Perches <joe@perches.com>
Assisted-by: LLM
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Jonathan Cameron <jic23@kernel.org>
---

 scripts/checkpatch.pl |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-dont-flag-acquire_err-assignments-in-if-conditions
+++ a/scripts/checkpatch.pl
@@ -5787,7 +5787,21 @@ sub process {
 			my ($s, $c) = ($stat, $cond);
 			my $fixed_assign_in_if = 0;
 
+			# ACQUIRE_ERR() and its wrappers, e.g. PM_RUNTIME_ACQUIRE_ERR()
+			# and IIO_DEV_ACQUIRE_FAILED(), are meant to be evaluated in an
+			# if condition, with the error assigned in the condition:
+			#	if ((rc = ACQUIRE_ERR(name, &lock)))
+			# Allow that only when every assignment in the condition assigns
+			# the result of such a call, so that a mixed condition keeps
+			# getting flagged:
+			#	if ((rc = regular_function()) || (ret = ACQUIRE_ERR(name, &lock)))
+			my $assign_in_if = 0;
 			if ($c =~ /\bif\s*\(.*[^<>!=]=[^=].*/s) {
+				my $has_assignment = $c =~ /\b$Lval\s*=\s*[^,)&|=]+/;
+				my $has_other_assignment = $c =~ /\b$Lval\s*=\s*(?!\s*\w*ACQUIRE_(?:ERR|FAILED)\s*\()[^,)&|=]+/;
+				$assign_in_if = !$has_assignment || $has_other_assignment;
+			}
+			if ($assign_in_if) {
 				if (ERROR("ASSIGN_IN_IF",
 					  "do not use assignment in if condition\n" . $herecurr) &&
 				    $fix && $perl_version_ok) {
_

Patches currently in -mm which might be from kanie@linux.alibaba.com are


