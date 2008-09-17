From: akpm@linux-foundation.org
Subject: + kexec-segmentation-fault-in-kimage_add_entry.patch added to -mm tree
Date: Wed, 17 Sep 2008 15:35:01 -0700
Message-ID: <200809172235.m8HMZ18n001656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756046AbYIQWfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 18:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jon.steel@esentire.com, ebiederm@xmission.com


The patch titled
     kexec: fix segmentation fault in kimage_add_entry
has been added to the -mm tree.  Its filename is
     kexec-segmentation-fault-in-kimage_add_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec: fix segmentation fault in kimage_add_entry
From: Jonathan Steel <jon.steel@esentire.com>

A segmentation fault can occur in kimage_add_entry in kexec.c when loading
a kernel image into memory.  The fault occurs because a page is requested
by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the function may
actually return a page with gfp_mask GFP_HIGHUSER.  The high mem page is
returned because it was swapped with the kernel page due to the kernel
page being a page that will shortly be copied to.

This patch ensures that kimage_alloc_page returns a page that was created
with the correct gfp flags.

I have verified the change and fixed the whitespace damage of the original
patch.  Jonathan did a great job of tracking this down after he hit the
problem.  -- Eric

Signed-off-by: Jonathan Steel <jon.steel@esentire.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-segmentation-fault-in-kimage_add_entry kernel/kexec.c
--- a/kernel/kexec.c~kexec-segmentation-fault-in-kimage_add_entry
+++ a/kernel/kexec.c
@@ -753,8 +753,14 @@ static struct page *kimage_alloc_page(st
 			*old = addr | (*old & ~PAGE_MASK);
 
 			/* The old page I have found cannot be a
-			 * destination page, so return it.
+			 * destination page, so return it if it's
+			 * gfp_flags honor the ones passed in.
 			 */
+			if (!(gfp_mask & __GFP_HIGHMEM) &&
+			    PageHighMem(old_page)) {
+				kimage_free_pages(old_page);
+				continue;
+			}
 			addr = old_addr;
 			page = old_page;
 			break;
_

Patches currently in -mm which might be from jon.steel@esentire.com are

kexec-segmentation-fault-in-kimage_add_entry.patch

