Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E72182D7
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 01:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739236921; cv=none; b=U4swtpxxOzMJR2Y43BNAPKnoJivHWR5LkvHidPe5tTlgWS9CNCLAFc4ENKHcellnZhQOCGTswCNCbk3CZevLfg7fvC+YrETM7bkq4HPgNgrktfG+ZakN/LaGXff/ZA1XUIz/XnYMp7/D2LB8S2Q4WMvVbxgv3tu60cXSgjYuuFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739236921; c=relaxed/simple;
	bh=D61CyT/TeiQMZThfHNr3ThNKgFy6o2abt3qBEPiP7/g=;
	h=Date:To:From:Subject:Message-Id; b=pPoNnvzn6h+RUGsvMANxOkSVTP1tAPUMYWz9c63IyaZi3vIeN2JJ7qyU8LTYuv9rR+MODPG3k5vGx8N2r+RZlQvyxnXOxYntKRcIpVlB1SjrZbnDvaeE5e51Q3ByRUzC22C9o0nZygFVKyVkqvOjkOOCbBgIts3I6mXtGRAkdn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P4M0FqYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P4M0FqYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D37C4CED1;
	Tue, 11 Feb 2025 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739236921;
	bh=D61CyT/TeiQMZThfHNr3ThNKgFy6o2abt3qBEPiP7/g=;
	h=Date:To:From:Subject:From;
	b=P4M0FqYRRgwXA3FvjQr5a2fu//yIcHVefEyGWAvkJ1RKR2mw6fSYu5mjqCrK9i+Gx
	 SbKZhEwSu9BCwUeLMX3DAkJJYgVTMJbNpM+mneCeCO/uTdYZmBMH7AuqEKWFJ0yOTU
	 cdvH6OcKTHfcBT7zL431RvLr9t0YA2PH8u52E/so=
Date: Mon, 10 Feb 2025 17:22:00 -0800
To: mm-commits@vger.kernel.org,ericsalem@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fixed-typo.patch added to mm-unstable branch
Message-Id: <20250211012201.68D37C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: fix typo
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fixed-typo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fixed-typo.patch

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
From: Eric Salem <ericsalem@gmail.com>
Subject: selftests: mm: fix typo
Date: Sat, 8 Feb 2025 20:36:36 -0600

Fix misspelling.

Link: https://lkml.kernel.org/r/77e0e915-36c3-4c95-84b8-0b73aaa17951@gmail.com
Signed-off-by: Eric Salem <ericsalem@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-fixed-typo
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -323,7 +323,7 @@ int uffd_test_ctx_init(uint64_t features
 	ret = userfaultfd_open(&features);
 	if (ret) {
 		if (errmsg)
-			*errmsg = "possible lack of priviledge";
+			*errmsg = "possible lack of privilege";
 		return ret;
 	}
 
_

Patches currently in -mm which might be from ericsalem@gmail.com are

selftests-mm-fixed-typo.patch

