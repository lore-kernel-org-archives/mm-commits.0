Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93928EEA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186588; cv=none; b=GKbPQMsbCgV6f/f0ZHBB6V7d7ZyurvNS3qwO4YWpXxTH/qLsEtFyQUkGUSFTN0hyVISr/DK8sY64kSpLsp0hB2HyOGaE+/wqHYf5caFwXlRgi0tdwyw1Or8zqxKXcnhat7H8691cci3erJH7unw0jObxZIktDGJM4mAO+OMgceQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186588; c=relaxed/simple;
	bh=az1s5ptS1rqOdALQdiKxOwvuv5Ioa+3lpIKxjZ+N5KY=;
	h=Date:To:From:Subject:Message-Id; b=UhcovfZh37UG+oAzX2FNlTIxABZbGUy0TEUtF29VoJyON+wFIyLsAnBYqkoupE+TVIVmt86EtPgRkOONWNKaFyjAw7v0rkwwXVY6CGiPOTcmFf5FIYoewi9U6MjnR8khMmRDI2X5A//l5U/nDJEs0E4UIXXpZHeYDir9n5YNS8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BBS35XkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BBS35XkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE780C4CEEC;
	Mon, 17 Mar 2025 04:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186588;
	bh=az1s5ptS1rqOdALQdiKxOwvuv5Ioa+3lpIKxjZ+N5KY=;
	h=Date:To:From:Subject:From;
	b=BBS35XkOHE+CDU0ZIa+wQkjuT/hHwl1aMgYKaWKbrRXHotGxeJdggzAp+6FynfFm2
	 GmDUQhtMJ0hvoB+dfy+Sm0Pf09laB0sUikIvMdSJ0S/7Dz2coJQHdODpM6WeoomSTj
	 2DIIU/kKtC/mFT5w7UEZjUMkdKAqQ1EVobi2fgKE=
Date: Sun, 16 Mar 2025 21:43:07 -0700
To: mm-commits@vger.kernel.org,thomas.prescher@cyberus-technology.de,muchun.song@linux.dev,corbet@lwn.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch removed from -mm tree
Message-Id: <20250317044307.EE780C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
Date: Mon Mar  3 08:51:01 PM PST 2025

tidy up a comment

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option-fix
+++ a/mm/hugetlb.c
@@ -5002,7 +5002,9 @@ void __init hugetlb_bootmem_alloc(void)
 	__hugetlb_bootmem_allocated = true;
 }
 
-/* hugepage_alloc_threads command line parsing
+/*
+ * hugepage_alloc_threads command line parsing.
+ *
  * When set, use this specific number of threads for the boot
  * allocation of hugepages.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch
scsi-lpfc-convert-timeouts-to-secs_to_jiffies-fix.patch
signal-avoid-clearing-tif_sigpending-in-recalc_sigpending-if-unset-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

