Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06ED7C001DB
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbjIBWRz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbjIBWRz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:17:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A01CED
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED5EA60F86
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAECC433C7;
        Sat,  2 Sep 2023 22:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693071;
        bh=GQqjP26gx7wlcriAT1nnPZgKeEZgd9wz8yE6n4nIpJQ=;
        h=Date:To:From:Subject:From;
        b=xZURjxmDLxjeYq9uS1RzTPn5YZoihKut4F3HR/SP6prH5GQxE+h2gQgbOJhsNLEPb
         LpxziNWHixKi6Ew44n7IZGQOsgf28txPMdNFvuJyOL2tTCfLcg62cjW+SpanjdRlE3
         ckMecod93ExhgIp79DrgdIlmutclCjZ8iPGSYl1Q=
Date:   Sat, 02 Sep 2023 15:17:50 -0700
To:     mm-commits@vger.kernel.org, riel@surriel.com, hannes@cmpxchg.org,
        david@redhat.com, shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch removed from -mm tree
Message-Id: <20230902221751.4FAECC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc/ksm: add ksm stats to /proc/pid/smaps
has been removed from the -mm tree.  Its filename was
     proc-ksm-add-ksm-stats-to-proc-pid-smaps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: proc/ksm: add ksm stats to /proc/pid/smaps
Date: Tue, 22 Aug 2023 11:05:39 -0700

With madvise and prctl KSM can be enabled for different VMA's.  Once it is
enabled we can query how effective KSM is overall.  However we cannot
easily query if an individual VMA benefits from KSM.

This commit adds a KSM section to the /prod/<pid>/smaps file.  It reports
how many of the pages are KSM pages.  Note that KSM-placed zeropages are
not included, only actual KSM pages.

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

[shr@devkernel.io: v5]
  Link: https://lkml.kernel.org/r/20230823170107.1457915-1-shr@devkernel.io
Link: https://lkml.kernel.org/r/20230822180539.1424843-1-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    4 ++++
 fs/proc/task_mmu.c                 |    6 ++++++
 2 files changed, 10 insertions(+)

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
 
+"KSM" reports how many of the pages are KSM pages. Note that KSM-placed zeropages
+are not included, only actual KSM pages.
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
@@ -452,6 +454,9 @@ static void smaps_account(struct mem_siz
 			mss->lazyfree += size;
 	}
 
+	if (PageKsm(page))
+		mss->ksm += size;
+
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
 	if (young || page_is_young(page) || PageReferenced(page))
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


