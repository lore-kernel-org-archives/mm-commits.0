Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FA037EFE9
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774639822; cv=none; b=oTk+kMsPgqVf8KzSCotURZttMiuXM//3PFYh6yE3c0dzIokvVEG4DaejV3WH3O7O6kbPkIT5b28AgK+w1DONBYTtwOBWZDodUjzkb6og+NxEOaE4KxAxCnWyrDIpCidUAkoIw93c4WFZczPBNAUN9ZjqqdKFsL4ca+Kw2q0Ns8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774639822; c=relaxed/simple;
	bh=feFbMxTNQa85vGA9w98BfH1RH5vJP30ZtHvXVse8OgY=;
	h=Date:To:From:Subject:Message-Id; b=AeTu9uz4CXo977nJUTUUwo1s+9b9E9GhbuwM2wuxfbthmWoE+UD4pCUlZGJTCJ9XHaNVjTVLJpVsKth2uK0T35mMMqi4DcWlhTi0kyKrInUN9ZsbIAqOtbTE8GsmwX7Ni3tJ2RhyAHy3JzqJJAwBT21wU9pxFxSRF7qk4P10oCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nV+VrVMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nV+VrVMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A57C19423;
	Fri, 27 Mar 2026 19:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774639821;
	bh=feFbMxTNQa85vGA9w98BfH1RH5vJP30ZtHvXVse8OgY=;
	h=Date:To:From:Subject:From;
	b=nV+VrVMtaKKItR3k5LGJ+WnVb+BAvhEt0rlcmtk5lFewjMJqE0LgzCIW1CMtK1xXg
	 BmA/T6UuNSGbVC0+9hoTKR3LwnX8GU9G6CrKIWOGVB554dRFYfrbP4pwJpmxUEZ/MS
	 ZCY0RCnulcvGLvGyOR+hxXQyOrYUPOjlfmB8stjw=
Date: Fri, 27 Mar 2026 12:30:21 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-vm_util-robust-write_file-fix.patch added to mm-unstable branch
Message-Id: <20260327193021.91A57C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-vm_util-robust-write_file-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-vm_util-robust-write_file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-vm_util-robust-write_file-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-vm_util-robust-write_file-fix
Date: Fri Mar 27 12:28:40 PM PDT 2026

add newline, per David

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-vm_util-robust-write_file-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -769,6 +769,7 @@ void write_file(const char *path, const
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
+
 	if (buflen < 1)
 		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch
selftests-mm-vm_util-robust-write_file-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

