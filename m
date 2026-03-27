Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDB2249E5
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 01:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774574351; cv=none; b=V3GbKFEKPhXZbb6TsnPQ07qmmy2mViueqfrAom+SiyB5BgM8uOaVSspYnnS+rAuKbDoKBa8tuh5YwZ5J2XvgldLNqG3r6tQlpzpCNFgsQq82MKGqpzyDh6u0VyCJ+cktcZMJ5f99C8swR2ahhzZh63rbmU+eTy/rBLTHWQHxv+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774574351; c=relaxed/simple;
	bh=1zTVRdmlTQTjtQ9pSzXq7XGIfcMO6LLimIZK3AJAKGs=;
	h=Date:To:From:Subject:Message-Id; b=cLJojBDa0TsctoRRL3mlrrpDZ5xnKiihef4F+6ZgyIKfOCCPhjBx4XU8SKLHcpFJjBdZmxjQOGiN682HnBHovHbjI+lBdGNX7fXo+w9Wb0PoZhDmjM72R3QghVVsmHtqSYW2r2eNX37MdI9Vn/34CZh9m3zhWXAZB95zBdvBIF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=afbR6kFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="afbR6kFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C75C116C6;
	Fri, 27 Mar 2026 01:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774574351;
	bh=1zTVRdmlTQTjtQ9pSzXq7XGIfcMO6LLimIZK3AJAKGs=;
	h=Date:To:From:Subject:From;
	b=afbR6kFdG2MVLcZFHfRevKmhalri8nZw6ZbF0Pn2Y7cMWGuDRJAhZeKEh4C9piITh
	 PUiHfe0dZFqiLYDbv/M6/6GSpFHlpLMv/Wc0raRMZh04QB7NSrw+dNisu64F0fRUcx
	 TWzsn43mHZq484MIAmBOTir7D6PfYl1E4gzRR2ys=
Date: Thu, 26 Mar 2026 18:19:10 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memfd-implement-get_id-for-memfd_luo.patch added to mm-new branch
Message-Id: <20260327011911.09C75C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memfd: implement get_id for memfd_luo
has been added to the -mm mm-new branch.  Its filename is
     memfd-implement-get_id-for-memfd_luo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memfd-implement-get_id-for-memfd_luo.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: memfd: implement get_id for memfd_luo
Date: Thu, 26 Mar 2026 16:39:42 +0000

Memfds are identified by their underlying inode.  Implement get_id for
memfd_luo to return the inode pointer.  This prevents the same memfd from
being managed twice by LUO if the same inode is pointed by multiple file
objects.

Link: https://lkml.kernel.org/r/20260326163943.574070-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memfd_luo.c~memfd-implement-get_id-for-memfd_luo
+++ a/mm/memfd_luo.c
@@ -572,6 +572,11 @@ static bool memfd_luo_can_preserve(struc
 	return shmem_file(file) && !inode->i_nlink;
 }
 
+static unsigned long memfd_luo_get_id(struct file *file)
+{
+	return (unsigned long)file_inode(file);
+}
+
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
 	.finish = memfd_luo_finish,
@@ -579,6 +584,7 @@ static const struct liveupdate_file_ops
 	.preserve = memfd_luo_preserve,
 	.unpreserve = memfd_luo_unpreserve,
 	.can_preserve = memfd_luo_can_preserve,
+	.get_id = memfd_luo_get_id,
 	.owner = THIS_MODULE,
 };
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-rwsem.patch
liveupdate-remove-file-handler-module-refcounting.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch

