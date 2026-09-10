Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6BA4718E8
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789076615; cv=none; b=fUFt144141Dp0+jCIf2/V0wSdSE5Yfo89UqPpGlej8fznLcT+F73UJoWXNkw34Iz6jJyuArqRGtKXJ6H3ye+wlzPCB//43lcg9cUrJJ8KRHy6GiXCm3VFi8S7leFM28qX13vIUuzCGY8ixhX4/rKBZN9BUxbQJxico8CC6Bhabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789076615; c=relaxed/simple;
	bh=j6qO49xIfSZfjivsmM+PWVpRWFmi6Bt28We7VtLXjBk=;
	h=Date:To:From:Subject:Message-Id; b=BlS88g/cYjYkk1Y3kOJX0EuMk8sqjYcfh+LMs7pcWMfG9M8tD9Yy7AYDAFDDTXpFZ3dPW7KECmqejZ2YeHkx9vaHyc50lAtFbz2jMU22o9240Q8y0lOhlDHbVCAtfdFY4AWdcY+u3H+bNzixQ9TMdd7XjwxQfZZ9A8irC2CwtZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IwF36E+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IwF36E+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CBF1F000FF;
	Thu, 10 Sep 2026 21:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789076613;
	bh=qsIxoLtkOP6vBoQoPH9zj534qwSGX2+WepUIxp8PFJQ=;
	h=Date:To:From:Subject;
	b=IwF36E+OuFHOpu4WFghGq267kCVxAvYsQ7YsZ51QTa4OXTOq/1w2z6yb2w0pOPZvk
	 b7M/6k2+iK4Toum77iOAZghuaf7/hgR/SU702TtYnaHqJYIw0Ola74bEyhqQ+u5CYw
	 OyArurhNv7N/EHWK0j7wr/raOcSwuJFqStYoato4=
Date: Thu, 10 Sep 2026 14:43:33 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jsavitz@redhat.com,david@kernel.org,hi@tychen.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch added to mm-new branch
Message-Id: <20260910214333.A9CBF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: only prepare ptrace_scope when memfd_secret is selected
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch

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
From: Tianyi Chen <hi@tychen.cc>
Subject: selftests/mm: only prepare ptrace_scope when memfd_secret is selected
Date: Thu, 10 Sep 2026 20:56:45 +0800

The memfd_secret setup clears ptrace_scope whenever its test binary is
executable, even when a different category was selected.  run_test()
filters the test invocation, but it does not protect the preceding setup.

Check the category selection before entering the memfd_secret block so
running unrelated categories does not change ptrace_scope.  Keep the
existing executable check and the behavior when memfd_secret is selected.

Link: https://lore.kernel.org/20260910125645.285866-3-diannaaav@gmail.com
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="process_madv" run_test ./proce
 
 CATEGORY="vma_merge" run_test ./merge
 
-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
_

Patches currently in -mm which might be from hi@tychen.cc are

selftests-mm-reject-invalid-test-selections-before-running-tests.patch
selftests-mm-only-prepare-ptrace_scope-when-memfd_secret-is-selected.patch

