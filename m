Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD524C6D
	for <mm-commits@vger.kernel.org>; Fri, 25 Apr 2025 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540306; cv=none; b=U+nying1xa6WU2OFDvas4SQ6cd8EfbPI+B5vjUTHfRh/cfrwpoWCYa14TYMQi4SevvbfpvHdqr3pYBbczjeTiVah6y8pzIWqsch7VZ6o8Rp0yrttc2tOByrU2MgwP868+Y/8aOMeZ1Ht8Q6dLIHpd0WlCS9z8GUfqU3jVpx4+W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540306; c=relaxed/simple;
	bh=78haEhMkPTB7VnCH1OsFu4Gv6E7/dIdiMkZOvEk/AUw=;
	h=Date:To:From:Subject:Message-Id; b=FA0KqsDQz51vVXkVeD4UGH9nV8ErJEsMKt6n5d/Gi0sR6hzdk5/p9AIBVprfwog70NTR4E7mNnWYV3oA/y7gzAxBntovs4vtFkqj63TUJY01kZDGqde3DXUn61kAfh7a4aBqVomUidHAofyPMHBlt+vdGNAvTHBMkhkHKuGJoWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Owns96IG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Owns96IG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A869C4CEE3;
	Fri, 25 Apr 2025 00:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745540306;
	bh=78haEhMkPTB7VnCH1OsFu4Gv6E7/dIdiMkZOvEk/AUw=;
	h=Date:To:From:Subject:From;
	b=Owns96IGUKNTv+CUvWapKlpunE4L2AyiKgjCXdl4FuyUnL1MTVryNA3ThmufVEOQy
	 O9KEzFj9/aUyefsTV3xKM5yjM15zC4fAVwY7kBOhLE82jW5YCowt5YYnICol+28vtq
	 Jh4h1TzF8N/HAHCEtjvzDCklrUfsaBBaO7njTBT8=
Date: Thu, 24 Apr 2025 17:18:25 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20250425001826.0A869C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
Date: Thu Apr 24 05:15:43 PM PDT 2025

WARNING: do not add new typedefs
#86: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1284:
+typedef enum {

WARNING: braces {} are not necessary for single statement blocks
#106: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1304:
+	if (!fp) {
+		return THR_STATE_UNKNOWN;
+	}

WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
#135: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1333:
+	volatile pid_t *pid = opaque;

ERROR: trailing statements should be on next line
#154: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1352:
+	while (uffd_read_msg(fd, &msg));

WARNING: Use of volatile is usually wrong: see Documentation/process/volatile-considered-harmful.rst
#180: FILE: tools/testing/selftests/mm/uffd-unit-tests.c:1378:
+	while (!(volatile pid_t)pid)

total: 1 errors, 4 warnings, 215 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1301,9 +1301,8 @@ static thread_state thread_state_get(pid
 	snprintf(tmp, sizeof(tmp), "/proc/%d/status", tid);
 	fp = fopen(tmp, "r");
 
-	if (!fp) {
+	if (!fp)
 		return THR_STATE_UNKNOWN;
-	}
 
 	while (fgets(tmp, sizeof(tmp), fp)) {
 		p = strstr(tmp, header);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

x86-disable-image-size-check-for-test-builds-fix.patch
x86-disable-image-size-check-for-test-builds-fix-fix.patch
mm-debug-fix-parameter-passed-to-page_mapcount_is_type-fix.patch
vmalloc-switch-to-for_each_vmap_node-helper-fix.patch
mm-add-zblock-allocator-fix.patch
mm-selftests-add-a-test-to-verify-mmap_changing-race-with-eagain-checkpatch-fixes.patch
compiler_typesh-fix-unused-variable-in-__compiletime_assert-fix.patch

