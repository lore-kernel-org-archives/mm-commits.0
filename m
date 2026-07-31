Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ACE33A717
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465838; cv=none; b=LhGqAlIBYoJejLVqodLvrLrs/fhjaUWWeIJqHXqkuIU//vIev09h6RtXT46221wJFDlojo4LJP66ptBUITUWvYOJ7sPpxVnYCEstTCme1cyFVxt1385ihPbLlOgaXPJy7Ornz4iSHeEZ/WJxgCKQ9yd96RQASrIDwv1rdnY3GDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465838; c=relaxed/simple;
	bh=JiUsfHOfIA+MM1etz1sp1ZYsaOJ++FH4o5Cgo1kvGu0=;
	h=Date:To:From:Subject:Message-Id; b=fEZuXz/zLQU7pTynEKwcMNw5x/byNreYEglKmb2eYSpyKtNCwdaDeViqPRSPQEewDbcv6WpnMKQWDwxX23yxR+c3+Q4QKmtkx9aRCjJbvW5d3Dr1j1KtZ7VyYVwUegoFlrfl+9oFomap/KV0YTc0x5PtLk7/2NRycP32HF607h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ePMGHoDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ePMGHoDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800C71F000E9;
	Fri, 31 Jul 2026 02:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465837;
	bh=slnx1TlhHOhN/X7+XtEa9iFhj8yq17pZUdceA7fckUg=;
	h=Date:To:From:Subject;
	b=ePMGHoDj0yIwIje0ti9Nbhyx7WGVwLDNQztsPf0vEpOJ+tUA3IaeQ6KSNaPdb88rn
	 ReMCg4iWpeqKO7mVBZxR8nTpfP7Xkenw3dkVcG+0uqH6uSx7vlEJO2oVsXZR3+jqWH
	 GPK2AhDS4/+WRn4hKrZbmMm5Yx1WIQ0B2uABRKEo=
Date: Thu, 30 Jul 2026 19:43:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,thehajime@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch removed from -mm tree
Message-Id: <20260731024357.800C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: nommu: add sysctl_max_map_count() check for do_mmap()
has been removed from the -mm tree.  Its filename was
     mm-nommu-add-sysctl_max_map_count-check-for-do_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hajime Tazaki <thehajime@gmail.com>
Subject: mm: nommu: add sysctl_max_map_count() check for do_mmap()
Date: Thu, 2 Jul 2026 10:28:30 +0900

The sysctl variable vm.max_map_count (sysctl_max_map_count) is not exposed
under !MMU configurations, but its default value (DEFAULT_MAX_MAP_COUNT)
is still used as a allocation limit.  Currently, this limit is enforced
when a VMA entry is split into two chunks (split_vma()), but it is not
checked during initial allocation (do_mmap()).  As a result, if a user
requests a large number of memory allocations, the system will continue
allocating until it hits an Out-Of-Memory (OOM) condition.

This commit introduces a check at the beginning of do_mmap() in nommu.c to
prevent this situation.

This issue was detected using the Linux Test Project (LTP) test linked
below.

Link: https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/munmap/munmap04.c
Link: https://lore.kernel.org/20260702012830.667205-1-thehajime@gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/nommu.c~mm-nommu-add-sysctl_max_map_count-check-for-do_mmap
+++ a/mm/nommu.c
@@ -1035,6 +1035,9 @@ unsigned long do_mmap(struct file *file,
 	if (ret < 0)
 		return ret;
 
+	if (current->mm->map_count >= get_sysctl_max_map_count())
+		return -ENOMEM;
+
 	/* we ignore the address hint */
 	addr = 0;
 	len = PAGE_ALIGN(len);
_

Patches currently in -mm which might be from thehajime@gmail.com are

mm-nommu-point-to-the-write-iterator-upon-split_vma.patch
mm-nommu-fix-the-error-path-when-vma_iter_prealloc-fails.patch

