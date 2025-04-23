Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99021DE2A9
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 00:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745367719; cv=none; b=HZhp5KGnDP5IbZY5fVDIrwIt+eaDDdRvd050d3ws5B5iTGMSKvQAlciJMKgxW+mjhZCRX5cClMmRaREIzQBH6BMegaEjdBjTFCdXOYyIsD4IJS2HpODjlGvY04Ef4OrmNhaYeVK2sKRSNz/LmxD2aa6E+t8dVn5OsOdfkR1XD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745367719; c=relaxed/simple;
	bh=X5tv/tPP6VlwjUhKcC/OTIdqXFqvZje1ADYtUsqxH44=;
	h=Date:To:From:Subject:Message-Id; b=R9FWIuT5tvN/Go1Kd6yXH5mAZVaWziZ2h3T1JGN+uT/Q9V0D80nODg6V9eaRFWdRVcg+gUTfzNddbbHR8nlCfVEr8nms13GfkwcrfOTMj3/duWgVJNMftD4suFajWtd3CUkYR2EWPws6awRPyNzhoE4juSa6EiCxbG1OMkXEFtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SGvc6YWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SGvc6YWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11532C4CEE9;
	Wed, 23 Apr 2025 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745367719;
	bh=X5tv/tPP6VlwjUhKcC/OTIdqXFqvZje1ADYtUsqxH44=;
	h=Date:To:From:Subject:From;
	b=SGvc6YWdgcPH1e45G45ynnD9kJx/N0LbiCtXO/rYvTKUHHRU+yplIUf+PTGPTGtq8
	 LErliaWYbUM9KNdHm7ehRYYeDgD59kx/yHSgRzYecKg+z9igcluZo2vhJafD+rdRcR
	 9weBGSML97Ie7Z+Nyv9GWiyoLfIOMu0H+btbSWcc=
Date: Tue, 22 Apr 2025 17:21:58 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,keescook@chromium.org,andrii@kernel.org,yatsenko@meta.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch added to mm-nonmm-unstable branch
Message-Id: <20250423002159.11532C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maccess: fix strncpy_from_user_nofault() empty string handling
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

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
From: Mykyta Yatsenko <yatsenko@meta.com>
Subject: maccess: fix strncpy_from_user_nofault() empty string handling
Date: Tue, 22 Apr 2025 14:14:49 +0100

strncpy_from_user_nofault() should return the length of the copied string
including the trailing NUL, but if the argument unsafe_addr points to an
empty string ({'\0'}), the return value is 0.

This happens as strncpy_from_user() copies terminal symbol into dst and
returns 0 (as expected), but strncpy_from_user_nofault does not modify ret
as it is not equal to count and not greater than 0, so 0 is returned,
which contradicts the contract.

Link: https://lkml.kernel.org/r/20250422131449.57177-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Reviewed-by: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/maccess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/maccess.c~maccess-fix-strncpy_from_user_nofault-empty-string-handling
+++ a/mm/maccess.c
@@ -196,7 +196,7 @@ long strncpy_from_user_nofault(char *dst
 	if (ret >= count) {
 		ret = count;
 		dst[ret - 1] = '\0';
-	} else if (ret > 0) {
+	} else if (ret >= 0) {
 		ret++;
 	}
 
_

Patches currently in -mm which might be from yatsenko@meta.com are

maccess-fix-strncpy_from_user_nofault-empty-string-handling.patch

