Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC794253340
	for <mm-commits@vger.kernel.org>; Fri,  2 Oct 2026 01:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790904950; cv=none; b=Ef5n7Lst7FmiupLhIhrYMZhCsuegB/hdm0LbUSYEZ6mxVkAXNAB07NtHA+SUDMvMF/M/J0RG+vZRlCs4mb9z5mD0J1SvFwVVw5e5Q5nXB/uz1Q0ry3fSGcYKW3rv8DCS2Pdn75wNaX1HrpYIKs2osp/cBcQ4Re4WtE7eiz5CszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790904950; c=relaxed/simple;
	bh=bhwhZCaIkp5cGxtGp7f5TtKIy9IZD58ur7cDFMR14Lw=;
	h=Date:To:From:Subject:Message-Id; b=UqS/j2/i+Wkb9cJiJIXGiUWr2eHHbhNx17ab20QrGA+cpGWPynReDV3OJaQYXR8JuUy6Oe9UvZ0l1cS33EhQHpyJbQjZjk+8N+glcluKB5bmv7THR1pnP/PzaOLudNeZ6GjzKDQ32AxBtQtW5LH79caV5vr2vIUe+a+maKGBMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S77kFcT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S77kFcT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142111F000FF;
	Fri,  2 Oct 2026 01:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790904949;
	bh=esI48ncZX2SCuV9zNSJjZoLcyZhQGX/U0H8kozGq7qE=;
	h=Date:To:From:Subject;
	b=S77kFcT1n71ZO0rQo9+uCWjVKVkowQMLvT4s8pkLrl4u7+F/ETSpj43S7RtwMXPvT
	 UhcWWI5ky86xs3gl1Wh7MNK2Dw93YX+v8sSg/MrzHrdCDzzbSiWJJ6PKc3yfqm3fUg
	 6zoWmk9srwY055Zb0SYip92UDxfrwQrP1d+RDm2Y=
Date: Thu, 01 Oct 2026 18:35:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brauner@kernel.org,jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mrelease_test-fix-retry-limit.patch added to mm-new branch
Message-Id: <20261002013549.142111F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mrelease_test: fix retry limit
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mrelease_test-fix-retry-limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mrelease_test-fix-retry-limit.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: selftests/mm: mrelease_test: fix retry limit
Date: Wed, 30 Sep 2026 23:00:27 -0700

mrelease_test doubles the child allocation when process_mrelease() returns
ESRCH.

When size is already MAX_SIZE_MB, the current <= check still allows
another retry, causing the allocation to grow from 1024 MB to 2048 MB.

Use < instead of <= so the largest allocation attempted remains
MAX_SIZE_MB.

LLM used in discovering bug. Changes were made and reviewed manually.

Link: https://lore.kernel.org/CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com
Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Assisted-by: LLM
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
---

 tools/testing/selftests/mm/mrelease_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mrelease_test.c~selftests-mm-mrelease_test-fix-retry-limit
+++ a/tools/testing/selftests/mm/mrelease_test.c
@@ -157,7 +157,7 @@ retry:
 		 * Retry until we succeed or reach MAX_SIZE_MB.
 		 */
 		if (errno == ESRCH) {
-			retry = (size <= MAX_SIZE_MB);
+			retry = (size < MAX_SIZE_MB);
 		} else {
 			waitpid(pid, NULL, 0);
 			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));
_

Patches currently in -mm which might be from jm5905938@gmail.com are

selftests-mm-mrelease_test-fix-retry-limit.patch

