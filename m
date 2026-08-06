Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50791387347
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786042013; cv=none; b=omW+R9w+xg0W5ZPRZ9EUBq0htvUUlEHj8GHom6bnQxG38xe3iqVXoznM2nbTNMlIkjnyr0fedWINzeeDjrSNQocIYJp9s++a6E8oNmpbL/rKfE6pFf/7IGH/tLL/SKTIIr+N1if2mpPnjXUDg0TJgnBnGRXsPtrF+D6IwpZoeaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786042013; c=relaxed/simple;
	bh=uVsHnQAXLqqrpZ/ROO+wrf4aKqJilG3VLZLKKnE++h8=;
	h=Date:To:From:Subject:Message-Id; b=LIx/umLpyGZK5GpVH1c0CC6Xa/MS3/VDuNF9talN/tyrhS5SSpn8kJtRZU+YEQCNxLlmsWWPWBQuyjETfCikJzz3Fhcw3OEcxqaIMU4/hBb7C27TwiQ1MK8NX4hPqMVkrQuaD6ndDDOW8H5AXL1fImUw+BR0qfEKToRETV9niGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DANqL6pJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DANqL6pJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E361F000E9;
	Thu,  6 Aug 2026 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786042012;
	bh=hRoqJ/gINodB2DQU0iJbMND2n+uY7Xdfu1Z1w+HwAa8=;
	h=Date:To:From:Subject;
	b=DANqL6pJiBq3/YJnfgVixJPr5CSXeQv5ozArfB8byNjZYhB29W51V814aJAbcaXNa
	 igdvLupRi0k0o9xYH7ky1hZczpbFJzZsFcb7q2yOdi6Bgf8zCcbl30xuv0nOacsLBf
	 xuLyfXIvaOOziyr8Qxfyk4XUv/y7JD4DoLor1Azg=
Date: Thu, 06 Aug 2026 11:46:51 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,audra@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch added to mm-new branch
Message-Id: <20260806184652.06E361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
Date: Thu Aug  6 11:43:11 AM PDT 2026

remove comment, per Sashiko

Link: https://sashiko.dev/#/patchset/20260806181843.1839943-2-audra@redhat.com
Cc: Audra Mitchell <audra@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-fix-soft-dirty-kselftest-supported-check-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -68,7 +68,6 @@ static uint64_t pagemap_scan_get_categor
 	return r.categories;
 }
 
-/* `start` is any valid address. */
 static bool pagemap_scan_supported(int fd)
 {
 	const size_t pagesize = getpagesize();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

