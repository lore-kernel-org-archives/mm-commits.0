Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24F7DDC7
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718845970; cv=none; b=n4oAavB2QZbLpE2eYnPF3s/v68ayjzpP8FZkJVheuqc40Ughx+KOLzGGydZYpKlEXlJQITsZjNgRfEqHZ8n927Tjd88eWCCy7AzV7ZuTW9c+f8pktidAsujutCkQWgQ3HgfakeRm6EChScTfYEr/QLhuHNqW3C9yQyteS1AuY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718845970; c=relaxed/simple;
	bh=j/Oh2xbdrWDp7wqho+io43itec80Eydr95M4sbzIP5s=;
	h=Date:To:From:Subject:Message-Id; b=tckXzHifIJlGuLJabmBr47PjvU7vqdPr2k15b3yJADbdAHargmZ7HnZKq5UW0CMGU6xUg6IPBuU08NgyE9Cn822iEYobwZ2FLCutxxGFF9Ilym7lNLktb8+Wy5ZkQrOefpRKYwGNq0daruwXPmW0jNEdbQn+CoKaQgE9jnQ9E4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=niJXjg1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="niJXjg1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A155BC2BBFC;
	Thu, 20 Jun 2024 01:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718845969;
	bh=j/Oh2xbdrWDp7wqho+io43itec80Eydr95M4sbzIP5s=;
	h=Date:To:From:Subject:From;
	b=niJXjg1LWdKyrjcT7C+kM6C2xFdGJH2FrYpXADBwauWX1UKPllNUVxCpxFIsPjYjw
	 9TCYwViLWkLf+YbRE9JnCbJB7hnQ0AvOJqC9zvxD89eTVjESWn/cl0lRZk0NNewz5c
	 HLeYt6JAw2Aup1+jkZ87fI8sJodEUbOzSzZR7K3k=
Date: Wed, 19 Jun 2024 18:12:49 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,kirill.shutemov@linux.intel.com,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-change-the-layout-of-vmemmap.patch added to mm-nonmm-unstable branch
Message-Id: <20240620011249.A155BC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: change the layout of vmemmap
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-change-the-layout-of-vmemmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-change-the-layout-of-vmemmap.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: change the layout of vmemmap
Date: Wed, 19 Jun 2024 15:49:08 +0800

We need to change the layout of vmemmap in gdb scripts after
commit 32697ff38287 ("arm64: vmemmap: Avoid base2 order of
struct page size to dimension region") changed it.

Link: https://lkml.kernel.org/r/20240619074911.100434-4-kuan-ying.lee@canonical.com
Fixes: 32697ff38287 ("arm64: vmemmap: Avoid base2 order of struct page size to dimension region")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/mm.py |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/gdb/linux/mm.py~scripts-gdb-change-the-layout-of-vmemmap
+++ a/scripts/gdb/linux/mm.py
@@ -89,10 +89,10 @@ class aarch64_page_ops():
         self.MODULES_VADDR = self._PAGE_END(self.VA_BITS_MIN)
         self.MODULES_END = self.MODULES_VADDR + self.MODULES_VSIZE
 
-        self.VMEMMAP_SHIFT = (self.PAGE_SHIFT - self.STRUCT_PAGE_MAX_SHIFT)
-        self.VMEMMAP_SIZE = ((self._PAGE_END(self.VA_BITS_MIN) - self.PAGE_OFFSET) >> self.VMEMMAP_SHIFT)
-        self.VMEMMAP_START = (-(1 << (self.VA_BITS - self.VMEMMAP_SHIFT))) & 0xffffffffffffffff
-        self.VMEMMAP_END = self.VMEMMAP_START + self.VMEMMAP_SIZE
+        self.VMEMMAP_RANGE = self._PAGE_END(self.VA_BITS_MIN) - self.PAGE_OFFSET
+        self.VMEMMAP_SIZE = (self.VMEMMAP_RANGE >> self.PAGE_SHIFT) * self.struct_page_size
+        self.VMEMMAP_END = (-(1 * 1024 * 1024 * 1024)) & 0xffffffffffffffff
+        self.VMEMMAP_START = self.VMEMMAP_END - self.VMEMMAP_SIZE
 
         self.VMALLOC_START = self.MODULES_END
         self.VMALLOC_END = self.VMEMMAP_START - 256 * 1024 * 1024
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-redefine-max_order-sanely.patch
scripts-gdb-rework-module-va-range.patch
scripts-gdb-change-the-layout-of-vmemmap.patch
scripts-gdb-set-vabits_actual-based-on-tcr_el1.patch
scripts-gdb-change-va_bits_min-when-we-use-16k-page.patch
scripts-gdb-rename-pool_index-to-pool_index_plus_1.patch

