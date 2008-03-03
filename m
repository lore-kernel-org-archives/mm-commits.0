From: akpm@linux-foundation.org
Subject: + ntfs-fix-nommu-build.patch added to -mm tree
Date: Sun, 02 Mar 2008 23:34:43 -0800
Message-ID: <200803030734.m237Yhkn004808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbYCCHe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 02:34:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier.adi@gmail.com, aia21@cantab.net, clameter@sgi.com, vapier@gentoo.org


The patch titled
     ntfs: fix nommu build
has been added to the -mm tree.  Its filename is
     ntfs-fix-nommu-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: fix nommu build
From: Mike Frysinger <vapier.adi@gmail.com>

In file included from fs/ntfs/attrib.c:32:
fs/ntfs/malloc.h: In function 'ntfs_free':
fs/ntfs/malloc.h:88: error: implicit declaration of function
'is_vmalloc_addr' make[2]: *** [fs/ntfs/attrib.o] Error 1

commit 9e2779fa281cfda13ac060753d674bbcaa23367e ("is_vmalloc_addr(): Check if
an address is within the vmalloc boundaries") changed fs/ntfs/malloc.h from
using VMALLOC_* defines to is_vmalloc_addr() (which makes sense), but Blackfin
was defining VMALLOC_* (to basically the range of all memory addresses like
most no-mmu ports)

so we can drop CONFIG_MMU around is_vmalloc_addr() in include/linux/mm.h, or
we can just make it return 1 all the time for no-mmu.  the former sounds
easier.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/mm.h~ntfs-fix-nommu-build include/linux/mm.h
--- a/include/linux/mm.h~ntfs-fix-nommu-build
+++ a/include/linux/mm.h
@@ -235,7 +235,6 @@ static inline int get_page_unless_zero(s
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
-#ifdef CONFIG_MMU
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)
 {
@@ -243,7 +242,6 @@ static inline int is_vmalloc_addr(const 
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
-#endif
 
 static inline struct page *compound_head(struct page *page)
 {
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
ntfs-fix-nommu-build.patch
procfs-task-exe-symlink-fix-2.patch

