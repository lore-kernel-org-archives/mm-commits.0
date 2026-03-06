Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DBA18FDBD
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820348; cv=none; b=Uh5gRI33m8J0+sQc/xm9GbMfJa6Li3u0uOJLIo9NzW02XfsTK+MaMNK5zuxLTLMOvn52vCakjLaxa1FCPKF+srV2A4uaI02lSkXpQuIJc4+7oV7uwExnS4/LFwRLv9+xFq20vZfLoOh4AALB3xBqDrIJiL5CqxSZLtNHSk0V0JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820348; c=relaxed/simple;
	bh=9kjaydqhPoeJQ8VUdp6iO17B6704PU4oRTLKKE707zo=;
	h=Date:To:From:Subject:Message-Id; b=XhLS5Q5iM/CN4JsAKprFLWaufcn115vuu8maz+yo4IdZMtj1sW+3/SurpH2XxSSRtBL/Gb4uUocOAebpvwA1hpr47aNthdZAjckR/6Z+kVt6PdaLiNKjThhw2mmYQ1eGXImprl1HUQIQUmjIgygEM6euTuQvCE5Cby3nAFvQjqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yse/9SaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yse/9SaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F212C4CEF7;
	Fri,  6 Mar 2026 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772820348;
	bh=9kjaydqhPoeJQ8VUdp6iO17B6704PU4oRTLKKE707zo=;
	h=Date:To:From:Subject:From;
	b=Yse/9SaA1T7hcetSYOFDVEoYVQhDef14j1IN2njbYd4ZJixk+XHqaWx6KcNCrA1wi
	 g+aoBlYcTCLlw1Rj/gia+FCPRjNsIEn1b/KpbRxgnGtNUzFviElcCqh9YVjYYRGzg1
	 IOZ2zUAuLcOh/XZxyl3K6WrDQwiqPAJFIfdyst8Q=
Date: Fri, 06 Mar 2026 10:05:47 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20260306180548.4F212C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/inflate: fix memory leak in inflate_fixed() on inflate_codes() failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch

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
From: Josh Law <hlcj1234567@gmail.com>
Subject: lib/inflate: fix memory leak in inflate_fixed() on inflate_codes() failure
Date: Fri, 6 Mar 2026 16:16:12 +0000

When inflate_codes() fails in inflate_fixed(), only the length list 'l' is
freed, but the Huffman tables 'tl' and 'td' are leaked.  Add the missing
huft_free() calls on the error path.

Link: https://lkml.kernel.org/r/20260306161612.2811703-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/inflate.c~lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure
+++ a/lib/inflate.c
@@ -811,6 +811,8 @@ DEBG("<fix");
 
   /* decompress until an end-of-block code */
   if (inflate_codes(tl, td, bl, bd)) {
+    huft_free(tl);
+    huft_free(td);
     free(l);
     return 1;
   }
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch

