Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168725782A
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917804; cv=none; b=XWeMbPSQo2ettIM9ZFJmOk2CZBppPShdpqm4N0rgRzay+aee0sdo+jg/GOB74HMUsfpy8Dulgp0BT20KKjxidMwvHuZcMWRBBwS3dyHOxP4fL2zrgID1XDTreTcWCiwFmOLfrcF7ZjspAQsFKXEbKX7R65Aob1lxCdAXmmKHz50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917804; c=relaxed/simple;
	bh=e8MOX1PhHQluzDj4qohXR6CoCojogvWKiFDGdjsZBwk=;
	h=Date:To:From:Subject:Message-Id; b=aZoOj/m3t+kMZqyznq2is7mssg2iKYz4VAvs/lMOlITxsz2VOB5OpWnQkh168rSyVEROgJFVVBXMJSNrnNI0e1V+9YEUY3dRXQja9OiZcxLabzsDsBMfMX9siFTt4qW5QDmsK6tGK+8sEoAzZ0wjbwJR3Ak3WOMZgRroNjG6vC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FU0jv7BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FU0jv7BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB75C4CEF7;
	Tue, 31 Mar 2026 00:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917804;
	bh=e8MOX1PhHQluzDj4qohXR6CoCojogvWKiFDGdjsZBwk=;
	h=Date:To:From:Subject:From;
	b=FU0jv7BB0hWgC1lL9aswJtTX22INEgThGGmEdU2QnalZTDCg3CiQb+OYi33Ke88/E
	 mrm7l3XIN0pulcXKH4w5En/UhudtdBzqO1dEu5IE+Rt0kBbVDcYqBw9geALoi7HTZ4
	 7OAdRbqpy94oxIfa7G70yik92dwU80OILGtQMVPY=
Date: Mon, 30 Mar 2026 17:43:23 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,viro@zeniv.linux.org.uk,vigneshr@ti.com,vbabka@kernel.org,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,richard@nod.at,pfalcato@suse.de,miquel.raynal@bootlin.com,mhocko@suse.com,mcoquelin.stm32@gmail.com,martin.petersen@oracle.com,marc.dionne@auristor.com,longli@microsoft.com,liam.howlett@oracle.com,kys@microsoft.com,jannh@google.com,jack@suse.cz,haiyangz@microsoft.com,gregkh@linuxfoundation.org,dhowells@redhat.com,decui@microsoft.com,david@kernel.org,corbet@lwn.net,clemens@ladisch.de,brauner@kernel.org,bostroesser@gmail.com,arnd@arndb.de,alexandre.torgue@foss.st.com,alexander.shishkin@linux.intel.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch removed from -mm tree
Message-Id: <20260331004323.DBB75C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
has been removed from the -mm tree.  Its filename was
     mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mtdchar: replace deprecated mmap hook with mmap_prepare, clean up
Date: Fri, 20 Mar 2026 22:39:40 +0000

Replace the deprecated mmap callback with mmap_prepare.

Commit f5cf8f07423b ("mtd: Disable mtdchar mmap on MMU systems") commented
out the CONFIG_MMU part of this function back in 2012, so after ~14 years
it's probably reasonable to remove this altogether rather than updating
dead code.

Link: https://lkml.kernel.org/r/d036855c21962c58ace0eb24ecd6d973d77424fe.1774045440.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: Richard Weinberger <richard@nod.at>
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdchar.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

--- a/drivers/mtd/mtdchar.c~mtdchar-replace-deprecated-mmap-hook-with-mmap_prepare-clean-up
+++ a/drivers/mtd/mtdchar.c
@@ -1376,27 +1376,12 @@ static unsigned mtdchar_mmap_capabilitie
 /*
  * set up a mapping for shared memory segments
  */
-static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
+static int mtdchar_mmap_prepare(struct vm_area_desc *desc)
 {
 #ifdef CONFIG_MMU
-	struct mtd_file_info *mfi = file->private_data;
-	struct mtd_info *mtd = mfi->mtd;
-	struct map_info *map = mtd->priv;
-
-        /* This is broken because it assumes the MTD device is map-based
-	   and that mtd->priv is a valid struct map_info.  It should be
-	   replaced with something that uses the mtd_get_unmapped_area()
-	   operation properly. */
-	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-#ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
-			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
-		return vm_iomap_memory(vma, map->phys, map->size);
-	}
 	return -ENODEV;
 #else
-	return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
+	return vma_desc_test(desc, VMA_SHARED_BIT) ? 0 : -EACCES;
 #endif
 }
 
@@ -1411,7 +1396,7 @@ static const struct file_operations mtd_
 #endif
 	.open		= mtdchar_open,
 	.release	= mtdchar_close,
-	.mmap		= mtdchar_mmap,
+	.mmap_prepare	= mtdchar_mmap_prepare,
 #ifndef CONFIG_MMU
 	.get_unmapped_area = mtdchar_get_unmapped_area,
 	.mmap_capabilities = mtdchar_mmap_capabilities,
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

