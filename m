Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517634BA9C;
	Wed, 10 Jan 2024 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JI8cJAUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D8CC43390;
	Wed, 10 Jan 2024 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704901337;
	bh=ZNu73zuf7NYTJBEkIYHcS8AYQ205RpbL6BfU2KD6CpI=;
	h=Date:To:From:Subject:From;
	b=JI8cJAUNZla5dQpPRSpeWC/1DmtSU08zPEnQa18QRMMW4aMVhnxEPrDiQ62xykvbN
	 x8XlOT71Et3CNQkklQpk1XofnTKrNs6ir/xqEPZRvARSBlYaJ02XNfNvqoqC6aBnym
	 q8CMuQDJrlwipVGdA5VL8eztR78pTJrQXLJ7bQp0=
Date: Wed, 10 Jan 2024 07:42:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,tvrtko.ursulin@linux.intel.com,stable@vger.kernel.org,rodrigo.vivi@intel.com,ray.huang@amd.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,joonas.lahtinen@linux.intel.com,jarkko@kernel.org,jani.nikula@linux.intel.com,hughd@google.com,djwong@kernel.org,dhowells@redhat.com,dave.hansen@linux.intel.com,daniel@ffwll.ch,christian.koenig@amd.com,chandan.babu@oracle.com,airlied@gmail.com,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-disable-large-folio-support-in-xfile_create.patch added to mm-hotfixes-unstable branch
Message-Id: <20240110154217.A1D8CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xfs: disable large folio support in xfile_create
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     xfs-disable-large-folio-support-in-xfile_create.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-disable-large-folio-support-in-xfile_create.patch

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
Subject: xfs: disable large folio support in xfile_create
Date: Wed, 10 Jan 2024 10:21:09 +0100

The xfarray code will crash if large folios are force enabled using:

   echo force > /sys/kernel/mm/transparent_hugepage/shmem_enabled

Fixing this will require a bit of an API change, and prefeably sorting out
the hwpoison story for pages vs folio and where it is placed in the shmem
API.  For now use this one liner to disable large folios.

Link: https://lkml.kernel.org/r/20240110092109.1950011-3-hch@lst.de
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
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

 fs/xfs/scrub/xfile.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/xfile.c~xfs-disable-large-folio-support-in-xfile_create
+++ a/fs/xfs/scrub/xfile.c
@@ -94,6 +94,11 @@ xfile_create(
 
 	lockdep_set_class(&inode->i_rwsem, &xfile_i_mutex_key);
 
+	/*
+	 * We're not quite ready for large folios yet.
+	 */
+	mapping_clear_large_folios(inode->i_mapping);
+
 	trace_xfile_create(xf);
 
 	*xfilep = xf;
_

Patches currently in -mm which might be from hch@lst.de are

mm-add-a-mapping_clear_large_folios-helper.patch
xfs-disable-large-folio-support-in-xfile_create.patch

