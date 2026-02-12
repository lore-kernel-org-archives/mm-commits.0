Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F452FD1B3
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933084; cv=none; b=ezaSbH+1C/3UTiNb8q8BSHlMfDvA/snqXLL9lxQZ+EPD4vKnm3zC+GdrKiADy9TviTC2UQHH6xUumcmwZjuXFTul7Yc3UMf/8uWnDZNVcu7EuMTZBjiCRI/KB5qFAXlvbX1UVdidaxikAzNT5q3QMwqUCIt24j6r3Gkld4FWAFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933084; c=relaxed/simple;
	bh=tAmt70kWEcDuTFZxkl/APBv3yiE2RfOAXBaEBn4QYG4=;
	h=Date:To:From:Subject:Message-Id; b=WaCG1/aZYiYLns2RMZVfOcbG22Tf7KkqkEG6kfVIkBq2iGYh93/QMBbr2IZmgrSl5f1GT+CTxi+/E8E184tUUzTYCQyUhCQO4zih2BJNuk6nB26pOcp/bAfhR5DsxeUwJSyapEVYeapIm/hU2+EAF+zRTY4n+uMjvgoVtkoh4Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cKeWoAyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cKeWoAyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E22EC4CEF7;
	Thu, 12 Feb 2026 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770933083;
	bh=tAmt70kWEcDuTFZxkl/APBv3yiE2RfOAXBaEBn4QYG4=;
	h=Date:To:From:Subject:From;
	b=cKeWoAyYdQqTr5OfHLi2lABQkdpuauZ4XX4ymUmF2c4N1eu/gKuBCjWUyDMbW28jo
	 qJGVjEO63xPmpkttg32GX8/IwiJmCQDiKeaJ2jMRB2pYHErsot9BDZmsSoKDFvJ/NB
	 ohfNajv9JOO108kPooLVRre5mK0KgNYFx4mg58pA=
Date: Thu, 12 Feb 2026 13:51:28 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch removed from -mm tree
Message-Id: <20260212215123.6E22EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
has been removed from the -mm tree.  Its filename was
     mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

This patch was dropped because it was folded into mm-update-shmem__file_-functions-to-use-vma_flags_t.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
Date: Thu Jan 22 10:34:19 PM PST 2026

comment fixes, per Baolin

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
+++ a/mm/shmem.c
@@ -5873,7 +5873,7 @@ static struct file *__shmem_file_setup(s
  *	checks are provided at the key or shm level rather than the inode.
  * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
- * @vma_flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
+ * @flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
  */
 struct file *shmem_kernel_file_setup(const char *name, loff_t size,
 				     vma_flags_t flags)
@@ -5886,7 +5886,7 @@ EXPORT_SYMBOL_GPL(shmem_kernel_file_setu
  * shmem_file_setup - get an unlinked file living in tmpfs
  * @name: name for dentry (to be seen in /proc/<pid>/maps)
  * @size: size to be set for the file
- * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ * @flags: VMA_NORESERVE_BIT suppresses pre-accounting of the entire object size
  */
 struct file *shmem_file_setup(const char *name, loff_t size, vma_flags_t flags)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch

