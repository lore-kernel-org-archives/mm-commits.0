From: akpm@linux-foundation.org
Subject: + drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:39:44 -0700
Message-ID: <200910062039.n96KdiaL019767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933044AbZJFUlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, JBeulich@novell.com, airlied@linux.ie, jeremy.fitzhardinge@citrix.com


The patch titled
     drm: make sure page protections are updated after changing vm_flags
has been added to the -mm tree.  Its filename is
     drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch

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
Subject: drm: make sure page protections are updated after changing vm_flags
From: Jeremy Fitzhardinge <jeremy@goop.org>

Some architectures compute ->vm_page_prot depending on ->vm_flags, so we
need to update the protections after adjusting the flags.

Reported-by: Jan Beulich <JBeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/drm_gem.c~drm-make-sure-page-protections-are-updated-after-changing-vm_flags drivers/gpu/drm/drm_gem.c
--- a/drivers/gpu/drm/drm_gem.c~drm-make-sure-page-protections-are-updated-after-changing-vm_flags
+++ a/drivers/gpu/drm/drm_gem.c
@@ -552,7 +552,7 @@ int drm_gem_mmap(struct file *filp, stru
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_PFNMAP | VM_DONTEXPAND;
 	vma->vm_ops = obj->dev->driver->gem_vm_ops;
 	vma->vm_private_data = map->handle;
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	vma->vm_page_prot =  pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
 
 	/* Take a ref for this mapping of the object, so that the fault
 	 * handler can dereference the mmap offset's pointer to the object.
_

Patches currently in -mm which might be from jeremy@goop.org are

drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch

