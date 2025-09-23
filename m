Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD883A1CD
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597477; cv=none; b=FZTB1QC1SgT7QtKnQgdy8+bFuPK1WxwLinh+ZqBAlp8SpgU6HPMl+9QADnnD3MdTk3Mpdvea4GJ0y/eefMnsdC8zFeF9CgVWwLIb17bs0/LjMC+8pk2F22rbHUWk+6oNQ/dw0Q/+aUAFIOuL707lFL/pe/uAJQ6TjZ+hBPrR1UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597477; c=relaxed/simple;
	bh=0zMS1RGcPDQXtStyLRTh57AY8rzzCZRLMPDGZ751cJQ=;
	h=Date:To:From:Subject:Message-Id; b=ZjjRL4N8DGODiH8qFkfNpeJn8FVcIknReL0/rrgv1oaSlIbcC/iJqcI8j+e5Yn+hYcL7p6EE8GpgvjZ5hZBISuJ3MkMucdhyB3qmPj5a+ZihJaNhaiV1dp2OOAbR9X0Usb4wyG54n/PaSUPjoSUNZkQUXabKsDWc2MSLODl0BnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rYBRvOZe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rYBRvOZe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51CBC116B1;
	Tue, 23 Sep 2025 03:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597476;
	bh=0zMS1RGcPDQXtStyLRTh57AY8rzzCZRLMPDGZ751cJQ=;
	h=Date:To:From:Subject:From;
	b=rYBRvOZeO6rI0ENaNkyaGgQ+89CyCs63ngSkE34cc897Rab/g4OcrjGdozQZTDlHV
	 6Xrn5bSAd34sed7N3x2kDRlZyamDRwfqnBiUaVLwAe0PA5SQqx7yWWejDTfoMFfTnD
	 QdAYmlemfvQvOzfFTa8SXXYLiv5HiDOo5HpIJfuw=
Date: Mon, 22 Sep 2025 20:17:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch removed from -mm tree
Message-Id: <20250923031756.A51CBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: rename __mmap_prepare() function to avoid confusion
has been removed from the -mm tree.  Its filename was
     mm-vma-rename-__mmap_prepare-function-to-avoid-confusion.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: rename __mmap_prepare() function to avoid confusion
Date: Wed, 17 Sep 2025 20:11:07 +0100

Now we have the f_op->mmap_prepare() hook, having a static function called
__mmap_prepare() that has nothing to do with it is confusing, so rename
the function to __mmap_setup().

Link: https://lkml.kernel.org/r/24cdbee385fd734d9b1c5aa547d5bbf7a573f292.1758135681.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
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

 mm/vma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-vma-rename-__mmap_prepare-function-to-avoid-confusion
+++ a/mm/vma.c
@@ -2329,7 +2329,7 @@ static void update_ksm_flags(struct mmap
 }
 
 /*
- * __mmap_prepare() - Prepare to gather any overlapping VMAs that need to be
+ * __mmap_setup() - Prepare to gather any overlapping VMAs that need to be
  * unmapped once the map operation is completed, check limits, account mapping
  * and clean up any pre-existing VMAs.
  *
@@ -2338,7 +2338,7 @@ static void update_ksm_flags(struct mmap
  *
  * Returns: 0 on success, error code otherwise.
  */
-static int __mmap_prepare(struct mmap_state *map, struct list_head *uf)
+static int __mmap_setup(struct mmap_state *map, struct list_head *uf)
 {
 	int error;
 	struct vma_iterator *vmi = map->vmi;
@@ -2649,7 +2649,7 @@ static unsigned long __mmap_region(struc
 
 	map.check_ksm_early = can_set_ksm_flags_early(&map);
 
-	error = __mmap_prepare(&map, uf);
+	error = __mmap_setup(&map, uf);
 	if (!error && have_mmap_prepare)
 		error = call_mmap_prepare(&map);
 	if (error)
@@ -2679,7 +2679,7 @@ static unsigned long __mmap_region(struc
 
 	return addr;
 
-	/* Accounting was done by __mmap_prepare(). */
+	/* Accounting was done by __mmap_setup(). */
 unacct_error:
 	if (map.charged)
 		vm_unacct_memory(map.charged);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


