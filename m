Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4F423EA8B
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772820453; cv=none; b=erdY89DF2Xq85vioQDLdoP147U+MOtJHKMXVW9cSTYorHhBBpxaVHX3WSyBIXDpW+kEHKjFImx9DPJytUqrWubNKb0GoP1Os7J5BSldUboLA4XxVMr5iqZuRt+N51an0LX33PdwpqSzrySbgLoq6SOj+/3wSA1Py3VxUtgJnV/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772820453; c=relaxed/simple;
	bh=thFYMYcc5jHD04OfdhpsAMUWXTbb6oH6B3tj/D1ODVk=;
	h=Date:To:From:Subject:Message-Id; b=MLdyhIdlkERcAsi9etFDaIwc1PVWOwHx0dA4WiBTOF9R0UO/fBPUuEfT/EllMyH4OgFZlcWmPCjazHpp6KiwRUD2ZJAyfmNXw8E1odr1+GFEtgy2tlVMKa/gPjS6UWUBVS1BtX/3jPUraBK0sQmzOGXjnVCk0hGlRGoD+720bVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZRck6zQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZRck6zQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519E2C4CEF7;
	Fri,  6 Mar 2026 18:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772820453;
	bh=thFYMYcc5jHD04OfdhpsAMUWXTbb6oH6B3tj/D1ODVk=;
	h=Date:To:From:Subject:From;
	b=ZRck6zQc/9ix6V7WtGe651hPIz6R+CeCGEeE2jXpI1bKMZW/DRtMtst5XplN6S/GM
	 OwKjDBA0YVkrcsx8ZUgXNeLsaPA1Btjar3E/K+1q6cxKJTJYEHGPt2fyQY7DRgElop
	 8pYABeFxzziVzX0LA+m5o3T5Q86K1ID9OrS66vNs=
Date: Fri, 06 Mar 2026 10:07:32 -0800
To: mm-commits@vger.kernel.org,objecting@objecting.org,akpm@linux-foundation.org,hlcj1234567@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch added to mm-nonmm-unstable branch
Message-Id: <20260306180733.519E2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/inflate: fix memory leak in inflate_dynamic() on inflate_codes() failure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch

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
Subject: lib/inflate: fix memory leak in inflate_dynamic() on inflate_codes() failure
Date: Fri, 6 Mar 2026 16:16:47 +0000

When inflate_codes() fails in inflate_dynamic(), the code jumps to the
'out' label which only frees 'll', leaking the Huffman tables 'tl' and
'td'.  Restructure the code so that the decoding tables are always freed
before reaching the 'out' label.

Link: https://lkml.kernel.org/r/20260306161647.2811874-1-objecting@objecting.org
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/lib/inflate.c~lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure
+++ a/lib/inflate.c
@@ -1009,10 +1009,10 @@ DEBG("dyn5d ");
 DEBG("dyn6 ");
 
   /* decompress until an end-of-block code */
-  if (inflate_codes(tl, td, bl, bd)) {
+  if (inflate_codes(tl, td, bl, bd))
     ret = 1;
-    goto out;
-  }
+  else
+    ret = 0;
 
 DEBG("dyn7 ");
 
@@ -1021,7 +1021,6 @@ DEBG("dyn7 ");
   huft_free(td);
 
   DEBG(">");
-  ret = 0;
 out:
   free(ll);
   return ret;
_

Patches currently in -mm which might be from hlcj1234567@gmail.com are

lib-glob-add-missing-spdx-license-identifier.patch
lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.patch
lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.patch

