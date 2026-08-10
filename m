Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD94535C6B1
	for <mm-commits@vger.kernel.org>; Mon, 10 Aug 2026 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786402110; cv=none; b=IA40PhTmVgQ2qc//Ek3X3q35YYgwRXzFdumWzDXSlzV5ZJp5i1JnxNU1q7fJRMq9viCGqFb272oL3dgw5vjHSJi9HuhnhcqLqmP8/bcrz/B7Gmx6gJSGn6nHZgIp8ZgiEk9NBfeWg4ovCX+5o64iTys0xEKn4k3YgPr9R+wBwh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786402110; c=relaxed/simple;
	bh=ZDyPwWz1eW5p02z6ClyE75dUu1x0MJpNtNqJEoCRb/c=;
	h=Date:To:From:Subject:Message-Id; b=nJ39mTE22wE9CcST4wv/unZvYlShMtV7xMrpk+qBNRVprzRyNJdPdizEhIlLNA8cRTadmBYu0/IzYSmbq30YSFeFxJ8UR1cxhuKBw5kWCz/xkIn1QC4KyI5kIXa5K4zAQad4I9IwExcKKcS6ulKOR6yhOdUYMpbV61IcKiOG4IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FQOYMKvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FQOYMKvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C22E1F000E9;
	Mon, 10 Aug 2026 22:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786402108;
	bh=JlI8jMrGYXxk1NPbNKQHbxnLT0ziEha+Bht9CEdIef8=;
	h=Date:To:From:Subject;
	b=FQOYMKvXdWe02IWZ43K9WbY8k932ZmJCemEztexfei/5PkS7ajMhQLLlEe/VUYQSF
	 kQOv4mIY4eChY/9kuX4kMMTFCHEYERBnA7nOMJ4jTVFQFzR+PXrQPBQOvmJNd10Bt+
	 iF2Hi6DOh38eloWsVN3F5WJIPjSJjfD861Gw6ZY0=
Date: Mon, 10 Aug 2026 15:48:27 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,liam@infradead.org,jannh@google.com,adobriyan@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch added to mm-new branch
Message-Id: <20260810224828.4C22E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
has been added to the -mm mm-new branch.  Its filename is
     selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch

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
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
Date: Sat, 8 Aug 2026 22:03:12 +0200

test_maps_tearing_from_split times out when READ_IMPLIES_EXEC is set. 
This happens by default on pre-ARMv6 CPUs, which lack no-execute support.

split_vma() re-maps the first page with mod_info->prot | PROT_EXEC to make
it differ from its neighbours.  With READ_IMPLIES_EXEC the original
mapping is already executable, so no split occurs and the test hangs
waiting for the modifier child.

Use PROT_NONE for the split mapping, which always differs from its
readable neighbours.

Link: https://lore.kernel.org/20260808200312.6326-1-kmehltretter@gmail.com
Fixes: beb69e817246 ("selftests/proc: add /proc/pid/maps tearing from vma split test")
Assisted-by: Codex:gpt-5.6-terra
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-make-proc-maps-race-work-with-read_implies_exec
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -490,7 +490,8 @@ static bool query_addr_at(int maps_fd, v
 
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
-	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
+	/* PROT_NONE differs from both readable neighbors. */
+	return mmap(self->mod_info->addr, self->page_size, PROT_NONE,
 		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) != MAP_FAILED;
 }
 
_

Patches currently in -mm which might be from kmehltretter@gmail.com are

selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch
lib-interval_tree-fix-allocation-warning-messages.patch

