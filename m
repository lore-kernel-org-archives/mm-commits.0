Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F61922063
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H2dKM2cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15E6C433C7;
	Wed, 13 Dec 2023 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702491189;
	bh=Ri7e2rudmUAatvcFiUfWtE5+3nTleo7POCDI68R4LcQ=;
	h=Date:To:From:Subject:From;
	b=H2dKM2cRV4SOPq0/K68sD/4vaCxXNEnYFHN4jMWdMI9j0Xmytnr9vEXE7yWC002BE
	 KMLYvONEaroW5okhI8daq6Rrcm5P1hsNqp9d8bKgVdXOYS3T4Uc/BI2nGZgDCnAFJx
	 7lb+QSMhFWyuNaGSwftm3uXLd92lvKC0m/tCBpVI=
Date: Wed, 13 Dec 2023 10:13:04 -0800
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,david@redhat.com,aarcange@redhat.com,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-remove-unnecessary-try_to_freeze.patch added to mm-unstable branch
Message-Id: <20231213181309.C15E6C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ksm: remove unnecessary try_to_freeze()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-remove-unnecessary-try_to_freeze.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-remove-unnecessary-try_to_freeze.patch

This patch will later appear in the mm-unstable branch at
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
From: Kevin Hao <haokexin@gmail.com>
Subject: mm: ksm: remove unnecessary try_to_freeze()
Date: Wed, 13 Dec 2023 17:09:06 +0800

A freezable kernel thread can enter frozen state during freezing by
either calling try_to_freeze() or using wait_event_freezable() and its
variants. However, there is no need to use both methods simultaneously.

Link: https://lkml.kernel.org/r/20231213090906.1070985-1-haokexin@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-remove-unnecessary-try_to_freeze
+++ a/mm/ksm.c
@@ -2604,11 +2604,9 @@ static int ksm_scan_thread(void *nothing
 			ksm_do_scan(ksm_thread_pages_to_scan);
 		mutex_unlock(&ksm_thread_mutex);
 
-		try_to_freeze();
-
 		if (ksmd_should_run()) {
 			sleep_ms = READ_ONCE(ksm_thread_sleep_millisecs);
-			wait_event_interruptible_timeout(ksm_iter_wait,
+			wait_event_freezable_timeout(ksm_iter_wait,
 				sleep_ms != READ_ONCE(ksm_thread_sleep_millisecs),
 				msecs_to_jiffies(sleep_ms));
 		} else {
_

Patches currently in -mm which might be from haokexin@gmail.com are

mm-ksm-remove-unnecessary-try_to_freeze.patch
fork-remove-redundant-task_uninterruptible.patch

