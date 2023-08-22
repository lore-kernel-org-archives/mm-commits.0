Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D68BEE4993
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 18:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjHVSSh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjHVSSg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 14:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F9511F
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 11:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD0C61D2D
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 18:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1071C433C8;
        Tue, 22 Aug 2023 18:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692728314;
        bh=YNoSMETIlchsYcnnbaVjnRFYBizzydBAN/sXtogqTVg=;
        h=Date:To:From:Subject:From;
        b=nxXFQ6Pgaebh/JdKKFTDohnc/B/tt7EWx4NRy0K/iC+xwGGW4+ibRj4pf1rHapnJV
         mHwmC/PyjQY9Tc/16t/QemcpCwPs3G4WxTCF+abJ13ri79AdDx4pXJXdLM2d4OY245
         NjT1V8USuq1g+nIqjLQxYUcZO95RhqSIQxqVCL6Q=
Date:   Tue, 22 Aug 2023 11:18:33 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch added to mm-unstable branch
Message-Id: <20230822181833.E1071C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/ksm: add ksm stats to /proc/pid/smaps
has been added to the -mm mm-unstable branch.  Its filename is
     proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

This patch will later appear in the mm-unstable branch at
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
From: Stefan Roesch <shr@devkernel.io>
Subject: proc/ksm: add ksm stats to /proc/pid/smaps
Date: Tue, 22 Aug 2023 11:05:39 -0700

With madvise and prctl KSM can be enabled for different VMA's.  Once it is
enabled we can query how effective KSM is overall.  However we cannot
easily query if an individual VMA benefits from KSM.

This commit adds a KSM section to the /prod/<pid>/smaps file.  It reports
how many of the pages are KSM pages.  The returned value for KSM is
independent of the use of the shared zeropage.

Here is a typical output:

7f420a000000-7f421a000000 rw-p 00000000 00:00 0
Size:             262144 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:               51212 kB
Pss:                8276 kB
Shared_Clean:        172 kB
Shared_Dirty:      42996 kB
Private_Clean:       196 kB
Private_Dirty:      7848 kB
Referenced:        15388 kB
Anonymous:         51212 kB
KSM:               41376 kB
LazyFree:              0 kB
AnonHugePages:         0 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:             202016 kB
SwapPss:            3882 kB
Locked:                0 kB
THPeligible:    0
ProtectionKey:         0
ksm_state:          0
ksm_skip_base:      0
ksm_skip_count:     0
VmFlags: rd wr mr mw me nr mg anon

This information also helps with the following workflow:
- First enable KSM for all the VMA's of a process with prctl.
- Then analyze with the above smaps report which VMA's benefit the most
- Change the application (if possible) to add the corresponding madvise
calls for the VMA's that benefit the most

Link: https://lkml.kernel.org/r/20230822180539.1424843-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++++
 fs/proc/task_mmu.c                 |   16 +++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/proc.rst~proc-ksm-add-ksm-stats-to-proc-pid-smaps
+++ a/Documentation/filesystems/proc.rst
@@ -461,6 +461,7 @@ Memory Area, or VMA) there is a series o
     Private_Dirty:         0 kB
     Referenced:          892 kB
     Anonymous:             0 kB
+    KSM:                   0 kB
     LazyFree:              0 kB
     AnonHugePages:         0 kB
     ShmemPmdMapped:        0 kB
@@ -501,6 +502,9 @@ accessed.
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
 
+"KSM" shows the amount of anonymous memory that has been de-duplicated. The
+value is independent of the use of shared zeropage.
+
 "LazyFree" shows the amount of memory which is marked by madvise(MADV_FREE).
 The memory isn't freed immediately with madvise(). It's freed in memory
 pressure if the memory is clean. Please note that the printed value might
--- a/fs/proc/task_mmu.c~proc-ksm-add-ksm-stats-to-proc-pid-smaps
+++ a/fs/proc/task_mmu.c
@@ -4,6 +4,7 @@
 #include <linux/hugetlb.h>
 #include <linux/huge_mm.h>
 #include <linux/mount.h>
+#include <linux/ksm.h>
 #include <linux/seq_file.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
@@ -396,6 +397,7 @@ struct mem_size_stats {
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
+	unsigned long ksm;
 	u64 pss;
 	u64 pss_anon;
 	u64 pss_file;
@@ -435,9 +437,9 @@ static void smaps_page_accumulate(struct
 	}
 }
 
-static void smaps_account(struct mem_size_stats *mss, struct page *page,
-		bool compound, bool young, bool dirty, bool locked,
-		bool migration)
+static void smaps_account(struct mem_size_stats *mss, pte_t *pte,
+		struct page *page, bool compound, bool young, bool dirty,
+		bool locked, bool migration)
 {
 	int i, nr = compound ? compound_nr(page) : 1;
 	unsigned long size = nr * PAGE_SIZE;
@@ -452,6 +454,9 @@ static void smaps_account(struct mem_siz
 			mss->lazyfree += size;
 	}
 
+	if (PageKsm(page) && (!pte || !is_ksm_zero_pte(*pte)))
+		mss->ksm += size;
+
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (young || page_is_young(page) || PageReferenced(page))
@@ -557,7 +562,7 @@ static void smaps_pte_entry(pte_t *pte,
 	if (!page)
 		return;
 
-	smaps_account(mss, page, false, young, dirty, locked, migration);
+	smaps_account(mss, pte, page, false, young, dirty, locked, migration);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -591,7 +596,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	else
 		mss->file_thp += HPAGE_PMD_SIZE;
 
-	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
+	smaps_account(mss, NULL, page, true, pmd_young(*pmd), pmd_dirty(*pmd),
 		      locked, migration);
 }
 #else
@@ -822,6 +827,7 @@ static void __show_smap(struct seq_file
 	SEQ_PUT_DEC(" kB\nPrivate_Dirty:  ", mss->private_dirty);
 	SEQ_PUT_DEC(" kB\nReferenced:     ", mss->referenced);
 	SEQ_PUT_DEC(" kB\nAnonymous:      ", mss->anonymous);
+	SEQ_PUT_DEC(" kB\nKSM:            ", mss->ksm);
 	SEQ_PUT_DEC(" kB\nLazyFree:       ", mss->lazyfree);
 	SEQ_PUT_DEC(" kB\nAnonHugePages:  ", mss->anonymous_thp);
 	SEQ_PUT_DEC(" kB\nShmemPmdMapped: ", mss->shmem_thp);
_

Patches currently in -mm which might be from shr@devkernel.io are

proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

