Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF8E2C0303
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788196711; cv=none; b=sZkFDNKhYiPGEHLE/xWOo4ayTU/uAp961ZxTSYKgTTc2fXgd+PK7U8bCWPtKigTOpJYHBEOEMuRskHC8PVvL4yefc6aCo5VJr7MBmh+cdOdQzstSizP6CM4B5hcjaCiaCLr5LBk3k/NZuBGYoqA+v5v090funurbdBpeO6wqa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788196711; c=relaxed/simple;
	bh=rOA6Evv7l4uWG/cN5Do6EptarYDK10MvZbE7cSZN+gc=;
	h=Date:To:From:Subject:Message-Id; b=H5Cj4x1yk2A0oCpGqrjEx9S+MUW0p4/+7tNZASElCwL7AgLu4kr1rlaZBuWvwIPcHbLPNGV26atTvRm5jZD5GuzzTJmeCjlCvSBKWnxy6lf/wdb1BRAqtVzkG73Cdbd9tc2P+rOWtt08TX+Le38JQQ6NrDA9isG//zXWlmBbwnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G4JBh9Ag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G4JBh9Ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ED71F000E9;
	Mon, 31 Aug 2026 17:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788196710;
	bh=8uxfzh7+fOQoM2Xga5aYHvEd2wpDN0MBKlQZyw3/uhg=;
	h=Date:To:From:Subject;
	b=G4JBh9AgPfYtIYRiQs14/bsdSe1g+YYJis6Td7uZZWYQjDeVnQLEqhAZF/ONIZpxW
	 tJGUoxetaedYsrkLnYnIKOYCCEqNHLTUgPTtxYTVaMl7vC47mlPoZ2tn2w1bPFYTQx
	 6zk9naEXJu5o7G5Rk0NYgdShkgLIX4NQeydUdUBA=
Date: Mon, 31 Aug 2026 10:18:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,liam@infradead.org,david@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-selftests-mm-add-missing-gitignore-entries.patch added to mm-new branch
Message-Id: <20260831171830.00ED71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/selftests/mm: add missing .gitignore entries
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-selftests-mm-add-missing-gitignore-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-selftests-mm-add-missing-gitignore-entries.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: tools/testing/selftests/mm: add missing .gitignore entries
Date: Mon, 31 Aug 2026 15:18:23 +0100

Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
switched to a pattern-matching mechanism to reduce churn in .gitignore.

It however accidentally excluded the page_frag test's-generated module
intermediate C file with .mod.c extension, and also the local_config.h
header generated if liburing is available locally.

Explicitly fix both the issues, fixing the module-generated C file as a
general pattern as these are always intermediate files that should be
ignored.

Since this is a trivial .gitignore change it doesn't seem necessary to
treat it as a hotfix.

Link: https://lore.kernel.org/20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~tools-testing-selftests-mm-add-missing-gitignore-entries
+++ a/tools/testing/selftests/mm/.gitignore
@@ -2,7 +2,9 @@
 *
 !/**/
 !*.c
+*.mod.c
 !*.h
+local_config.h
 !*.sh
 !.gitignore
 !Makefile
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-reset-unfaulted-vma-page-offset-for-mremap_dontunmap.patch
mm-secretmem-properly-account-locked-pages.patch
mm-huge_memory-bypass-thp-tuneables-for-huge-pfnmap-mappings.patch
mm-mremap-account-mm-locked_vm-correctly-for-mremap_dontunmap.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch

