Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FA41C6A3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935412; cv=none; b=H13KA0fEvio8tKQfnmGJDmzEUDgbvorLlypvmyJZlYqCepOdYSYi25lqm7I3L9FOMGVipg83YI8YjmhejEPsFeDu4FYNF14LXZDYijlwhGmPq6Fe+N1NEuIvZjJHp6Lok7ysMXhx1gmK3UGREg9LFkWNH9g52HwQCnYogAvI2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935412; c=relaxed/simple;
	bh=TTZhk5QcIV12VA+skq9c+6FxOYs6IxMXMrzz8Nt809I=;
	h=Date:To:From:Subject:Message-Id; b=m88LObC4GppCUDzCa2nafc1N8xkRQ4ByGq1zMpLJvLL190Z7X2n6iG9y01MktkkBMFFiuW/jeLashzDc6sG1yjGEClIZNcXAg3MSCy/a6ZxoUofoeUPlMds4C6H4XZy9cGro4MdhroQKyzq1bVyN1X2tk96oUIbdR9hgvqLm+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rLaJSL8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rLaJSL8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1D4C4CECF;
	Sat, 30 Nov 2024 02:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935412;
	bh=TTZhk5QcIV12VA+skq9c+6FxOYs6IxMXMrzz8Nt809I=;
	h=Date:To:From:Subject:From;
	b=rLaJSL8Z20obo6RbVzkarsJbZqnWIT0USyqmGyPzPzy8ngtRfrcEDH/x11LXptbLW
	 ueB02ithaDR2P2g7kcYM6ZVr9nEOtjV8uWZVp+g9CLUj3n4SxvYfM8Vk8u5HM59YSV
	 Zc+HtADT+bb4xlVnqaTcko2Dz1msKMXL/gyvGeUc=
Date: Fri, 29 Nov 2024 18:56:51 -0800
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,geert@linux-m68k.org,corbet@lwn.net,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-core-api-min_heap-add-author-information.patch added to mm-nonmm-unstable branch
Message-Id: <20241130025652.4A1D4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation/core-api: min_heap: add author information
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-core-api-min_heap-add-author-information.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-core-api-min_heap-add-author-information.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: Documentation/core-api: min_heap: add author information
Date: Sat, 30 Nov 2024 02:12:22 +0800

As with other documentation files, author information is added to
min_heap.rst, providing contact details for any questions regarding the
Min Heap API or the document itself.

Link: https://lkml.kernel.org/r/20241129181222.646855-5-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/min_heap.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/core-api/min_heap.rst~documentation-core-api-min_heap-add-author-information
+++ a/Documentation/core-api/min_heap.rst
@@ -4,6 +4,8 @@
 Min Heap API
 ============
 
+:Author: Kuan-Wei Chiu <visitorckw@gmail.com>
+
 Introduction
 ============
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-min_heap-improve-type-safety-in-min_heap-macros-by-using-container_of.patch
lib-test_min_heap-use-inline-min-heap-variants-to-reduce-attack-vector.patch
lib-min_heap-add-brief-introduction-to-min-heap-api.patch
documentation-core-api-min_heap-add-author-information.patch

