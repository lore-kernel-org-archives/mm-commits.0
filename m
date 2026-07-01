Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E51774C14
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 04:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782878461; cv=none; b=Vu6jhMd8gJ+Rz2+SCAYfmyjovSUBw4sJnYPBSgbmCMpX3OTojyPXnq0tDynYX0Dzx6K6QycZhQBypZh3EtcZXTP4/DgsIZyiL2/v+ukSLT0OrDojbC8Lktn9/o/1dJmY2k3GdiDNiouHgvEJBMFKmUgPxyLLFDos8QnmZE9CIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782878461; c=relaxed/simple;
	bh=0ul93Khk7uWyyV7MJgU1sCHPYb8KlVWSRF018XaONt0=;
	h=Date:To:From:Subject:Message-Id; b=bHlLKPed3CdwgHCg6WiyjWJaLnMfnZ9ES+pZztOeYn6fYzSV7tBTzgxByTVURmqcfH3RCo+a84b890p+Vq5nkcdr3jKQgxSE27EgS3xWRWRIp9BcXD8LXmOQa/SPMvU9jsRz2oS4YjmPRJuXiQ835URIBVSbVtSgBqQB1HD06gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZArlbAV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZArlbAV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B2B1F000E9;
	Wed,  1 Jul 2026 04:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782878457;
	bh=78Ql8CnE/XR7a0IiDZPkdXZvTAz2DVDV/9YbNB4lcmo=;
	h=Date:To:From:Subject;
	b=ZArlbAV5/gNrLizt7hGPCbBoaX2XG65E20j2K1LDCE65lE9NwSV8zX3Nt+Utv/eje
	 xsY4YuF3hiJoGMiBysw2rKdV0MKpMpVnW+Jhd2QTyQa2OwbtQn0oh6H/nDVW8mk1l3
	 zzEUqJD2Zzs8z0WvY6XapoyHRDFfCDdNLfosfUq0=
Date: Tue, 30 Jun 2026 21:00:57 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,yahia.a.abdrabou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-data-race-in-shmem_fault.patch added to mm-new branch
Message-Id: <20260701040057.A3B2B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix data-race in shmem_fault
has been added to the -mm mm-new branch.  Its filename is
     mm-shmem-fix-data-race-in-shmem_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-data-race-in-shmem_fault.patch

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
From: yahia <yahia.a.abdrabou@gmail.com>
Subject: mm/shmem: fix data-race in shmem_fault
Date: Tue, 30 Jun 2026 15:02:22 +0300

shmem_fault and shmem_writeout access inode->i_private without holding a
lock, while shmem_fallocate is modifying it while holding a lock, thus a
data-race is created.

Fix this by using READ_ONCE and WRITE_ONCE, which provides an atomic,
lockless read and write of inode->i_private which prevents compiler
optimizations such as caching in registers and add writing to
inode->i_private with WRITE_ONCE to prevent the compiler from writing in
registers.

Link: https://lore.kernel.org/20260630120222.11562-1-yahia.a.abdrabou@gmail.com
Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-data-race-in-shmem_fault
+++ a/mm/shmem.c
@@ -1657,7 +1657,7 @@ try_split:
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
 	if (!folio_test_uptodate(folio)) {
-		if (inode->i_private) {
+		if (READ_ONCE(inode->i_private)) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
@@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
@@ -3630,7 +3630,7 @@ static long shmem_fallocate(struct file
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
+		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
@@ -3640,7 +3640,7 @@ static long shmem_fallocate(struct file
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
-		inode->i_private = NULL;
+		WRITE_ONCE(inode->i_private, NULL);
 		wake_up_all(&shmem_falloc_waitq);
 		WARN_ON_ONCE(!list_empty(&shmem_falloc_waitq.head));
 		spin_unlock(&inode->i_lock);
@@ -3672,7 +3672,7 @@ static long shmem_fallocate(struct file
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
 	spin_lock(&inode->i_lock);
-	inode->i_private = &shmem_falloc;
+	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
 
 	/*
@@ -3747,7 +3747,7 @@ static long shmem_fallocate(struct file
 		i_size_write(inode, offset + len);
 undone:
 	spin_lock(&inode->i_lock);
-	inode->i_private = NULL;
+	WRITE_ONCE(inode->i_private, NULL);
 	spin_unlock(&inode->i_lock);
 out:
 	if (!error)
_

Patches currently in -mm which might be from yahia.a.abdrabou@gmail.com are

mm-shmem-fix-data-race-in-shmem_fault.patch

