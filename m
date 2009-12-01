From: akpm@linux-foundation.org
Subject: [merged] drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch removed from -mm tree
Date: Tue, 01 Dec 2009 12:17:47 -0800
Message-ID: <200912012017.nB1KHlZC019411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbZLAUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 15:18:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, JBeulich@novell.com, airlied@linux.ie, jeremy.fitzhardinge@citrix.com, mm-commits@vger.kernel.org


The patch titled
     drm: make sure page protections are updated after changing vm_flags
has been removed from the -mm tree.  Its filename was
     drm-make-sure-page-protections-are-updated-after-changing-vm_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: make sure page protections are updated after changing vm_flags
From: Jeremy Fitzhardinge <jeremy@goop.org>

Some architectures compute ->vm_page_prot depending on ->vm_flags, so we
need to update the protections after adjusting the flags.

AFAIK this only affects running X under Xen; without this patch you get
lots of coloured blobs on the screen, or maybe a complete lockup.  Or
anything really.

But that still depends on lots of out-of-tree stuff, so I don't think
there are any consequences for anyone else.  But it is wrong in principle.

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

origin.patch
linux-next.patch

