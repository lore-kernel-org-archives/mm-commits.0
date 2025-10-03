Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCE617A2E1;
	Fri,  3 Oct 2025 20:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759521866; cv=none; b=e+0qHuD5qmmCHH1xDMPcnXSDCgrlq4A0INW8HFgBpjeChJYzE0fC0xvRmAZm0V9lVFqJaWsESOGrnRBRqF2Gpzi87R1kQVIGTHN0Up7uMI2WK75ubkKAW5ts1nXhB29Kez8EVnmCKUpxIZo1guvMUZ2d8oLUlyooKGdxSL07mp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759521866; c=relaxed/simple;
	bh=u1QnQx13LE9hjNdiPOQyvWmgHXi8c3nrDp92oymNCQ0=;
	h=Date:To:From:Subject:Message-Id; b=uHyO8+I9EDmeiqDeT0KbysNI6mkwOUUTfZu7VmulQ3qyQuynRSfCExMOx5wjGgYnjQXdUGPg4vYuDPCTgT2pCrzssdVFuvhGTR/CbVKJ7fb8YlsK4YDmpRtpJ6XonDVzQQSZvCzZa7hOdnXQNHSqyT3HHmfEtehRo66hMCi+/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D9k694jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D9k694jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB0C4CEF5;
	Fri,  3 Oct 2025 20:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759521866;
	bh=u1QnQx13LE9hjNdiPOQyvWmgHXi8c3nrDp92oymNCQ0=;
	h=Date:To:From:Subject:From;
	b=D9k694jRMkn9A/5EaRNVGvqqp5aL06IJARqeqfI53DUOQFWGlWWMRoE7sc5KflvY/
	 K566eWahxxjRvnmlwHL4hEPQSofV1lR+v3U/vn/5H6GBWgwJ3w08q4fQiFOlGBXYuQ
	 cEHTHa6fae6jYBvRJxnlbYkOlDELU7q+i1PupNCA=
Date: Fri, 03 Oct 2025 13:04:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,david@redhat.com,amir73il@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch added to mm-hotfixes-unstable branch
Message-Id: <20251003200426.15BB0C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fsnotify: pass correct offset to fsnotify_mmap_perm()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: fsnotify: pass correct offset to fsnotify_mmap_perm()
Date: Fri, 3 Oct 2025 16:52:36 +0100

fsnotify_mmap_perm() requires a byte offset for the file about to be
mmap'ed.  But it is called from vm_mmap_pgoff(), which has a page offset. 
Previously the conversion was done incorrectly so let's fix it, being
careful not to overflow on 32-bit platforms.

Discovered during code review.

Link: https://lkml.kernel.org/r/20251003155238.2147410-1-ryan.roberts@arm.com
Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/util.c~fsnotify-pass-correct-offset-to-fsnotify_mmap_perm
+++ a/mm/util.c
@@ -566,6 +566,7 @@ unsigned long vm_mmap_pgoff(struct file
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)
 {
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 	unsigned long ret;
 	struct mm_struct *mm = current->mm;
 	unsigned long populate;
@@ -573,7 +574,7 @@ unsigned long vm_mmap_pgoff(struct file
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret)
-		ret = fsnotify_mmap_perm(file, prot, pgoff >> PAGE_SHIFT, len);
+		ret = fsnotify_mmap_perm(file, prot, off, len);
 	if (!ret) {
 		if (mmap_write_lock_killable(mm))
 			return -EINTR;
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch

