Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF1431F99E;
	Mon,  8 Jun 2026 16:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780936278; cv=none; b=beRbC9azEZrst5mcNpkDlqBPTBVJarWBOQLJwNNYw6GfLWOwEQ41D52jFWx09YDWgWjs+DeakvH2sv6p95s3bwYa7i4p82qifKGTAZ92M4hZ57nyrsmVRJtkPM5d2POVSEIWOAej6/f4EZ6s2RLPYOY3k/0gVPj/vNSx+73ruSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780936278; c=relaxed/simple;
	bh=Rd9+btsUaAidkBHZIaDCVeSDsLokVTwlRat/LTxA+v4=;
	h=Date:To:From:Subject:Message-Id; b=fr7DZF46T8hKrCIekTEOhxxlRpUKxJXFSnHvEEwN2Af1hn3UeZX3DM1tZ82uywsztECtRz68jz+m9TOBR8r4J6m/ffYNMm40+kTLZLExUVmQjy4UVi7R3Y4NVazg4fhBBaGc4W/Tr1lqEjsyoP5R0RxPb7xWLO5XBO9CjFQFqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmomYNyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmomYNyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDD31F00893;
	Mon,  8 Jun 2026 16:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780936277;
	bh=Pbs4eHBg+r+hn0+WfQsR7Q0SkmrhxXELbe39qk49isI=;
	h=Date:To:From:Subject;
	b=OmomYNyJqor+v+Vf2vISxvLRbHzdrATNE18CeaNdSyehMQj8mUmngsiSFF/dLoKZO
	 u9WqtFz8EBGurEkk0lSvgkMtoTvpe8/brYOl+2JdEqc7LzOomJEcIrJctH5HkbdMn7
	 ilHtCbz/7YaBU5V5RROYLye0SKVy0cELgUCz1nsw=
Date: Mon, 08 Jun 2026 09:31:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,sarthak.sharma@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-ksft_process_madvsh-test-category.patch added to mm-hotfixes-unstable branch
Message-Id: <20260608163117.3EDD31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix ksft_process_madv.sh test category
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-fix-ksft_process_madvsh-test-category.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-ksft_process_madvsh-test-category.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Sarthak Sharma <sarthak.sharma@arm.com>
Subject: selftests/mm: fix ksft_process_madv.sh test category
Date: Mon, 8 Jun 2026 16:02:24 +0530

ksft_process_madv.sh currently runs run_vmtests.sh with the mmap category.
Update it to run the process_madv category, since ksft_mmap.sh already
runs the mmap category tests.

This avoids running mmap tests twice and ensures that process_madv tests
are run through the kselftest harness.

Link: https://lore.kernel.org/20260608103224.344101-1-sarthak.sharma@arm.com
Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksft_process_madv.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/ksft_process_madv.sh~selftests-mm-fix-ksft_process_madvsh-test-category
+++ a/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -1,4 +1,4 @@
 #!/bin/sh -e
 # SPDX-License-Identifier: GPL-2.0
 
-./run_vmtests.sh -t mmap
+./run_vmtests.sh -t process_madv
_

Patches currently in -mm which might be from sarthak.sharma@arm.com are

selftests-mm-fix-ksft_process_madvsh-test-category.patch

