From: akpm@linux-foundation.org
Subject: + mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch added to -mm tree
Date: Mon, 14 Jul 2014 13:05:51 -0700
Message-ID: <53c4381f.3nRuWLWuni/p6rLe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:63492 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbaGNUFw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 16:05:52 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so902085obc.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 13:05:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, david.vrabel@citrix.com, drjones@redhat.com, holzheu@linux.vnet.ibm.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore: skip non-ram pages reported by hypervisors
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -344,10 +344,10 @@ int remap_oldmem_pfn_checked(struct vm_a
 			     unsigned long pfn, unsigned long size,
 			     pgprot_t prot)
 {
-	size_t map_size;
+	unsigned long map_size;
 	unsigned long pos_start, pos_end, pos;
 	unsigned long zeropage_pfn = my_zero_pfn(0);
-	u64 len = 0;
+	size_t len = 0;
 
 	pos_start = pfn;
 	pos_end = pfn + (size >> PAGE_SHIFT);
@@ -381,7 +381,7 @@ int remap_oldmem_pfn_checked(struct vm_a
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
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch

