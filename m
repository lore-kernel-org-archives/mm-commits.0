Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E2B175A91
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028299; cv=none; b=H3WXqa9TJ1Oo4OrrlF356QYEo6EVy85woI328qe4s7Fo8M3voH8ehA6Wk6V1CT5PXNziwN4YZgeVSOg3CyQnlHo2HMrxGVg9gL33ZFXtpREtFW6Ygi5y88X5yAJ/Fca/wHL6E7oLRRe5R26kejm/DEjzrF8y0HC0DQ+uUaweHPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028299; c=relaxed/simple;
	bh=Tq09IB/n/aU4Rb4U7oNE7C83G5+Tpf3FRkZrLbctc1c=;
	h=Date:To:From:Subject:Message-Id; b=pTdeUWY9RhY25KfoZlyRizJEQ8UBkevp00FDnNyEWYk79D6M7aGT+KUcKcukC13mQVwboeWL3NiqGSFx06NEaCm4Bq/yzLNA1eeBoI8/iVc0IxRf6S3bccZW79Nm3ocJZvE363H3y6Fev5pPH4MrmOSTb8X1fBv/5ucg+QCUYCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=biCue7sA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="biCue7sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A571F00893;
	Fri, 29 May 2026 04:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028297;
	bh=+KOWS0FINrOldwnyEr2KoFbUZF0omfEwIFRM3IFsKqQ=;
	h=Date:To:From:Subject;
	b=biCue7sAsy7NqWByGZHifge0IORu5Vk9MWzSepsra/np3vWJbD3shg3EA9m4pg2hB
	 VQiWtzpGRRe6129t7HO4l7gzqGatdaPHpJkbJcXXNTF4/y567S6yMxdroEpk7I+ki6
	 CvLUCZEh4LKUjD00otrN5m6OyOEETgIl2j6u79ww=
Date: Thu, 28 May 2026 21:18:17 -0700
To: mm-commits@vger.kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] raid6-hide-internals-fix.patch removed from -mm tree
Message-Id: <20260529041817.A0A571F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: raid6: remove duplicate ccflags-y line
has been removed from the -mm tree.  Its filename was
     raid6-hide-internals-fix.patch

This patch was dropped because it was folded into raid6-hide-internals.patch

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
raid6-rework-registration-of-optimized-algorithms.patch
raid6-rework-registration-of-optimized-algorithms-fix.patch
raid6-use-static_call-for-gen_syndrom-and-xor_syndrom.patch
raid6-use-static_call-for-raid6_recov_2data-and-raid6_recov_datap.patch
raid6-update-top-of-file-comments.patch
raid6_kunit-use-kunit_case_param.patch
raid6_kunit-dynamically-allocate-data-buffers-using-vmalloc.patch
raid6_kunit-cleanup-dataptr-handling.patch
raid6_kunit-randomize-parameters-and-increase-limits.patch
raid6_kunit-randomize-buffer-alignment.patch

