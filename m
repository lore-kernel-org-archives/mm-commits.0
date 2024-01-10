Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336654BA9C;
	Wed, 10 Jan 2024 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rUNIu27o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4ABC43390;
	Wed, 10 Jan 2024 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704901335;
	bh=lgBhteLAx1FByiMEbREllr2C5IQMJgtcd/RLMHa+nrs=;
	h=Date:To:From:Subject:From;
	b=rUNIu27oBWRx2YjX/x8L6wcTPNB1rF3SW9Mq0dq2IJ1uzXC/wDRtdvu4zc3Cm1JZ4
	 4QsfJFb2ZSu58n2gYIaT7KVOpsei7tzVd5DQZ/5pz3XhPogDFi9pqki5pBSthctDRp
	 DquxTDSGzvwquktViiNmCBPxs2BpWFGQeMD0OaG0=
Date: Wed, 10 Jan 2024 07:42:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,tvrtko.ursulin@linux.intel.com,stable@vger.kernel.org,rodrigo.vivi@intel.com,ray.huang@amd.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jarkko@kernel.org,jani.nikula@linux.intel.com,hughd@google.com,djwong@kernel.org,dhowells@redhat.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,christian.koenig@amd.com,chandan.babu@oracle.com,airlied@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-a-mapping_clear_large_folios-helper.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110154215.8D4ABC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add a mapping_clear_large_folios helper
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-a-mapping_clear_large_folios-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-a-mapping_clear_large_folios-helper.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Fixes: 137db333b2918 ("xfs: teach xfile to pass back direct-map pages to caller")
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
@@ -343,6 +343,20 @@ static inline void mapping_set_large_fol
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

mm-add-a-mapping_clear_large_folios-helper.patch
xfs-disable-large-folio-support-in-xfile_create.patch

