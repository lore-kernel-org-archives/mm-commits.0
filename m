Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B912156669
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 19:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724874615; cv=none; b=dF0EDWz7PgsEB+dZ8UyT8NvMGyiT5qPlbojI7JNkYgrIk3wSVzLgAR46lmWMpF4jhuJ+MNuGiA2cv/14Ih6HlgvRmJWZMaaZRQPd2ZsbFLargi6d6GxU6pb+VGx8/XF+dFzzEBta96tg2rjnsN/UX0X52/IQ4+a294VWfUlvlXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724874615; c=relaxed/simple;
	bh=ojhR3FsIAISE3ayjRgHlcB/Oba4nuWTJGZxCV1Q5bQs=;
	h=Date:To:From:Subject:Message-Id; b=MVPMrb4AEyqw6UCIE0+944wcDJM1Hx/J5USti1wEuZrbpk+z90a6owvYxJtxKONZkz8Y5HBiaBug5rOTkT17u7nbWDrk0winFDcdsgesLSPuHm/Zods4XjYv9U/1ZE5xtRSm6H7xV7ey4pDCZc1EZ4RtFYburCiW5Q/ZfWcEp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E6EtCoC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E6EtCoC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09D9C4CEC1;
	Wed, 28 Aug 2024 19:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724874615;
	bh=ojhR3FsIAISE3ayjRgHlcB/Oba4nuWTJGZxCV1Q5bQs=;
	h=Date:To:From:Subject:From;
	b=E6EtCoC4BqkJzhAmA0MBceNYIeCfR1D0YQzVYE3JbCuv1I5p22WEsSOUwWycT7ROt
	 S/+aKBQx0k4Qu+otBpCU1T73iYoxkP3VzhMPXNczov/xWMVZCAjnDfwrc3xfSgj4wR
	 CRlShr4NqtdXG/yLtG75zP1QqjeXArVcOGmn5AZg=
Date: Wed, 28 Aug 2024 12:50:14 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,dave@stgolabs.net,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-sort-out-global-lock-annotations.patch added to mm-unstable branch
Message-Id: <20240828195014.E09D9C4CEC1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: sort out global lock annotations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-sort-out-global-lock-annotations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-sort-out-global-lock-annotations.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm/hugetlb: sort out global lock annotations
Date: Wed, 28 Aug 2024 18:07:04 +0200

The mutex array pointer shares a cacheline with the spinlock:
ffffffff84187480 B hugetlb_fault_mutex_table
ffffffff84187488 B hugetlb_lock

This is because the former is annotated with a macro forcing cacheline
alignment.  I suspect it was meant to be the variant which on top of it
makes sure the object does not share the cacheline with anyone.

Since array pointer itself is de facto read-only such an annotation does
not make sense there anyway.  Instead mark it __ro_after_init along with
the size var.

Do however move the spinlock out of the way.

Link: https://lkml.kernel.org/r/20240828160704.1425767-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-sort-out-global-lock-annotations
+++ a/mm/hugetlb.c
@@ -72,14 +72,14 @@ static unsigned int default_hugepages_in
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
  * free_huge_pages, and surplus_huge_pages.
  */
-DEFINE_SPINLOCK(hugetlb_lock);
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
  * Serializes faults on the same logical page.  This is used to
  * prevent spurious OOMs when the hugepage pool is fully utilized.
  */
-static int num_fault_mutexes;
-struct mutex *hugetlb_fault_mutex_table ____cacheline_aligned_in_smp;
+static __ro_after_init int num_fault_mutexes;
+__ro_after_init struct mutex *hugetlb_fault_mutex_table;
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
_

Patches currently in -mm which might be from mjguzik@gmail.com are

mm-hugetlb-sort-out-global-lock-annotations.patch
ratelimit-convert-flags-to-int-to-save-8-bytes-in-size.patch

