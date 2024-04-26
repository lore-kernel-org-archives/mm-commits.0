Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7ED762EF
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 05:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714107700; cv=none; b=OygtciHVPhE8zW2BxjKWCdfEm2YeA+eZI984WSZMxEf6fbwRua8v3oxxCEybY6Hdb+N7q6S/l4/tYuTw68ZdONEuwybEDefc2HBzqDDTDId+JhZYiwY6JjSCmgzvIgzNX8m60abdF1DplzVVJXpjpTy3q3usOUf3svi/JF2BBu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714107700; c=relaxed/simple;
	bh=0/DtHTX3ooWpFlUZYTn/JMlPuVePGcY+ZWP+x/miBh8=;
	h=Date:To:From:Subject:Message-Id; b=tfG8A5zhth/JCu4FHox2XmoBOozRSt38LLkJ5h+K0nXCuN5TEV4VAayitDkJPmrBJO8eSBzFomnCt+oJPDQ7yV3sHdDU/8mZOqG7PPlGEFd992sY47IeLaJoBgwSV5gqPVU+3La41GAnweygiiRs4sEDAFodjHNgwMRYSxNuCp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sbil6Du+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sbil6Du+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC87C113CD;
	Fri, 26 Apr 2024 05:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714107699;
	bh=0/DtHTX3ooWpFlUZYTn/JMlPuVePGcY+ZWP+x/miBh8=;
	h=Date:To:From:Subject:From;
	b=sbil6Du+SfltZlCrqSjJOEPuL6F3jvzE/74Y82kmG45GFUH4yeSRl1/lWj5REwk/B
	 D6HEdL6TVBVIocUzgpVf8IrzRsOHSBcX97FSO5QQYH00S5o6QmS4E9q3pxYHNYDAv2
	 maj9ckQXyNwJuNKCHAlNeTnxwinPk/Tx2/PcM/78=
Date: Thu, 25 Apr 2024 22:01:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,rdunlap@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch added to mm-unstable branch
Message-Id: <20240426050139.7EC87C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc-split-bufferrst-out-of-api-summaryrst-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: doc-split-bufferrst-out-of-api-summaryrst-fix-fix
Date: Thu Apr 25 10:01:12 PM PDT 2024

remove newline at EOF

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/buffer.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/filesystems/buffer.rst~doc-split-bufferrst-out-of-api-summaryrst-fix-fix
+++ a/Documentation/filesystems/buffer.rst
@@ -10,4 +10,3 @@ Functions
 .. kernel-doc:: include/linux/buffer_head.h
 .. kernel-doc:: fs/buffer.c
    :export:
-
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
doc-split-bufferrst-out-of-api-summaryrst-fix-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

