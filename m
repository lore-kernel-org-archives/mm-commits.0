From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch removed
 from -mm tree
Date: Fri, 08 Aug 2014 13:58:21 -0700
Message-ID: <53e539ed.Ca93GwGQPjXE7qFY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:56351 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbaHHU6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:58:22 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so252116igd.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:58:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, david.vrabel@citrix.com, drjones@redhat.com, holzheu@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore: skip non-ram pages reported by hypervisors
has been removed from the -mm tree.  Its filename was
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch

This patch was dropped because it was folded into mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: mmap_vmcore: skip non-ram pages reported by hypervisors

Changes from v5:
- make len size_t to match do_unmap() interface

Changes from v4:
- change map_size type size_t -> unsigned long
- use prot instead of vma->vm_page_prot inside remap_oldmem_pfn_checked()

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6
+++ a/fs/proc/vmcore.c
@@ -344,10 +344,10 @@ static int remap_oldmem_pfn_checked(stru
 				    unsigned long from, unsigned long pfn,
 				    unsigned long size, pgprot_t prot)
 {
-	size_t map_size;
+	unsigned long map_size;
 	unsigned long pos_start, pos_end, pos;
 	unsigned long zeropage_pfn = my_zero_pfn(0);
-	u64 len = 0;
+	size_t len = 0;
 
 	pos_start = pfn;
 	pos_end = pfn + (size >> PAGE_SHIFT);
@@ -381,7 +381,7 @@ static int remap_oldmem_pfn_checked(stru
 		/* Remap the rest */
 		map_size = (pos - pos_start) << PAGE_SHIFT;
 		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
-					   map_size, vma->vm_page_prot))
+					   map_size, prot))
 			goto fail;
 		len += map_size;
 	}
_

Patches currently in -mm which might be from vkuznets@redhat.com are

mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch

