Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C823D7FF
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465740; cv=none; b=DKCiiFX9OPLYZA/NVVyvx6oS4PSfIW6AOTFk/WXI4haFvNNsOwGke5c52gYu7rMaoah7jgC24j2WMrCUXmXDwQFagg9Q+mWrY59S22XGQ/Tjxx9JDVVa7iCCZBzX0jOB0TObR/Vpzc9MuuyPQ0y/bxm2phTfQ4v/m03OW0A4aFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465740; c=relaxed/simple;
	bh=gJE7/OTmflB93c8Jq2nFRl5H0WqwjX9u8fj6hba8ARQ=;
	h=Date:To:From:Subject:Message-Id; b=ADyDG3DhLkU4Np0YzrgMyrFRhy5OhOgmTkBFY0VL93NLcelynWW2o+ya7yaJjEld98nqKCqQrb1ILqiIcxCjy4eIFhKhvu5gPa7wqpSe+wKRyiy692+neOn9JTI3yA5X96DVMw5rCw19LIIiDbuBfBfOHKna3p12X6I0p/NViCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HbkpLgyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HbkpLgyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C4A1F000E9;
	Fri, 31 Jul 2026 02:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465739;
	bh=OGcMjzbpFu9yaaNO6s1DYDSb/rNQc3+bzbIdWvnEDyU=;
	h=Date:To:From:Subject;
	b=HbkpLgyPRCfqMuW6Modzm1+Jm3seeQZtLVLt0lxvQvcsM+0hAlcKPYJPg3GyEh2lr
	 p2ozGLjIkv14Wbx6e/fiyQalMtAmPi5CJK8O9zn5TWBf/4WOjoeg1rFfX+PfeRdo3u
	 bPquWkBJuaN/dWJfUYLtEoPbRFBcLbsauamkjXRA=
Date: Thu, 30 Jul 2026 19:42:19 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,yahia.a.abdrabou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-data-race-in-shmem_fault.patch removed from -mm tree
Message-Id: <20260731024219.69C4A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix data-race in shmem_fault
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-data-race-in-shmem_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: yahia ahmed <yahia.a.abdrabou@gmail.com>
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
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-data-race-in-shmem_fault
+++ a/mm/shmem.c
@@ -1667,7 +1667,7 @@ try_split:
 	 * reactivate the folio, and let shmem_fallocate() quit when too many.
 	 */
 	if (!folio_test_uptodate(folio)) {
-		if (inode->i_private) {
+		if (READ_ONCE(inode->i_private)) {
 			struct shmem_falloc *shmem_falloc;
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
@@ -2703,7 +2703,7 @@ static vm_fault_t shmem_fault(struct vm_
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
@@ -3640,7 +3640,7 @@ static long shmem_fallocate(struct file
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
+		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
@@ -3650,7 +3650,7 @@ static long shmem_fallocate(struct file
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
-		inode->i_private = NULL;
+		WRITE_ONCE(inode->i_private, NULL);
 		wake_up_all(&shmem_falloc_waitq);
 		WARN_ON_ONCE(!list_empty(&shmem_falloc_waitq.head));
 		spin_unlock(&inode->i_lock);
@@ -3682,7 +3682,7 @@ static long shmem_fallocate(struct file
 	shmem_falloc.nr_falloced = 0;
 	shmem_falloc.nr_unswapped = 0;
 	spin_lock(&inode->i_lock);
-	inode->i_private = &shmem_falloc;
+	WRITE_ONCE(inode->i_private, &shmem_falloc);
 	spin_unlock(&inode->i_lock);
 
 	/*
@@ -3757,7 +3757,7 @@ static long shmem_fallocate(struct file
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


