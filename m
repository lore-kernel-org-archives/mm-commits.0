Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E984A2D12ED
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917808; cv=none; b=NXvQnzm20nsXR8GOUGSmpQMSGbyo1tKQNHbKiqdlIJNcyWF7j7Jy+f+eGX6PJPISedSCXJTWBpV5CEJuCJDayiJpMDaIoNGxi/3iXARNqqjNe38msjw8UARbcIbjKL19lrwdccR5YjSBLB6iDNnXO+S3/dNPBV+EkZOQXwFdvCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917808; c=relaxed/simple;
	bh=BhzC1HPsR+1k4Wes38MYFrRoc5EOHqfKWtLHmnUeTl8=;
	h=Date:To:From:Subject:Message-Id; b=qAAwyB2/rV2ChwrdOX7BOHNhVrCVkqtXRBJrM+P3xT+ZVN06vMb90slTWCe+tMBwJ1DwZmWloikCQfoXAVrHQ1LkOwPn8v1eTgpfEVBb4xy5IyPm+XUhRF+Wpy73/RhUZLsPCI8x75Qpw0KAMe5unR9ohsUD9WCa0BzFo8UxuG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=peuRR6hW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="peuRR6hW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD65C4CEF7;
	Tue, 31 Mar 2026 00:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917807;
	bh=BhzC1HPsR+1k4Wes38MYFrRoc5EOHqfKWtLHmnUeTl8=;
	h=Date:To:From:Subject:From;
	b=peuRR6hWWygOg4oDSLj6AloLmEqKieI3q7LgWhnVv3ZpJyP6hmUIhYIG+8A1oQs+k
	 tpJMA0Z2TO9l6U/kjWSKUaDPkRNfbpeiLQWFDIGieOIp9lZy96RV5t1fQA69Qqrb/H
	 0BjgKTLVKrfAY2oM7jlQTPBDeWLRdSShcsrfemmI=
Date: Mon, 30 Mar 2026 17:43:27 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch removed from -mm tree
Message-Id: <20260331004327.BBD65C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: staging: vme_user: replace deprecated mmap hook with mmap_prepare
has been removed from the -mm tree.  Its filename was
     staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: staging: vme_user: replace deprecated mmap hook with mmap_prepare
Date: Fri, 20 Mar 2026 22:39:42 +0000

The f_op->mmap interface is deprecated, so update driver to use its
successor, mmap_prepare.

The driver previously used vm_iomap_memory(), so this change replaces it
with its mmap_prepare equivalent, mmap_action_simple_ioremap().

Functions that wrap mmap() are also converted to wrap mmap_prepare()
instead.

Also update the documentation accordingly.

Link: https://lkml.kernel.org/r/08ecc1e1d319564fd49b9e9012f994edaff921db.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/vme.rst    |    2 -
 drivers/staging/vme_user/vme.c      |   20 +++++-----
 drivers/staging/vme_user/vme.h      |    2 -
 drivers/staging/vme_user/vme_user.c |   51 +++++++++++++++-----------
 4 files changed, 42 insertions(+), 33 deletions(-)

--- a/Documentation/driver-api/vme.rst~staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare
+++ a/Documentation/driver-api/vme.rst
@@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` c
 
 In addition to simple reads and writes, :c:func:`vme_master_rmw` is provided to
 do a read-modify-write transaction. Parts of a VME window can also be mapped
-into user space memory using :c:func:`vme_master_mmap`.
+into user space memory using :c:func:`vme_master_mmap_prepare`.
 
 
 Slave windows
--- a/drivers/staging/vme_user/vme.c~staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare
+++ a/drivers/staging/vme_user/vme.c
@@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_r
 EXPORT_SYMBOL(vme_master_rmw);
 
 /**
- * vme_master_mmap - Mmap region of VME master window.
+ * vme_master_mmap_prepare - Mmap region of VME master window.
  * @resource: Pointer to VME master resource.
- * @vma: Pointer to definition of user mapping.
+ * @desc: Pointer to descriptor of user mapping.
  *
  * Memory map a region of the VME master window into user space.
  *
@@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
  *         resource or -EFAULT if map exceeds window size. Other generic mmap
  *         errors may also be returned.
  */
-int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma)
+int vme_master_mmap_prepare(struct vme_resource *resource,
+			    struct vm_area_desc *desc)
 {
+	const unsigned long vma_size = vma_desc_size(desc);
 	struct vme_bridge *bridge = find_bridge(resource);
 	struct vme_master_resource *image;
 	phys_addr_t phys_addr;
-	unsigned long vma_size;
 
 	if (resource->type != VME_MASTER) {
 		dev_err(bridge->parent, "Not a master resource\n");
@@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource
 	}
 
 	image = list_entry(resource->entry, struct vme_master_resource, list);
-	phys_addr = image->bus_resource.start + (vma->vm_pgoff << PAGE_SHIFT);
-	vma_size = vma->vm_end - vma->vm_start;
+	phys_addr = image->bus_resource.start + (desc->pgoff << PAGE_SHIFT);
 
 	if (phys_addr + vma_size > image->bus_resource.end + 1) {
 		dev_err(bridge->parent, "Map size cannot exceed the window size\n");
 		return -EFAULT;
 	}
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_start);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+	mmap_action_simple_ioremap(desc, phys_addr, vma_size);
+	return 0;
 }
-EXPORT_SYMBOL(vme_master_mmap);
+EXPORT_SYMBOL(vme_master_mmap_prepare);
 
 /**
  * vme_master_free - Free VME master window
--- a/drivers/staging/vme_user/vme.h~staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare
+++ a/drivers/staging/vme_user/vme.h
@@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resou
 ssize_t vme_master_write(struct vme_resource *resource, void *buf, size_t count, loff_t offset);
 unsigned int vme_master_rmw(struct vme_resource *resource, unsigned int mask, unsigned int compare,
 			    unsigned int swap, loff_t offset);
-int vme_master_mmap(struct vme_resource *resource, struct vm_area_struct *vma);
+int vme_master_mmap_prepare(struct vme_resource *resource, struct vm_area_desc *desc);
 void vme_master_free(struct vme_resource *resource);
 
 struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 route);
--- a/drivers/staging/vme_user/vme_user.c~staging-vme_user-replace-deprecated-mmap-hook-with-mmap_prepare
+++ a/drivers/staging/vme_user/vme_user.c
@@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_
 	kfree(vma_priv);
 }
 
-static const struct vm_operations_struct vme_user_vm_ops = {
-	.open = vme_user_vm_open,
-	.close = vme_user_vm_close,
-};
-
-static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
+static int vme_user_vm_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+			      const struct file *file, void **vm_private_data)
 {
-	int err;
+	const unsigned int minor = iminor(file_inode(file));
 	struct vme_user_vma_priv *vma_priv;
 
 	mutex_lock(&image[minor].mutex);
 
-	err = vme_master_mmap(image[minor].resource, vma);
-	if (err) {
-		mutex_unlock(&image[minor].mutex);
-		return err;
-	}
-
 	vma_priv = kmalloc_obj(*vma_priv);
 	if (!vma_priv) {
 		mutex_unlock(&image[minor].mutex);
@@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned
 
 	vma_priv->minor = minor;
 	refcount_set(&vma_priv->refcnt, 1);
-	vma->vm_ops = &vme_user_vm_ops;
-	vma->vm_private_data = vma_priv;
-
+	*vm_private_data = vma_priv;
 	image[minor].mmap_count++;
 
 	mutex_unlock(&image[minor].mutex);
-
 	return 0;
 }
 
-static int vme_user_mmap(struct file *file, struct vm_area_struct *vma)
+static const struct vm_operations_struct vme_user_vm_ops = {
+	.mapped = vme_user_vm_mapped,
+	.open = vme_user_vm_open,
+	.close = vme_user_vm_close,
+};
+
+static int vme_user_master_mmap_prepare(unsigned int minor,
+					struct vm_area_desc *desc)
+{
+	int err;
+
+	mutex_lock(&image[minor].mutex);
+
+	err = vme_master_mmap_prepare(image[minor].resource, desc);
+	if (!err)
+		desc->vm_ops = &vme_user_vm_ops;
+
+	mutex_unlock(&image[minor].mutex);
+	return err;
+}
+
+static int vme_user_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned int minor = iminor(file_inode(file));
+	const struct file *file = desc->file;
+	const unsigned int minor = iminor(file_inode(file));
 
 	if (type[minor] == MASTER_MINOR)
-		return vme_user_master_mmap(minor, vma);
+		return vme_user_master_mmap_prepare(minor, desc);
 
 	return -ENODEV;
 }
@@ -498,7 +507,7 @@ static const struct file_operations vme_
 	.llseek = vme_user_llseek,
 	.unlocked_ioctl = vme_user_unlocked_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
-	.mmap = vme_user_mmap,
+	.mmap_prepare = vme_user_mmap_prepare,
 };
 
 static int vme_user_match(struct vme_dev *vdev)
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

