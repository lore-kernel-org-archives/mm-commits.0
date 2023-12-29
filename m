Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011613FF7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LfHwu/EK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CACC433C8;
	Fri, 29 Dec 2023 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880062;
	bh=Lu4+er9IiNskEeIFpBFsAMvuCoQRkQltEB1dL4Qgsqo=;
	h=Date:To:From:Subject:From;
	b=LfHwu/EKJugq4xK9sEqHOQfW3MXnjRdhWumLVBZI2Vud0HgAqE2+LoKsUFC3Ohzb8
	 sooqEWqUbCMnKEP6Sm5CBnSFcpue4+YqS899Fyv2Kz5P2+i33KJw2yIJX3kURBRghl
	 O0tseX976J86G4HPiPfIczq3EZaYJyCiFMWHJ4q0=
Date: Fri, 29 Dec 2023 12:01:01 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-redundant-try_to_freeze.patch removed from -mm tree
Message-Id: <20231229200102.28CACC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove redundant try_to_freeze()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-redundant-try_to_freeze.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: mm/khugepaged: remove redundant try_to_freeze()
Date: Wed, 20 Dec 2023 07:17:53 +0800

A freezable kernel thread can enter frozen state during freezing by either
calling try_to_freeze() or using wait_event_freezable() and its variants. 
However, there is no need to use both methods simultaneously.  The
freezable wait variants have been used in khugepaged_wait_work() and
khugepaged_alloc_sleep(), so remove this redundant try_to_freeze().

I used the following stress-ng command to generate some memory load on my
Intel Alder Lake board (24 CPUs, 32G memory).

	stress-ng --vm 48 --vm-bytes 90%

The worst freezing latency is:
  Freezing user space processes                     
  Freezing user space processes completed (elapsed 0.040 seconds)    
  OOM killer disabled.    
  Freezing remaining freezable tasks    
  Freezing remaining freezable tasks completed (elapsed 0.001 seconds)

Without the faked memory load, the freezing latency is:
  Freezing user space processes
  Freezing user space processes completed (elapsed 0.000 seconds)
  OOM killer disabled.
  Freezing remaining freezable tasks
  Freezing remaining freezable tasks completed (elapsed 0.001 seconds)

I didn't see any observable difference whether this patch is applied or not.

Link: https://lkml.kernel.org/r/20231219231753.683171-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-try_to_freeze
+++ a/mm/khugepaged.c
@@ -2499,7 +2499,7 @@ static void khugepaged_do_scan(struct co
 	while (true) {
 		cond_resched();
 
-		if (unlikely(kthread_should_stop() || try_to_freeze()))
+		if (unlikely(kthread_should_stop()))
 			break;
 
 		spin_lock(&khugepaged_mm_lock);
_

Patches currently in -mm which might be from haokexin@gmail.com are

nilfs2-add-missing-set_freezable-for-freezable-kthread.patch

