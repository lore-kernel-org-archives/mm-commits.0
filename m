Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973822D0C79
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917789; cv=none; b=TW7rq2/gs9ExDh3nug7RZY07bTzZnOBvLgWihoCOBGdy3xD1xDj1x7Wq9tr3U/g5PTDwHJULAySITnYKNbIvxyhl7z5Cr9OTKWBG3iO3R1qNshMHolm5DjWqIv1KBJif1Zx9UpHzitNv9HED3dnCdE+UtpK2S8tZ18ighUBzn6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917789; c=relaxed/simple;
	bh=g3qNa4YRTdbS45Ks5WjESt3TtkwX9s8Ho/7Owzy4Rik=;
	h=Date:To:From:Subject:Message-Id; b=EUrVpOxiQpuD9oLKrIesFDk+8LFwXv43a893+7eqoeQXcMMqd7adFvrh3YrdRp4Nbj+30MWqB0f6OliWn+xATivDhPHFbPFNGjLYuqO89kzy4bJUdKgEQqS2knX7OAw7FdDWoSm1mQC0UTcEdshmrTPX2uNMkWG4WSZuot0lkv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bsLU4/KI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bsLU4/KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67452C4CEF7;
	Tue, 31 Mar 2026 00:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917789;
	bh=g3qNa4YRTdbS45Ks5WjESt3TtkwX9s8Ho/7Owzy4Rik=;
	h=Date:To:From:Subject:From;
	b=bsLU4/KIBR++0jVYo6tqDXWFxN1vLpHXS6ue7RuQGar+bYJhv7HPZM9s1FIQYX1Eg
	 kTn1MQ+H2j4BvURgriSUBrkVsOJoYXYIsDTVgFHj8tW7RTOhzI49Z9ibGml86c/NyX
	 qgbbHG/6TkeEsGmhYj5gNWWuT7RafK/Pb7AkC3D0=
Date: Mon, 30 Mar 2026 17:43:08 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch removed from -mm tree
Message-Id: <20260331004309.67452C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: remove superfluous map->hold_file_rmap_lock
has been removed from the -mm tree.  Its filename was
     mm-vma-remove-superfluous-map-hold_file_rmap_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/vma: remove superfluous map->hold_file_rmap_lock
Date: Fri, 20 Mar 2026 22:39:32 +0000

We don't need to reference this field, it's confusing as it duplicates
mmap_action->hide_from_rmap_until_complete, so thread the mmap_action
through to __mmap_new_vma() instead and use the same field consistently.

Link: https://lkml.kernel.org/r/42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bodo Stroesser <bostroesser@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Long Li <longli@microsoft.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/vma.c~mm-vma-remove-superfluous-map-hold_file_rmap_lock
+++ a/mm/vma.c
@@ -38,8 +38,6 @@ struct mmap_state {
 
 	/* Determine if we can check KSM flags early in mmap() logic. */
 	bool check_ksm_early :1;
-	/* If we map new, hold the file rmap lock on mapping. */
-	bool hold_file_rmap_lock :1;
 	/* If .mmap_prepare changed the file, we don't need to pin. */
 	bool file_doesnt_need_get :1;
 };
@@ -2530,10 +2528,12 @@ static int __mmap_new_file_vma(struct mm
  *
  * @map:  Mapping state.
  * @vmap: Output pointer for the new VMA.
+ * @action: Any mmap_prepare action that is still to complete.
  *
  * Returns: Zero on success, or an error.
  */
-static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
+static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
+	struct mmap_action *action)
 {
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
@@ -2582,7 +2582,7 @@ static int __mmap_new_vma(struct mmap_st
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
-	vma_link_file(vma, map->hold_file_rmap_lock);
+	vma_link_file(vma, action->hide_from_rmap_until_complete);
 
 	/*
 	 * vma_merge_new_range() calls khugepaged_enter_vma() too, the below
@@ -2649,8 +2649,6 @@ static int call_action_prepare(struct mm
 	if (err)
 		return err;
 
-	if (desc->action.hide_from_rmap_until_complete)
-		map->hold_file_rmap_lock = true;
 	return 0;
 }
 
@@ -2740,7 +2738,7 @@ static int call_action_complete(struct m
 	err = mmap_action_complete(vma, action);
 
 	/* If we held the file rmap we need to release it. */
-	if (map->hold_file_rmap_lock) {
+	if (action->hide_from_rmap_until_complete) {
 		struct file *file = vma->vm_file;
 
 		i_mmap_unlock_write(file->f_mapping);
@@ -2794,7 +2792,7 @@ static unsigned long __mmap_region(struc
 
 	/* ...but if we can't, allocate a new VMA. */
 	if (!vma) {
-		error = __mmap_new_vma(&map, &vma);
+		error = __mmap_new_vma(&map, &vma, &desc.action);
 		if (error)
 			goto unacct_error;
 		allocated_new = true;
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

