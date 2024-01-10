Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8784DDA1
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayJY8YEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B61AC433F1;
	Wed, 10 Jan 2024 05:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704865057;
	bh=tsUmOoni75d1IOSQdpBrhWOPFnsSKgW6g1S6odZxKJE=;
	h=Date:To:From:Subject:From;
	b=ayJY8YEXGUYLqnzOUbcrC13ltCyNBaU2QDS9B8mRbE5L2/uN5TyWFMs67OBbSEA/F
	 XztbgvKM+z7WoA6ZJYyKbNBduqe1y1qhi72epED2vCWJs0T31RB2FN0H64JMBGVpQ3
	 MT3malGpMeDwMZP2fvsYnBNRovV85FfdBANJiNZs=
Date: Tue, 09 Jan 2024 21:37:36 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-crash_corec-make-__crash_hotplug_lock-static.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110053737.2B61AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/crash_core.c: make __crash_hotplug_lock static
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kernel-crash_corec-make-__crash_hotplug_lock-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-crash_corec-make-__crash_hotplug_lock-static.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/crash_core.c: make __crash_hotplug_lock static
Date: Tue Jan  9 09:35:21 PM PST 2024

sparse warnings:
kernel/crash_core.c:749:1: sparse: sparse: symbol '__crash_hotplug_lock' was not declared. Should it be static?

Fixes: e2a8f20dd8e ("Crash: add lock to serialize crash hotplug handling")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401080654.IjjU5oK7-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/crash_core.c~kernel-crash_corec-make-__crash_hotplug_lock-static
+++ a/kernel/crash_core.c
@@ -877,7 +877,7 @@ subsys_initcall(crash_notes_memory_init)
  * regions are online. So mutex lock  __crash_hotplug_lock is used to
  * serialize the crash hotplug handling specifically.
  */
-DEFINE_MUTEX(__crash_hotplug_lock);
+static DEFINE_MUTEX(__crash_hotplug_lock);
 #define crash_hotplug_lock() mutex_lock(&__crash_hotplug_lock)
 #define crash_hotplug_unlock() mutex_unlock(&__crash_hotplug_lock)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-proc-task_mmu-move-mmu-notification-mechanism-inside-mm-lock-fix.patch
kernel-crash_corec-make-__crash_hotplug_lock-static.patch

