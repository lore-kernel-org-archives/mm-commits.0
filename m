From: akpm@linux-foundation.org
Subject: [merged] mm-implement-map_pages-for-shmem-tmpfs.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 13:43:23 -0700
Message-ID: <53445f6b.Ao3R3dGGzDRF4JuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaDHUnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mgorman@suse.de, kirill@shutemov.name, hughd@google.com, david@fromorbit.com, dave.hansen@linux.intel.com, quning@google.com

Subject: [merged] mm-implement-map_pages-for-shmem-tmpfs.patch removed from -mm tree
To: quning@google.com,dave.hansen@linux.intel.com,david@fromorbit.com,hughd@google.com,kirill@shutemov.name,mgorman@suse.de,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:43:23 -0700


The patch titled
     Subject: mm: implement ->map_pages for shmem/tmpfs
has been removed from the -mm tree.  Its filename was
     mm-implement-map_pages-for-shmem-tmpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ning Qu <quning@google.com>
Subject: mm: implement ->map_pages for shmem/tmpfs

In shmem/tmpfs, we also use the generic filemap_map_pages, seems the
additional checking is not worth a separate version of map_pages for it.

Signed-off-by: Ning Qu <quning@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~mm-implement-map_pages-for-shmem-tmpfs mm/shmem.c
--- a/mm/shmem.c~mm-implement-map_pages-for-shmem-tmpfs
+++ a/mm/shmem.c
@@ -2723,6 +2723,7 @@ static const struct super_operations shm
 
 static const struct vm_operations_struct shmem_vm_ops = {
 	.fault		= shmem_fault,
+	.map_pages	= filemap_map_pages,
 #ifdef CONFIG_NUMA
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
_

Patches currently in -mm which might be from quning@google.com are

origin.patch

