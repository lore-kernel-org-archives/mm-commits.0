Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E35170A11;
	Tue,  7 Oct 2025 21:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759870905; cv=none; b=mgBH5BKQSfhyCBuAIFKnGNjsqlkB6Q0lCZ6G3e3sfO4QaGGBu90Yk3yINi5twofJmNN/SqNhcvD69VEpUnNxpdJe7JPqIodR2oQCvTPOAgJUDefWKplmWbRXUoxAEznhZzRiPZ33D18Tdw8k/uXqfgB+3yv2afYUH/1j+sKGhwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759870905; c=relaxed/simple;
	bh=4sfgQb0fevL8Au96dCnXOuQAVjFvRmIfE4RKXUR3+9w=;
	h=Date:To:From:Subject:Message-Id; b=goY5N+eIxxiJ/SOj5yeJ8aQjUBoRmfJt4ZVFaJY26K/W66hiFMG6fmndRyPuaYlBK0BqQz2bXoWnPjufW3JveHuj01U37qJgKf9eE3Yt58YRZcB0kFBiZLfyOv1Q/fCBl56IC6rYnqaIglzo2lVgdq7CR6Z9QWT6dCpaDbH9Ylk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jy2lsWfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jy2lsWfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19173C4CEF1;
	Tue,  7 Oct 2025 21:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759870905;
	bh=4sfgQb0fevL8Au96dCnXOuQAVjFvRmIfE4RKXUR3+9w=;
	h=Date:To:From:Subject:From;
	b=jy2lsWfkhsjiqwkLgbYmY8aJPGrwaVwvZOpJjXP6aUOJ4vA9d0IBSKa78qf/+emY2
	 ybqziITw2qsQja7+nJ7soD71cEy3uvFRrtZiOoGy3I3QWE7xwsHwKyS99PSSKydBO0
	 KOggXKRZEweUWGCWh62A7h4CYj8HpsT1Xj0Ryh/4=
Date: Tue, 07 Oct 2025 14:01:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kas@kernel.org,david@redhat.com,amir73il@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch removed from -mm tree
Message-Id: <20251007210145.19173C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fsnotify: pass correct offset to fsnotify_mmap_perm()
has been removed from the -mm tree.  Its filename was
     fsnotify-pass-correct-offset-to-fsnotify_mmap_perm.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


