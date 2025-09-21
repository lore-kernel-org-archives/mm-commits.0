Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679C6298CCF
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489845; cv=none; b=mkxI00pO4mnXMCxEW3Uoae7yayOblEkhBCHem3ez4cgSE5pNh/+XUteOf+yImQKUcizXEk/9lwVz1PNF+LUC/fK0BmEGIOOEGsv7ansjAhK+vFDse7Zv+J7MYGu7Erw924aZ5w1LMehKgnF76YVyhlKpmUXLIkyc+SclWD5F7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489845; c=relaxed/simple;
	bh=RAdkQXp5Eee1LtH7UefSPvD4KAxtmLmLEMensH5Gpqo=;
	h=Date:To:From:Subject:Message-Id; b=bxNDjzn/dhniTWhvnzbznRwt8C4/y+pzggQzOCiIXM/4jelltvUTcuKlqsvorHkhxKvdFldrRO6YZ3oC+/P3ds6jgB6XGUPuvd3ufrsQzeGTBnmjXvBGf/TzJ4ctDFn51+GAmdn/ljDaIb6AxGzJvb5NSAtnJ6mk5wH6bjEdGCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PyfqvHS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PyfqvHS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B970C4CEE7;
	Sun, 21 Sep 2025 21:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489845;
	bh=RAdkQXp5Eee1LtH7UefSPvD4KAxtmLmLEMensH5Gpqo=;
	h=Date:To:From:Subject:From;
	b=PyfqvHS8eyW4Zke1IYhKy7EGuzt/JGIgDt5N3znJGIC4XTn3nrBnqhxhezTII/0H3
	 hvOVV9NlD0n0AGGpNJZWZUUdz2ZFw8iMKMP2XHCz1PRrKEyhH1JSUEGK3Wqg8NZI4E
	 /1kYoQEHKqgfYAQqOJIxwJHfr3HYoUy+bXq+mzoc=
Date: Sun, 21 Sep 2025 14:24:04 -0700
To: mm-commits@vger.kernel.org,yishaih@nvidia.com,shameerali.kolothum.thodi@huawei.com,lorenzo.stoakes@oracle.com,kevin.tian@intel.com,jgg@ziepe.ca,brett.creeley@amd.com,alex.williamson@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vfio-pci-drop-nth_page-usage-within-sg-entry.patch removed from -mm tree
Message-Id: <20250921212405.3B970C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vfio/pci: drop nth_page() usage within SG entry
has been removed from the -mm tree.  Its filename was
     vfio-pci-drop-nth_page-usage-within-sg-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: vfio/pci: drop nth_page() usage within SG entry
Date: Mon, 1 Sep 2025 17:03:53 +0200

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Link: https://lkml.kernel.org/r/20250901150359.867252-33-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/pds/lm.c         |    3 +--
 drivers/vfio/pci/virtio/migrate.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/vfio/pci/pds/lm.c~vfio-pci-drop-nth_page-usage-within-sg-entry
+++ a/drivers/vfio/pci/pds/lm.c
@@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_pa
 			lm_file->last_offset_sg = sg;
 			lm_file->sg_last_entry += i;
 			lm_file->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
--- a/drivers/vfio/pci/virtio/migrate.c~vfio-pci-drop-nth_page-usage-within-sg-entry
+++ a/drivers/vfio/pci/virtio/migrate.c
@@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virti
 			buf->last_offset_sg = sg;
 			buf->sg_last_entry += i;
 			buf->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
_

Patches currently in -mm which might be from david@redhat.com are


