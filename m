From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:04:42 -0700
Message-ID: <573f7bea.VR4poOZRkbjE/3RK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, vbabka@suse.cz, vvs@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: replace BUG_ON(anon_vma->degree) with VM_WARN_ON
has been removed from the -mm tree.  Its filename was
     mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/rmap: replace BUG_ON(anon_vma->degree) with VM_WARN_ON

This check effectively catches anon vma hierarchy inconsistence and some
vma corruptions.  It was effective for catching corner cases in anon vma
reusing logic.  For now this code seems stable so check could be hidden
under CONFIG_DEBUG_VM and replaced with WARN because it's not so fatal.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Suggested-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on mm/rmap.c
--- a/mm/rmap.c~mm-rmap-replace-bug_onanon_vma-degree-with-vm_warn_on
+++ a/mm/rmap.c
@@ -409,7 +409,7 @@ void unlink_anon_vmas(struct vm_area_str
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		BUG_ON(anon_vma->degree);
+		VM_WARN_ON(anon_vma->degree);
 		put_anon_vma(anon_vma);
 
 		list_del(&avc->same_vma);
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are


