From: akpm@linux-foundation.org
Subject: [folded-merged]
 mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch removed
 from -mm tree
Date: Fri, 08 Aug 2014 13:58:23 -0700
Message-ID: <53e539ef.X12Js14fnpQPGK/Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:47127 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933185AbaHHU6Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:58:25 -0400
Received: by mail-qg0-f74.google.com with SMTP id z60so808975qgd.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:58:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7
has been removed from the -mm tree.  Its filename was
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch

This patch was dropped because it was folded into mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7

Changes from v6:
- remove useless len increment when remapping the rest of the region

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7 fs/proc/vmcore.c
--- a/fs/proc/vmcore.c~mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7
+++ a/fs/proc/vmcore.c
@@ -383,7 +383,6 @@ static int remap_oldmem_pfn_checked(stru
 		if (remap_oldmem_pfn_range(vma, from + len, pos_start,
 					   map_size, prot))
 			goto fail;
-		len += map_size;
 	}
 	return 0;
 fail:
_

Patches currently in -mm which might be from vkuznets@redhat.com are

mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch

