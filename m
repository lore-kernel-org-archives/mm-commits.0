Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE62CA4
	for <mm-commits@vger.kernel.org>; Wed, 10 Jan 2024 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXwBgkAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D6EC433C7;
	Wed, 10 Jan 2024 05:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704864036;
	bh=fplhEFS3k1wdouFrTtX4n0qdGPEdojgbIP02noDfhDY=;
	h=Date:To:From:Subject:From;
	b=AXwBgkAi8Uhli6h++IWQvw45D4thA2OXtRaQOr7Fsxzz7NyBiMIjfhXloFZztf8ZF
	 0GigTR/x3WdWTW+zaIbAefHQBe7iNtKk0w8890TYpREKN5aNMTUGR6CRTmkc2PjoXi
	 yL0yLLCiKeHd+oSgQ4CorvWrBrEXHEiUCDNHlXig=
Date: Tue, 09 Jan 2024 21:20:35 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,mhocko@suse.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,anshuman.khandual@arm.com,aneesh.kumar@linux.ibm.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-sclp-remove-unhandled-memory-notifier-type.patch added to mm-unstable branch
Message-Id: <20240110052036.24D6EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/sclp: remove unhandled memory notifier type
has been added to the -mm mm-unstable branch.  Its filename is
     s390-sclp-remove-unhandled-memory-notifier-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-sclp-remove-unhandled-memory-notifier-type.patch

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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: s390/sclp: remove unhandled memory notifier type
Date: Mon, 8 Jan 2024 14:27:45 +0100

Remove memory notifier types which are unhandled by s390.  Unhandled
memory notifier types are covered by default case.

Link: https://lkml.kernel.org/r/20240108132747.3238763-4-sumanthk@linux.ibm.com
Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/sclp_cmd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/s390/char/sclp_cmd.c~s390-sclp-remove-unhandled-memory-notifier-type
+++ a/drivers/s390/char/sclp_cmd.c
@@ -340,9 +340,6 @@ static int sclp_mem_notifier(struct noti
 		if (contains_standby_increment(start, start + size))
 			rc = -EPERM;
 		break;
-	case MEM_ONLINE:
-	case MEM_CANCEL_OFFLINE:
-		break;
 	case MEM_GOING_ONLINE:
 		rc = sclp_mem_change_state(start, size, 1);
 		break;
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-memory_hotplug-introduce-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-mm-allocate-vmemmap-pages-from-self-contained-memory-range.patch
s390-sclp-remove-unhandled-memory-notifier-type.patch
s390-mm-implement-mem_prepare_online-mem_finish_offline-notifiers.patch
s390-enable-mhp_memmap_on_memory.patch

