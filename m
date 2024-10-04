Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1732AE7C;
	Fri,  4 Oct 2024 02:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008782; cv=none; b=p3ILRc3edfHxTuTfXEE8Qs3JE0nyx3PEIWLHAs8oXHJ6SGEHcckmXkR2K6IASMPD2QFmILs0wHlmvoh+n5AkFfHnvirUcFl6ypd/A2yRS10PtzP9jEQHxjgyht3mnGWB8x/WMOqZSWj+xnO0yaTGJ0RcTMmUaR3Xgweq59vIHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008782; c=relaxed/simple;
	bh=AwKApM6o/00x4NXG3oCQjiqWaTaq5Qpm+qHSF0mPtHY=;
	h=Date:To:From:Subject:Message-Id; b=Xi+nnp4AOCTDiyY8YLOT5PlY0AdiAQr2proD+65xLnYDm7Yf+jQ5clZ1mgYomjnwR75cH1Yaph9l0hXqkM16jepUxYNbImCfovEXcRVh+vnIr5pdPUA9wR7eWfjd6vHLwtb/IVzw/20NWm/JBe3n4lyfOxW0ULBVDP0PnxgwjsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cO5fKDjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cO5fKDjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287DEC4CEC7;
	Fri,  4 Oct 2024 02:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008782;
	bh=AwKApM6o/00x4NXG3oCQjiqWaTaq5Qpm+qHSF0mPtHY=;
	h=Date:To:From:Subject:From;
	b=cO5fKDjH6FM7ptq1QVuwKYtsVJiK3y468P5vjN8dtLLBgaLqt2KKxtyZf3bqRy2LD
	 8ifRsY357UEgvkkK4XkjGTTpliL9ckr66H2Yz/4YPzXouLcrKciTi6o6LXbDiJDf05
	 hEN5F4ZTr2TTC8vqblgLtiM3XPVN1wG30bwAt//M=
Date: Thu, 03 Oct 2024 19:26:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,jgowans@amazon.com,graf@amazon.com,david@redhat.com,roypat@amazon.co.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] secretmem-disable-memfd_secret-if-arch-cannot-set-direct-map.patch removed from -mm tree
Message-Id: <20241004022622.287DEC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: secretmem: disable memfd_secret() if arch cannot set direct map
has been removed from the -mm tree.  Its filename was
     secretmem-disable-memfd_secret-if-arch-cannot-set-direct-map.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Patrick Roy <roypat@amazon.co.uk>
Subject: secretmem: disable memfd_secret() if arch cannot set direct map
Date: Tue, 1 Oct 2024 09:00:41 +0100

Return -ENOSYS from memfd_secret() syscall if !can_set_direct_map().  This
is the case for example on some arm64 configurations, where marking 4k
PTEs in the direct map not present can only be done if the direct map is
set up at 4k granularity in the first place (as ARM's break-before-make
semantics do not easily allow breaking apart large/gigantic pages).

More precisely, on arm64 systems with !can_set_direct_map(),
set_direct_map_invalid_noflush() is a no-op, however it returns success
(0) instead of an error.  This means that memfd_secret will seemingly
"work" (e.g.  syscall succeeds, you can mmap the fd and fault in pages),
but it does not actually achieve its goal of removing its memory from the
direct map.

Note that with this patch, memfd_secret() will start erroring on systems
where can_set_direct_map() returns false (arm64 with
CONFIG_RODATA_FULL_DEFAULT_ENABLED=n, CONFIG_DEBUG_PAGEALLOC=n and
CONFIG_KFENCE=n), but that still seems better than the current silent
failure.  Since CONFIG_RODATA_FULL_DEFAULT_ENABLED defaults to 'y', most
arm64 systems actually have a working memfd_secret() and aren't be
affected.

From going through the iterations of the original memfd_secret patch
series, it seems that disabling the syscall in these scenarios was the
intended behavior [1] (preferred over having
set_direct_map_invalid_noflush return an error as that would result in
SIGBUSes at page-fault time), however the check for it got dropped between
v16 [2] and v17 [3], when secretmem moved away from CMA allocations.

[1]: https://lore.kernel.org/lkml/20201124164930.GK8537@kernel.org/
[2]: https://lore.kernel.org/lkml/20210121122723.3446-11-rppt@kernel.org/#t
[3]: https://lore.kernel.org/lkml/20201125092208.12544-10-rppt@kernel.org/

Link: https://lkml.kernel.org/r/20241001080056.784735-1-roypat@amazon.co.uk
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/secretmem.c~secretmem-disable-memfd_secret-if-arch-cannot-set-direct-map
+++ a/mm/secretmem.c
@@ -238,7 +238,7 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 	/* make sure local flags do not confict with global fcntl.h */
 	BUILD_BUG_ON(SECRETMEM_FLAGS_MASK & O_CLOEXEC);
 
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return -ENOSYS;
 
 	if (flags & ~(SECRETMEM_FLAGS_MASK | O_CLOEXEC))
@@ -280,7 +280,7 @@ static struct file_system_type secretmem
 
 static int __init secretmem_init(void)
 {
-	if (!secretmem_enable)
+	if (!secretmem_enable || !can_set_direct_map())
 		return 0;
 
 	secretmem_mnt = kern_mount(&secretmem_fs);
_

Patches currently in -mm which might be from roypat@amazon.co.uk are


