From: akpm@linux-foundation.org
Subject: + mm-release-a-semaphore-in-get_vaddr_frames.patch added to -mm
 tree
Date: Tue, 12 Dec 2017 13:33:15 -0800
Message-ID: <5a304b1b.ZxRy7kyJV8NRKQNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53052 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752564AbdLLVdR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 16:33:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, borntraeger@de.ibm.com, dan.j.williams@intel.com, dsterba@suse.com, gregkh@linuxfoundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/frame_vector.c: release a semaphore in 'get_vaddr_frames()'
has been added to the -mm tree.  Its filename is
     mm-release-a-semaphore-in-get_vaddr_frames.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-release-a-semaphore-in-get_vaddr_frames.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-release-a-semaphore-in-get_vaddr_frames.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-release-a-semaphore-in-get_vaddr_frames.patch

