From: akpm@linux-foundation.org
Subject: [patch 14/17] mm/frame_vector.c: release a semaphore in
 'get_vaddr_frames()'
Date: Thu, 14 Dec 2017 15:33:08 -0800
Message-ID: <5a330a34.l8mVJ6HCyEyGgv7o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54404 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754418AbdLNXdK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, christophe.jaillet@wanadoo.fr, borntraeger@de.ibm.com, dan.j.williams@intel.com, dsterba@suse.com, gregkh@linuxfoundation.org, mhocko@suse.com

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm/frame_vector.c: release a semaphore in 'get_vaddr_frames()'

A semaphore is acquired before this check, so we must release it before
leaving.

Link: http://lkml.kernel.org/r/20171211211009.4971-1-christophe.jaillet@wanadoo.fr
Fixes: b7f0554a56f2 ("mm: fail get_vaddr_frames() for filesystem-dax mappings")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/frame_vector.c~mm-release-a-semaphore-in-get_vaddr_frames mm/frame_vector.c
--- a/mm/frame_vector.c~mm-release-a-semaphore-in-get_vaddr_frames
+++ a/mm/frame_vector.c
@@ -62,8 +62,10 @@ int get_vaddr_frames(unsigned long start
 	 * get_user_pages_longterm() and disallow it for filesystem-dax
 	 * mappings.
 	 */
-	if (vma_is_fsdax(vma))
-		return -EOPNOTSUPP;
+	if (vma_is_fsdax(vma)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref = true;
_
