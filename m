From: akpm@linux-foundation.org
Subject: + mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch added to -mm tree
Date: Tue, 15 Jul 2014 14:09:48 -0700
Message-ID: <53c5989c.ZUMl5IO0MVsMdkNi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:39471 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaGOVJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jul 2014 17:09:49 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1313343obb.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2014 14:09:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7
has been added to the -mm tree.  Its filename is
     mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch

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
@@ -383,7 +383,6 @@ int remap_oldmem_pfn_checked(struct vm_a
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
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v6.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v7.patch

