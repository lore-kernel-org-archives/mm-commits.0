Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA293B777B
	for <mm-commits@vger.kernel.org>; Wed, 27 May 2026 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913352; cv=none; b=URUrdsf2URJ4InhJDfhIp7Ip9f6XSZb3J63WNA4b2a0QTxr/PrJFlV9OcVwXqD6AYAPus9wzXdTbM4y7ftw68U5vz2enp8br0L1AN6Wcd13EEjmQ3hQ42gFgPbxAjP5yAMnIG1lTSjbAIlc85XV3PPPltwn4iCgo38BCFDqeqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913352; c=relaxed/simple;
	bh=3XMwRrJyeriobHd9kM/KOmil6wt46HkSsSGqBlSHkpk=;
	h=Date:To:From:Subject:Message-Id; b=ZWDOhSbUasggNgd4VufeE+KOajpnF7y2/sJPZChsn8Rr5gulBLHHbG/YSXa4LtieJXy/2oFtmYvbIYkNFIieCOpoBbYCMbKMyIuLr20VCbjzM3Ab1/k0dUcsnwQbp7aYXegzvU9psBscpG5YUft8OWmNSO2QGsLqSczC9hTTBQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3yYxXbC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3yYxXbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6B91F000E9;
	Wed, 27 May 2026 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779913351;
	bh=vbVKVHpNuC3l/WNdsp0l4Hom3RhJ5rUdve7LpaFpKMw=;
	h=Date:To:From:Subject;
	b=F3yYxXbCdkgAJCj0Sz1p2KnOkNVMr80hGH4oZ5PUII8PgWfBwWm9uAFMhkihyKWE/
	 SnGV5VuFzAJU1bFKjFdxff1roO6/jy5Tip69fe0E300BlsNvxMplRqCP3zU+/zJryk
	 ESJMxt5LD4or7AipKJHmDtdfSMTUgHzgPLWNAfJI=
Date: Wed, 27 May 2026 13:22:30 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + raid6-hide-internals-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260527202231.1D6B91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: raid6: remove duplicate ccflags-y line
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     raid6-hide-internals-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/raid6-hide-internals-fix.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: raid6: remove duplicate ccflags-y line
Date: Wed, 27 May 2026 09:45:25 +0200

This was added by a mismerge when rebasing, remove it.

Link: https://lore.kernel.org/20260527074539.2292913-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/raid/raid6/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/raid/raid6/Makefile~raid6-hide-internals-fix
+++ a/lib/raid/raid6/Makefile
@@ -2,8 +2,6 @@
 
 ccflags-y			+= -I $(src)
 
-ccflags-y			+= -I $(src)
-
 obj-$(CONFIG_RAID6_PQ)		+= raid6_pq.o tests/
 
 raid6_pq-y			+= algos.o tables.o
_

Patches currently in -mm which might be from hch@lst.de are

raid6-turn-the-userspace-test-harness-into-a-kunit-test.patch
raid6-remove-__kernel__-ifdefs.patch
raid6-move-to-lib-raid.patch
raid6-remove-unused-defines-in-pqh.patch
raid6-remove-raid6_get_zero_page.patch
raid6-use-named-initializers-for-struct-raid6_calls.patch
raid6-improve-the-public-interface.patch
raid6-warn-when-using-less-than-four-devices.patch
raid6-hide-internals.patch
raid6-hide-internals-fix.patch
raid6-rework-registration-of-optimized-algorithms.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch

