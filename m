Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EAF2FE56A
	for <mm-commits@vger.kernel.org>; Thu, 24 Sep 2026 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790280822; cv=none; b=csl5hDmBQXIaKvLJrQUGPdkkXeB/K8Uktq4/M+gRY4+XhoZatjRVFTZo6Uux55jbCBQYIkZcSREWIACSdjN78OBaCo74MCdfPJXAyfq32vIEU9aJipFNfOoaCt83oANMNHTIh0rzHn7B0nQr4M41KPAfUnrXA+SBEmI5AJkO1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790280822; c=relaxed/simple;
	bh=FGwSwoUaTkVPMBcO7lmvxvHrVc9BnihOLNx+9Q3Tvvo=;
	h=Date:To:From:Subject:Message-Id; b=hfzFo+izY8YhgRo551qGMMztwZi8rTNlQCcCSI49D/qsHUeggRNfkuqYj2VWny7/qq21eR06evgbRAdFjO6wThotpq5Xxf6JJf2kI0p8i7uIa7xn01HSaQORV11F27ZCRQcVag98XnxV7uUaWCGTe7yx4oeGFXkAkPr9nygJzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yfYmQFrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yfYmQFrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0071F00893;
	Thu, 24 Sep 2026 20:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790280820;
	bh=aohDW+rkVRQONl1Kh6OtK+c4ZvhWqWl6+x0Ljx6i7Vw=;
	h=Date:To:From:Subject;
	b=yfYmQFrtIdw3prGf+2TYrDP7hmfzP6OEd850dGWwNNz2m3Rr3WRBpKJfzV37MtnoU
	 siac1+xwetJn7eGL9ECpGTSyrC/8EkeBxq0j+iswuZU8Y18wRpd/MXsuh8x+lyqehq
	 YtNA3Uf13CX+zUKNv0NxqzficlMX3Pv5NZ22gao8=
Date: Thu, 24 Sep 2026 13:13:39 -0700
To: mm-commits@vger.kernel.org,joe@perches.com,jic23@kernel.org,apw@canonical.com,alison.schofield@intel.com,kanie@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch added to mm-nonmm-unstable branch
Message-Id: <20260924201340.1E0071F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: don't flag ACQUIRE_ERR() assignments in if conditions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch

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

Assisted-by: LLM
Link: https://lore.kernel.org/20260924033923.4140210-1-kanie@linux.alibaba.com
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Joe Perches <joe@perches.com>
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

checkpatch-dont-flag-acquire_err-assignments-in-if-conditions.patch

