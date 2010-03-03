From: akpm@linux-foundation.org
Subject: + nommu-get_user_pages-pin-last-page-on-non-page-aligned-start.patch added to -mm tree
Date: Wed, 03 Mar 2010 14:54:22 -0800
Message-ID: <201003032254.o23MsMMj003607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab0CCWz2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 17:55:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve@digidescorp.com, dhowells@redhat.com, lethal@linux-sh.org


The patch titled
     nommu: get_user_pages(): pin last page on non-page-aligned start
has been added to the -mm tree.  Its filename is
     nommu-get_user_pages-pin-last-page-on-non-page-aligned-start.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nommu: get_user_pages(): pin last page on non-page-aligned start
From: "Steven J. Magnani" <steve@digidescorp.com>

The noMMU version of get_user_pages() fails to pin the last page when the
start address isn't page-aligned.  The patch fixes this in a way that
makes find_extend_vma() congruent to its MMU cousin.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/nommu.c~nommu-get_user_pages-pin-last-page-on-non-page-aligned-start mm/nommu.c
--- a/mm/nommu.c~nommu-get_user_pages-pin-last-page-on-non-page-aligned-start
+++ a/mm/nommu.c
@@ -146,7 +146,7 @@ int __get_user_pages(struct task_struct 
 			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 
 	for (i = 0; i < nr_pages; i++) {
-		vma = find_vma(mm, start);
+		vma = find_extend_vma(mm, start);
 		if (!vma)
 			goto finish_or_fault;
 
@@ -764,7 +764,7 @@ EXPORT_SYMBOL(find_vma);
  */
 struct vm_area_struct *find_extend_vma(struct mm_struct *mm, unsigned long addr)
 {
-	return find_vma(mm, addr);
+	return find_vma(mm, addr & PAGE_MASK);
 }
 
 /*
_

Patches currently in -mm which might be from steve@digidescorp.com are

origin.patch
linux-next.patch
nommu-get_user_pages-pin-last-page-on-non-page-aligned-start.patch

