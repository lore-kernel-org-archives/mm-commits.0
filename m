Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABDF153808
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560550; cv=none; b=BisDZt75ZiNg2DarMhh6Xn9oNHVYoJgr5E4W4uyLond5r0uTbspvoQ1Y403lapyVMPuztVfNZZ+ANCUxzt1StbD9nSM9jvSON6koJbUs7Fto8POVYksHMkezKZTMSvnZmPPS4l89faMzg57b3DnOCep9zN++iHu3655LOxjusDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560550; c=relaxed/simple;
	bh=52jeh0zHT+lPLWkxX16fHWSKA2A4/y4LdclTJdAh180=;
	h=Date:To:From:Subject:Message-Id; b=iSranqFsXpveB1Tt8Pa6JoV7dEIOvPl2d6tnJeu5yTZSoZScIhphZ2eqozBdSscy9ktmwIBMjoY4RCIpPeOTGJ3cnZTgKT0/5C209wo7xiFBQiOP9X3aW4oRrTcYTh8mXjrpYp8cgnncmA+H/KU93b0urlsTqv/EWiWf3O8YJC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sotcmAq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sotcmAq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE63C4CEC6;
	Tue, 17 Sep 2024 08:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560550;
	bh=52jeh0zHT+lPLWkxX16fHWSKA2A4/y4LdclTJdAh180=;
	h=Date:To:From:Subject:From;
	b=sotcmAq4c1YWyXflfI2dFaODzT21oxJQUj+9U9qsqa6CSjMcmQwzfFvIRimNCZZ3v
	 c/keEE34q8AuvbAN9XfQa5FWSZjhIZYQCr5LqphJJWuIKadwfAPulHJ+L+/jd/NyXb
	 wlmB5hl/ICs/bM/DUFm9Yc9EYk7ibz0iDAExZp3Q=
Date: Tue, 17 Sep 2024 01:09:08 -0700
To: mm-commits@vger.kernel.org,oliver.sang@intel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,ice_yangxiao@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas.patch removed from -mm tree
Message-Id: <20240917080910.4DE63C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: return the exact errno in vms_gather_munmap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiao Yang <ice_yangxiao@163.com>
Subject: mm/vma: return the exact errno in vms_gather_munmap_vmas()
Date: Mon, 9 Sep 2024 21:56:21 +0900

__split_vma() and mas_store_gfp() returns several types of errno on
failure so don't ignore them in vms_gather_munmap_vmas().  For example,
__split_vma() returns -EINVAL when an unaligned huge page is unmapped. 
This issue is reproduced by ltp memfd_create03 test.

Don't initialise the error variable and assign it when a failure actually
occurs.

[akpm@linux-foundation.org: fix whitespace, per Liam]
Link: https://lkml.kernel.org/r/20240909125621.1994-1-ice_yangxiao@163.com
Fixes: 6898c9039bc8 ("mm/vma: extract the gathering of vmas from do_vmi_align_munmap()")
Signed-off-by: Xiao Yang <ice_yangxiao@163.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202409081536.d283a0fb-oliver.sang@intel.com
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/mm/vma.c~mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas
+++ a/mm/vma.c
@@ -1171,13 +1171,13 @@ void vms_complete_munmap_vmas(struct vma
  * @vms: The vma munmap struct
  * @mas_detach: The maple state tracking the detached tree
  *
- * Return: 0 on success, -EPERM on mseal vmas, -ENOMEM otherwise
+ * Return: 0 on success, error otherwise
  */
 int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach)
 {
 	struct vm_area_struct *next = NULL;
-	int error = -ENOMEM;
+	int error;
 
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -1191,8 +1191,10 @@ int vms_gather_munmap_vmas(struct vma_mu
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count)
+		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+			error = -ENOMEM;
 			goto map_count_exceeded;
+		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
 		if (!can_modify_vma(vms->vma)) {
@@ -1200,7 +1202,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 			goto start_split_failed;
 		}
 
-		if (__split_vma(vms->vmi, vms->vma, vms->start, 1))
+		error = __split_vma(vms->vmi, vms->vma, vms->start, 1);
+		if (error)
 			goto start_split_failed;
 	}
 	vms->prev = vma_prev(vms->vmi);
@@ -1220,12 +1223,14 @@ int vms_gather_munmap_vmas(struct vma_mu
 		}
 		/* Does it split the end? */
 		if (next->vm_end > vms->end) {
-			if (__split_vma(vms->vmi, next, vms->end, 0))
+			error = __split_vma(vms->vmi, next, vms->end, 0);
+			if (error)
 				goto end_split_failed;
 		}
 		vma_start_write(next);
 		mas_set(mas_detach, vms->vma_count++);
-		if (mas_store_gfp(mas_detach, next, GFP_KERNEL))
+		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
+		if (error)
 			goto munmap_gather_failed;
 
 		vma_mark_detached(next, true);
@@ -1255,8 +1260,9 @@ int vms_gather_munmap_vmas(struct vma_mu
 			 * split, despite we could. This is unlikely enough
 			 * failure that it's not worth optimizing it for.
 			 */
-			if (userfaultfd_unmap_prep(next, vms->start, vms->end,
-						   vms->uf))
+			error = userfaultfd_unmap_prep(next, vms->start,
+						       vms->end, vms->uf);
+			if (error)
 				goto userfaultfd_error;
 		}
 #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
_

Patches currently in -mm which might be from ice_yangxiao@163.com are


