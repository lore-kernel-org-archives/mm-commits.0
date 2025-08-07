Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D33E186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538273; cv=none; b=mwO/oFscWsnDiWcVnHE4cu6qF34SJkV03ZlhH24Z6CRuDqTVpbwfI1zKGvHK+btKmIWKIpeeH2LEW8jf5ESg0dNyHaOvD5gKgt9zDRgPA2fSLJP6neCO52lOh0YtXJq8hy4eSgSnzzT/wAPU3ifHIF+exBZb+cOUykS3bdyK0Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538273; c=relaxed/simple;
	bh=rYrMwubbQr9mB/AGoe+bN0uEY0LCTPySlRdrpwyWGM0=;
	h=Date:To:From:Subject:Message-Id; b=usBYSJ79CJLphhmKmpvfmycda8WbYDwRXq2MQLZjCc3fr3D6mVErX0XgNrqg9Titd4m9Ra+CRfGQ+RNelTqCcSsZuSFblpMUqSioAaWUxm3ayTprRXqretWvcq1pwcohloDOeiY7CI+SIKk/hwCVEuxuVZo7Mz0Km2MAH2mUV8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciax/nk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciax/nk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660E6C4CEF4;
	Thu,  7 Aug 2025 03:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538273;
	bh=rYrMwubbQr9mB/AGoe+bN0uEY0LCTPySlRdrpwyWGM0=;
	h=Date:To:From:Subject:From;
	b=ciax/nk8bf+unAU0hTt8sPkDhp1DQCAc/y6LOPnUnZe+pZyv8iCUjwLdrdkGFwQCV
	 PzUVdv212GPCXjq1rUA1rYnW66yzQHk7xHtERCztgQHZF0qZoxItSXsKnirQckafMV
	 2HTXOFfuurnHuLZ5vOuwSi3sEeBdVA8rdGB9Mvho=
Date: Wed, 06 Aug 2025 20:44:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-kselftesth-add-__unused-macro.patch added to mm-new branch
Message-Id: <20250807034433.660E6C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: kselftest.h: add __unused macro
has been added to the -mm mm-new branch.  Its filename is
     selftests-kselftesth-add-__unused-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-kselftesth-add-__unused-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: kselftest.h: add __unused macro
Date: Thu, 31 Jul 2025 21:01:27 +0500

Add __unused macro instead of using the complete verbose unused compiler
attribute.  The raw __attribute__((__unused__)) is quite long and makes
code too much verbose to the kernel developer's taste.

Link: https://lkml.kernel.org/r/20250731160132.1795351-4-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/kselftest.h~selftests-kselftesth-add-__unused-macro
+++ a/tools/testing/selftests/kselftest.h
@@ -92,6 +92,10 @@
 #endif
 #define __printf(a, b)   __attribute__((format(printf, a, b)))
 
+#ifndef __unused
+#define __unused         __attribute__((__unused__))
+#endif
+
 /* counters */
 struct ksft_count {
 	unsigned int ksft_pass;
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

