Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2976AFAE
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423561; cv=none; b=OTJ3uNcQK5dPA2KhC5VSPEKydN1HvOWA0KBymgpS5Fxcz8m13nRaIXhb9w/w6u8So1ggWeCtxTwdIZOz4Cnpn7JPGlY0cNNK7Sa/J3SH5FCvT8iQ51zP/i2vyrK9RN6qVXos1KdDucyLweGo3fr9x2OXqbUOV7cT0lLCnx1ZshI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423561; c=relaxed/simple;
	bh=MDO2WTTXvQtSzFzP+7kY1ltreDpS92aglsVJyD1hK+o=;
	h=Date:To:From:Subject:Message-Id; b=MWPH0MOhl0rJWf/u1Lm8s0rPRtt/LYC4a8e0qg9FjmdXXzLzUnsCsKY8AYUNF0Jgn3NZgyTnXH3YUOChxW3z5AMQEqOODrdw5od3monIQ+KbY3JMvwn3/AZ5aJID7tEZKJusDfRQuY96pjLcG3kNvEdtw+1GFdMWgiWDPYfk3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k/nXyZ8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k/nXyZ8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6F6C4CEC2;
	Wed,  4 Sep 2024 04:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423561;
	bh=MDO2WTTXvQtSzFzP+7kY1ltreDpS92aglsVJyD1hK+o=;
	h=Date:To:From:Subject:From;
	b=k/nXyZ8beykYtRJxrp6JtGjm39Sqg599OE4JsbRPsuAcijydacE8fnSbsVirJsZvl
	 UxbiNSi+hDWFWprTjWDdGfHc+4BvverS7QIJT/4MxyPZRs4eSmht2OJXS1qkF0rvph
	 Wus82+VZd+JoLlhglBZHRFUL7D+voQ2dD4E76z9E=
Date: Tue, 03 Sep 2024 21:19:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-support-vma-==-null-in-init_vma_munmap.patch removed from -mm tree
Message-Id: <20240904041921.7A6F6C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: support vma == NULL in init_vma_munmap()
has been removed from the -mm tree.  Its filename was
     mm-vma-support-vma-==-null-in-init_vma_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: support vma == NULL in init_vma_munmap()
Date: Fri, 30 Aug 2024 00:00:50 -0400

Adding support for a NULL vma means the init_vma_munmap() can be
initialized for a less error-prone process when calling
vms_complete_munmap_vmas() later on.

Link: https://lkml.kernel.org/r/20240830040101.822209-11-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 mm/vma.h  |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-vma-support-vma-==-null-in-init_vma_munmap
+++ a/mm/mmap.c
@@ -1393,11 +1393,11 @@ unsigned long mmap_region(struct file *f
 
 	/* Find the first overlapping VMA */
 	vma = vma_find(&vmi, end);
+	init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
 	if (vma) {
 		mt_init_flags(&mt_detach, vmi.mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 		mt_on_stack(mt_detach);
 		mas_init(&mas_detach, &mt_detach, /* addr = */ 0);
-		init_vma_munmap(&vms, &vmi, vma, addr, end, uf, /* unlock = */ false);
 		/* Prepare to unmap any existing mapping in the area */
 		error = vms_gather_munmap_vmas(&vms, &mas_detach);
 		if (error)
--- a/mm/vma.h~mm-vma-support-vma-==-null-in-init_vma_munmap
+++ a/mm/vma.h
@@ -95,9 +95,14 @@ static inline void init_vma_munmap(struc
 {
 	vms->vmi = vmi;
 	vms->vma = vma;
-	vms->mm = vma->vm_mm;
-	vms->start = start;
-	vms->end = end;
+	if (vma) {
+		vms->mm = vma->vm_mm;
+		vms->start = start;
+		vms->end = end;
+	} else {
+		vms->mm = NULL;
+		vms->start = vms->end = 0;
+	}
 	vms->unlock = unlock;
 	vms->uf = uf;
 	vms->vma_count = 0;
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


