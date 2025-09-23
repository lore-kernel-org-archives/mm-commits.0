Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AE9245005
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597503; cv=none; b=EUavZh4XLJZwck0M11fhCTIvdVSJpVL8lI5uGqYdEUU89gRi4xY6k/oxidwZLpP4mWqZPIFTuMT+no8cpX9oHVMaoImH1C36e5eOoLelhQdpHcUHz4QpR8jJGpjS6J2ZC5uTOL5y7vH9jNsXh4yJcL8GFoHH768HDNsF9Z6r18A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597503; c=relaxed/simple;
	bh=/yNG+Lx0mSyfepk0soWllhZiG/ehLvKu8SGSpXN7bbg=;
	h=Date:To:From:Subject:Message-Id; b=E0PdwxN67WYg/cE+CNllkiFvwgPoO2b3XHTrWMR/M2Nya/5BMWFRqGDXu3O7bnTjtpnzDbfc+HBoe72+3zpbWx332HSnBWYCVVqHRnzW9LH53ONmS3qL0fZDf62v7/3BeDS5ZrdtWhSSioYeFCZOaKhKdLZj0BrhZbIFCP5R8fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1pH6NXe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1pH6NXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65CBCC4CEF0;
	Tue, 23 Sep 2025 03:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597501;
	bh=/yNG+Lx0mSyfepk0soWllhZiG/ehLvKu8SGSpXN7bbg=;
	h=Date:To:From:Subject:From;
	b=t1pH6NXea/Q7B4wCzE46W7/lHpf6h0ItBiZsqvjVUj7OwPjpRqxefzoE2IW+f6H05
	 8MssKmVPQ13aB9W7itixIb/CAuIvNZlbiOkfGyZHsp7V8EQFXSXKd5Z7YCcb6GaCti
	 4UxcBNexqSmsVzPTXpy2LvyabxBT2p42CinV++s8=
Date: Mon, 22 Sep 2025 20:18:20 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-resctl-to-use-mmap_prepare.patch removed from -mm tree
Message-Id: <20250923031821.65CBCC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update resctl to use mmap_prepare
has been removed from the -mm tree.  Its filename was
     mm-update-resctl-to-use-mmap_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update resctl to use mmap_prepare
Date: Wed, 17 Sep 2025 20:11:16 +0100

Make use of the ability to specify a remap action within mmap_prepare to
update the resctl pseudo-lock to use mmap_prepare in favour of the
deprecated mmap hook.

Link: https://lkml.kernel.org/r/ed05dfdff6f77e33628784b6492f66f347673b50.1758135681.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/resctrl/pseudo_lock.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/fs/resctrl/pseudo_lock.c~mm-update-resctl-to-use-mmap_prepare
+++ a/fs/resctrl/pseudo_lock.c
@@ -995,10 +995,11 @@ static const struct vm_operations_struct
 	.mremap = pseudo_lock_dev_mremap,
 };
 
-static int pseudo_lock_dev_mmap(struct file *filp, struct vm_area_struct *vma)
+static int pseudo_lock_dev_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned long vsize = vma->vm_end - vma->vm_start;
-	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long off = desc->pgoff << PAGE_SHIFT;
+	unsigned long vsize = vma_desc_size(desc);
+	struct file *filp = desc->file;
 	struct pseudo_lock_region *plr;
 	struct rdtgroup *rdtgrp;
 	unsigned long physical;
@@ -1043,7 +1044,7 @@ static int pseudo_lock_dev_mmap(struct f
 	 * Ensure changes are carried directly to the memory being mapped,
 	 * do not allow copy-on-write mapping.
 	 */
-	if (!(vma->vm_flags & VM_SHARED)) {
+	if (!(desc->vm_flags & VM_SHARED)) {
 		mutex_unlock(&rdtgroup_mutex);
 		return -EINVAL;
 	}
@@ -1055,12 +1056,9 @@ static int pseudo_lock_dev_mmap(struct f
 
 	memset(plr->kmem + off, 0, vsize);
 
-	if (remap_pfn_range(vma, vma->vm_start, physical + vma->vm_pgoff,
-			    vsize, vma->vm_page_prot)) {
-		mutex_unlock(&rdtgroup_mutex);
-		return -EAGAIN;
-	}
-	vma->vm_ops = &pseudo_mmap_ops;
+	desc->vm_ops = &pseudo_mmap_ops;
+	mmap_action_remap_full(desc, physical + desc->pgoff);
+
 	mutex_unlock(&rdtgroup_mutex);
 	return 0;
 }
@@ -1071,7 +1069,7 @@ static const struct file_operations pseu
 	.write =	NULL,
 	.open =		pseudo_lock_dev_open,
 	.release =	pseudo_lock_dev_release,
-	.mmap =		pseudo_lock_dev_mmap,
+	.mmap_prepare =	pseudo_lock_dev_mmap_prepare,
 };
 
 int rdt_pseudo_lock_init(void)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


