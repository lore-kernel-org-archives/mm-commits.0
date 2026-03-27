Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED561223DD6
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 05:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774590988; cv=none; b=fKHiQnzJRBtDXL+HVxpIDbL+SypJYnKFmzL4h2cIGwJrUSnW7a5A0C5awlySiW43E9PjfLHePJOPmBIKCMXhkps88k9IVFbMxAREcuqEm6IVFy431AwVVP8XilHmeR+pbNKtj2b6CzM8sB6nqro6OLv3sQ2VGFspqDYAcsT1R7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774590988; c=relaxed/simple;
	bh=fU2sRQQKNZlRUaO119z6IL/heWi8+dnhKZyk/zZg6Gc=;
	h=Date:To:From:Subject:Message-Id; b=jwEET0aM+XVgfRVm80dKC5lla3Z/2QVm6o3gVJxG1GjoBrYPjiJ3hogmXYqxffRySVFoCLUMk1oVHUeBfTGlOOgTLumP6KkJ8B3fo6a/5g69fXT4YUXnHDBgVouFEb3hJ0f2usWzOxdEKnshOlKdT3iP86UZEUzfRMDmQ0gSKsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+438gCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+438gCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93477C19423;
	Fri, 27 Mar 2026 05:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774590987;
	bh=fU2sRQQKNZlRUaO119z6IL/heWi8+dnhKZyk/zZg6Gc=;
	h=Date:To:From:Subject:From;
	b=M+438gCS1g8ZpD1CJ8spMdFQYM8Yt6kjuUlwecwaNXPhMq2ywy2uPQymxDlhJRk3l
	 lmU9DrqOjPfwj9TjtXZaKmPwh4HBfm5CSTUE4Llfo1P3E3mfLi6Y1p3XpFdIjiRopU
	 ESN6TQHdV2l+HDgMApQHUpL3IFMbtLBU/86zDxhI=
Date: Thu, 26 Mar 2026 22:56:27 -0700
To: mm-commits@vger.kernel.org,mhklinux@outlook.com,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch added to mm-unstable branch
Message-Id: <20260327055627.93477C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch

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
Subject: drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
Date: Thu Mar 26 10:54:42 PM PDT 2026

restore struct vmbus_channel comment, per Michael Kelley

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hyperv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hyperv.h~drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix
+++ a/include/linux/hyperv.h
@@ -1015,7 +1015,7 @@ struct vmbus_channel {
 	/* The max size of a packet on this channel */
 	u32 max_pkt_size;
 
-	/* function to mmap_prepare ring buffer memory to the channel's sysfs ring attribute */
+	/*  function to mmap ring buffer memory to the channel's sysfs ring attribute */
 	int (*mmap_prepare_ring_buffer)(struct vmbus_channel *channel, struct vm_area_desc *desc);
 
 	/* boolean to control visibility of sysfs for ring buffer */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

