Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571C343D69;
	Wed, 26 Nov 2025 17:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764178873; cv=none; b=IuOkC9y6Zf4hw0svdhcro2Aui43Z0R68B3qujUuVMzaHNL/WFolPqzGcP/fYKDwAal/5osTf79fHpVyR/j2wSuYVE9Za6z63xTXoUdo0eKZLOOJpE9S6QiwkuS22rOelSHc2L/RHDouBnyOT9G364vrpyRGg9daB0ozWXUbGrFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764178873; c=relaxed/simple;
	bh=B5/NUsS1hRDbA3SQYs7Nk8W86dErGoNGiBq8L60RbMc=;
	h=Date:To:From:Subject:Message-Id; b=C1jUhJNVU+WZ8XdWpNA0ooFcWP7BxrnXKxkP+U/Zy73SWjD9KPFHd/04jHKddhYpMlJyQChwqWdOsFCyzEywIC9jM5ioT99PHNR2x3LIcK7n6NAouRdPVA5CJm/3cvFYPXgVBwOGAUoMP4r3/9q9urioPAGctBE2MnHSxy8LF+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JxUQJqf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JxUQJqf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53CCC4CEF7;
	Wed, 26 Nov 2025 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764178872;
	bh=B5/NUsS1hRDbA3SQYs7Nk8W86dErGoNGiBq8L60RbMc=;
	h=Date:To:From:Subject:From;
	b=JxUQJqf1/LECd2rWA0Deh/mOTaHaOR21hrathcc44DiHHDCbLPvSsXr+/v/woSwZo
	 5KSw/NU837cMNnEwqAYbC6/pG7wtQSmxFKqnLUlD5woMllruoBWuqEskFCYMUV9bhN
	 HNA3OPYM4eYX3a7GW8GGl4yslHsS07McfrMLYvTo=
Date: Wed, 26 Nov 2025 09:41:12 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch added to mm-new branch
Message-Id: <20251126174112.D53CCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
has been added to the -mm mm-new branch.  Its filename is
     powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages
Date: Tue, 21 Oct 2025 12:06:06 +0200

Let's properly adjust BALLOON_MIGRATE like the other drivers.

Note that the INFLATE/DEFLATE events are triggered from the core when
enqueueing/dequeueing pages.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251021100606.148294-3-david@redhat.com
Fixes: fe030c9b85e6 ("powerpc/pseries/cmm: Implement balloon compaction")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/cmm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/pseries/cmm.c~powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages
+++ a/arch/powerpc/platforms/pseries/cmm.c
@@ -532,6 +532,7 @@ static int cmm_migratepage(struct balloo
 
 	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 	balloon_page_insert(b_dev_info, newpage);
+	__count_vm_event(BALLOON_MIGRATE);
 	b_dev_info->isolated_pages--;
 	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
 
_

Patches currently in -mm which might be from david@redhat.com are

powerpc-pseries-cmm-call-balloon_devinfo_init-also-without-config_balloon_compaction.patch
powerpc-pseries-cmm-adjust-balloon_migrate-when-migrating-pages.patch

