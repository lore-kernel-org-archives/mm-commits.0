Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB118219E0
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750807823; cv=none; b=hkX99RhRZnxdVS4d7XpjUD8l5m1I8Has5w4XmjF7goQ99UMwoH67JwMCUAWBsb7XLEf3y5+Lu1M9R+d7ofkZMQKdhmrADA3EVKKc7GlT2UbAms/PZwq/2dDkjRNwmOW4BsnXMJJyMoSrT6LKo6rn1zP935po6gNlAYZZBC2b5ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750807823; c=relaxed/simple;
	bh=5Jg62GoqG3FNCDgHbmJVHK0oNZ68XTNaizDmKrSBPCc=;
	h=Date:To:From:Subject:Message-Id; b=Q2XfANFC4jVwyYGQKwKhWA1ougf6TKHvEO5ziYe8DRGp2MoFzQPirHnR+gYfuRj8V/GgDxyBmYUpJHKXOUNQlwhEmP8kwBQStt/V60bio1HgrUqlHB9rPhRJa7ViltErzf7nCQzeqDeGAfZoTesuJupZuIM4pGLelbq+C+wZDHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AO3NsIAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AO3NsIAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5915CC4CEE3;
	Tue, 24 Jun 2025 23:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750807822;
	bh=5Jg62GoqG3FNCDgHbmJVHK0oNZ68XTNaizDmKrSBPCc=;
	h=Date:To:From:Subject:From;
	b=AO3NsIAGZ3Lhr4+k9E1/SmJc9C4+l7k7HXN//D2YKN52iM7BVsylLBCZ8S5XJ6Weh
	 3XmeVZICYvMB9du9VJGCWS/70pySghKQuBCE/PAMX2p09iUPdri5/xpXrjswFiTjrM
	 pEd9pPjuQYsZRo7SttvFyT9Lfz+7G3ro0aZB7U8Y=
Date: Tue, 24 Jun 2025 16:30:20 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-use-goto-label-to-simplify-code.patch added to mm-unstable branch
Message-Id: <20250624233022.5915CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple tree: use goto label to simplify code
has been added to the -mm mm-unstable branch.  Its filename is
     maple-tree-use-goto-label-to-simplify-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-use-goto-label-to-simplify-code.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: maple tree: use goto label to simplify code
Date: Tue, 24 Jun 2025 13:37:48 +0530

Use the underflow goto label to set the status to ma_underflow and return
NULL, as is being done elsewhere.

Link: https://lkml.kernel.org/r/20250624080748.4855-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple-tree-use-goto-label-to-simplify-code
+++ a/lib/maple_tree.c
@@ -4565,11 +4565,8 @@ again:
 		return entry;
 
 	if (!empty) {
-		if (mas->index <= min) {
-			mas->status = ma_underflow;
-			return NULL;
-		}
-
+		if (mas->index <= min)
+			goto underflow;
 		goto again;
 	}
 
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-fix-validate_addr-helper.patch
xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch

