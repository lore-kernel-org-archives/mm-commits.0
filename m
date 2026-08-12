Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F334E49552D
	for <mm-commits@vger.kernel.org>; Wed, 12 Aug 2026 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575515; cv=none; b=B3r9v8UNC42gP2ybmpQ3D0irZ+nnwTw2NiVczOBbJ869uxMo07YCQbpvZTitQ/1G4MnxzYOzNZGpj/H1ZAQEsMZb3otbpS8jsQIr+T8pOYnvkY+Q0Kjmt3kF7JYYEueXtbDngLKjYxb7Nz9KM9KHV2BAEK8Jm3H8Tzmj7fUV/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575515; c=relaxed/simple;
	bh=PzRSxnFpu8MQpt19PvpxeowzVIY/4X1wrRIXkoDU9j4=;
	h=Date:To:From:Subject:Message-Id; b=dpP1fGbCHxk1M0Wc2Sjw11BBJ1nCDbsjuXGJZBbwEYFbXfEBkdotG6W0rcOloov0oo0+JzUxVCcyuTWpSevsgrfu7v/fTvoOO+88e8ZadP6ERM/wfV+c3tkTd803j6bnfMxNN6wCkyZa+wjuypd72QImUwoYpcLyPwBC1PCxAkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s+PGxAMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s+PGxAMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451BD1F000E9;
	Wed, 12 Aug 2026 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786575513;
	bh=njFMMnR9vGYFupYUbW/D/0m7MoPsS2snin/R5lL0TTY=;
	h=Date:To:From:Subject;
	b=s+PGxAMBnZhb0UYTtcUcraro89Brl+3ag6YX23fL/bBCo7JDE7c6vJModwo4OrNhY
	 MLzqvQ45sJKZ7JQjV7ZW+SLRAbG2WVn6cWitZ3pTt2anqPSpnqCeS3lGQnECMJ6+TR
	 zd835cHcwDZKeHetleTU0vmauZ9pc1py/1hXeRxg=
Date: Wed, 12 Aug 2026 15:58:32 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch added to mm-new branch
Message-Id: <20260812225833.451BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug
has been added to the -mm mm-new branch.  Its filename is
     lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: fix garbage pfn and wrong direction in devmem fault debug
Date: Wed, 12 Aug 2026 17:28:56 +0800

Move pr_debug() inside the `if (dpage)` block to avoid printing garbage
pfn for NULL dpage, and correct the direction label from "sys to dev" to
"dev to sys".

Link: https://lore.kernel.org/20260812092856.55296-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Assisted-by: Qoder:Qwen-3.8-MAX-Preview
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug
+++ a/lib/test_hmm.c
@@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_a
 		if (!dpage && !order)
 			return VM_FAULT_OOM;
 
-		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
-				page_to_pfn(spage), page_to_pfn(dpage));
-
 		if (dpage) {
+			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
+					page_to_pfn(spage), page_to_pfn(dpage));
 			lock_page(dpage);
 			*dst |= migrate_pfn(page_to_pfn(dpage));
 		}
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are

lib-test_hmm-fix-garbage-pfn-and-wrong-direction-in-devmem-fault-debug.patch

