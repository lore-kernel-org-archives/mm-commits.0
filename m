Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E1A22FE11
	for <mm-commits@vger.kernel.org>; Thu, 26 Mar 2026 02:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774491978; cv=none; b=n3JNvlaWfNGZyp4yQt3tYr32CqZjopxJYeTG79u5ghMD5MmmouLZUAGoy/8NQpARuEX0N5Qg6cmEnTYIZcGeu4cGAQ9zc0xspS232vWzQmQn7Z2ztR87dFL3VvHRYZHuZ4H1YKwRJLsc4q75g4E9MXxCrM9C5h4ARYW9Wl90adM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774491978; c=relaxed/simple;
	bh=+L0xuu3tmg3A47AHLosjiP/rwAdUItUlCsrv1Sr+jWM=;
	h=Date:To:From:Subject:Message-Id; b=bEHaFmO0s6YBWAhXmOBDxIZNcbIIOxKU8FpK7FWgFWyh0Wu8hvzhW6YB6tkD7Plc2EY7EGIxUEnddnOmBcbQ3x+51T2SQUhEV/u90AeCfCGphTUbnRmFRW6h3JO0u/k6WESuRHZm/0E+uMImsANaRPR+LPjjZOI66yv/d6nGyvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jWJyyslX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWJyyslX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A52C2BCB0;
	Thu, 26 Mar 2026 02:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774491978;
	bh=+L0xuu3tmg3A47AHLosjiP/rwAdUItUlCsrv1Sr+jWM=;
	h=Date:To:From:Subject:From;
	b=jWJyyslXV3NzOPO95H54PAwMPvhYzl7HQaIGTJ6WDHI7M7hNNg/oJ48CCuDzOXlp6
	 J692yMmQqhj5vJcmBOIuFfhUM4AieOAiaqS2RQgOyMAR1fRwzBhpj0/OpoipluIkLQ
	 5QpwrzB8m/m2KDqfaxFL5YuwBkAzFNPUiOnn6Jas=
Date: Wed, 25 Mar 2026 19:26:17 -0700
To: mm-commits@vger.kernel.org,objecting@objecting.org,joe@perches.com,jbaron@akamai.com,changbin.du@gmail.com,inseob@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch added to mm-nonmm-unstable branch
Message-Id: <20260326022618.36A52C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: parser: fix match_wildcard to correctly handle trailing stars
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch

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
From: Inseob Kim <inseob@google.com>
Subject: lib: parser: fix match_wildcard to correctly handle trailing stars
Date: Thu, 26 Mar 2026 11:06:04 +0900

This fixes a bug in match_wildcard that incorrectly handles trailing
asterisks.  For example, `match_wildcard("abc**", "abc")` must return
true, but it returns false.

Link: https://lkml.kernel.org/r/20260326020630.4139520-1-inseob@google.com
Signed-off-by: Inseob Kim <inseob@google.com>
Cc: Changbin Du <changbin.du@gmail.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Law <objecting@objecting.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/parser.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/parser.c~lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars
+++ a/lib/parser.c
@@ -315,7 +315,7 @@ bool match_wildcard(const char *pattern,
 		}
 	}
 
-	if (*p == '*')
+	while (*p == '*')
 		++p;
 	return !*p;
 }
_

Patches currently in -mm which might be from inseob@google.com are

lib-parser-fix-match_wildcard-to-correctly-handle-trailing-stars.patch

