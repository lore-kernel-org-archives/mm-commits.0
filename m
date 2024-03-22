Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758EB628
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711068921; cv=none; b=OIPzPZ6dgYOXkGLsFl6suPFDRUI96NsPV1ZlKyo9LxUWpAre7rE3S/oOAkiCCJFfhvroWIyy/KCVCuyc4Le2+FmhONr+oWTvvinxi+fzqwEM+DtLyGQO4TKNv3uXA2WD3svVBeB9e7PeP9rNOMo8XBTS8iDdfwu8HV23iLhEB+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711068921; c=relaxed/simple;
	bh=TSyD3qvPCZNzDd3WQthe51sIJyspWMjPYRCLzJ+uu9Q=;
	h=Date:To:From:Subject:Message-Id; b=AhdbNrtCvL1gTslwazYvbJfwekI/m/PcPZA1OKV7g8je12Y4j4nx8Mz4X7huVVa/pYWLSEoumr4f4RjaYb8uF77CNKQntmtsEdN/O7sdtUzauHZH8j07mncdlgLsnyU1lZ7t3fVy6oyMrrPQi2zBGrDldFP71AQBi2KXRfeEPSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKfWx7IT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKfWx7IT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A7C433C7;
	Fri, 22 Mar 2024 00:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711068921;
	bh=TSyD3qvPCZNzDd3WQthe51sIJyspWMjPYRCLzJ+uu9Q=;
	h=Date:To:From:Subject:From;
	b=GKfWx7ITekuC7EyZdxnnw5XC42njRn8c5p/D5Ct2plzroPOpP0ejG9VrUeewRWSo5
	 5zRh1iiY+PNsxnIeeWADFRteof0I4zn7T5hEPUctfTTgtrOPbOVutC2X7FCl9qaAay
	 AdGYF0HOy/paeTRpQNDQJU2yQ1sLbtBpA48CNpx0=
Date: Thu, 21 Mar 2024 17:55:20 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-compact-kmemleak_object-further.patch added to mm-unstable branch
Message-Id: <20240322005520.E45A7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: compact kmemleak_object further
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-compact-kmemleak_object-further.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-compact-kmemleak_object-further.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm/kmemleak: compact kmemleak_object further
Date: Thu, 7 Mar 2024 14:05:47 -0500

Patch series "mm/kmemleak: Minor cleanup & performance tuning".

This series contains 2 simple cleanup patches to slightly reduce memory
and performance overhead.


This patch (of 2):

With commit 56a61617dd22 ("mm: use stack_depot for recording kmemleak's
backtrace"), the size of kmemleak_object has been reduced by 128 bytes for
64-bit arches.  The replacement "depot_stack_handle_t trace_handle" is
actually just 4 bytes long leaving a hole of 4 bytes.  By moving up
trace_handle to another existing 4-byte hold, we can save 8 more bytes
from kmemleak_object reducing its overall size from 248 to 240 bytes.

Link: https://lkml.kernel.org/r/20240307190548.963626-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20240307190548.963626-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-compact-kmemleak_object-further
+++ a/mm/kmemleak.c
@@ -158,9 +158,9 @@ struct kmemleak_object {
 	int count;
 	/* checksum for detecting modified objects */
 	u32 checksum;
+	depot_stack_handle_t trace_handle;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
-	depot_stack_handle_t trace_handle;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
_

Patches currently in -mm which might be from longman@redhat.com are

mm-kmemleak-compact-kmemleak_object-further.patch
mm-kmemleak-disable-kasan-instrumentation-in-kmemleak.patch

