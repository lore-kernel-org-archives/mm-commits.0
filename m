Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF63C37711;
	Thu,  8 Feb 2024 20:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423571; cv=none; b=kmoFPCLffG8yLvR6jkV2avvPjq97q7KGGMj9Lz1xM2vVHsOwTe7XeYZCC9M+QKjse3TslU/gI2KQ2cgJrXYxxyylf07Fko6YgrPR4PdWHyf6yOSAC8V/VqcJH9zPrSAr+G1+ko7QuL4Y/txGUc9VG50rU3kZfSDccPo/PjuLG98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423571; c=relaxed/simple;
	bh=JEHF3L83Ez5X9HIZXdBgzhVChwblAjDq3m5eCli5fME=;
	h=Date:To:From:Subject:Message-Id; b=ndTK4AoMX5LDFTHS4FYdIRxkR5kWc6Q6n6HvJCFPLIlIHwzE6t5PJI/dFH3tKgitjyiyBMyclfClvRkNsNUfHx9TQn4uHUGERvow4TsoE2zo0uPE8IEOKIpz6QpFyOOaMWyh5m2NnD4tQzT6iGn3zQ+q330WNrKhl8SSgLjrA08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fINuTcV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fINuTcV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D292C433F1;
	Thu,  8 Feb 2024 20:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707423570;
	bh=JEHF3L83Ez5X9HIZXdBgzhVChwblAjDq3m5eCli5fME=;
	h=Date:To:From:Subject:From;
	b=fINuTcV8E2IX3DHD5G5DIZpRm2fzUg0yLJeA9SuTnjlbVUS8f8jLz3/kWL1qn2B3c
	 vI9nMFxSJ4fp983NF9z0omI7F7+6WnGpPg8NuFurwmuf/h9xyECQLySCnIF9cRCidA
	 oXsws0KnlJg9WVbWpqNCRwXF37hWlDSsHNXWA7eg=
Date: Thu, 08 Feb 2024 12:19:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,tvrtko.ursulin@linux.intel.com,stable@vger.kernel.org,rodrigo.vivi@intel.com,ray.huang@amd.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jarkko@kernel.org,jani.nikula@linux.intel.com,hughd@google.com,djwong@kernel.org,dhowells@redhat.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,christian.koenig@amd.com,chandan.babu@oracle.com,airlied@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-add-a-mapping_clear_large_folios-helper.patch removed from -mm tree
Message-Id: <20240208201930.3D292C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add a mapping_clear_large_folios helper
has been removed from the -mm tree.  Its filename was
     mm-add-a-mapping_clear_large_folios-helper.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: add a mapping_clear_large_folios helper
Date: Wed, 10 Jan 2024 10:21:08 +0100

Patch series "disable large folios for shmem file used by xfs xfile".

Darrick reported that the fairly new XFS xfile code blows up when force
enabling large folio for shmem.  This series fixes this quickly by
disabling large folios for this particular shmem file for now until it can
be fixed properly, which will be a lot more invasive.


This patch (of 2):

Users of shmem_kernel_file_setup might not be able to deal with large
folios (yet).  Give them a way to disable large folio support on their
mapping.

Link: https://lkml.kernel.org/r/20240110092109.1950011-1-hch@lst.de
Link: https://lkml.kernel.org/r/20240110092109.1950011-2-hch@lst.de
Fixes: 3934e8ebb7cc ("xfs: create a big array data structure")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/include/linux/pagemap.h~mm-add-a-mapping_clear_large_folios-helper
+++ a/include/linux/pagemap.h
@@ -360,6 +360,20 @@ static inline void mapping_set_large_fol
 	__set_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
 }
 
+/**
+ * mapping_clear_large_folios() - Disable large folio support for a mapping
+ * @mapping: The mapping.
+ *
+ * This can be called to undo the effect of mapping_set_large_folios().
+ *
+ * Context: This should not be called while the inode is active as it
+ * is non-atomic.
+ */
+static inline void mapping_clear_large_folios(struct address_space *mapping)
+{
+	__clear_bit(AS_LARGE_FOLIO_SUPPORT, &mapping->flags);
+}
+
 /*
  * Large folio support currently depends on THP.  These dependencies are
  * being worked on but are not yet fixed.
_

Patches currently in -mm which might be from hch@lst.de are

xfs-disable-large-folio-support-in-xfile_create.patch

