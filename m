Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC40C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB3422259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709270;
	bh=oPm6Muhzbs/Y24wCouWBqgGJJb4U61Aaum0AZCtrLpE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zA+4jAsrcFi7byCr9YLsxlCIqYHBgqoo8xC0Ykan3JRiWwAMiRPEW/LbP3M7PwdwY
	 EbrTuD79jMP6wbaOvQj9sho+vNaWNiMzwVNDpJjIENeAzYrRUTjohLI9GZiSjDgMMb
	 AexcS5XcjIH64d+wT5EW+r5EXyUyt+IHKUnjsF1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgJNVBH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbgJNVBG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:06 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E712225E;
        Wed, 14 Oct 2020 21:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709259;
        bh=oPm6Muhzbs/Y24wCouWBqgGJJb4U61Aaum0AZCtrLpE=;
        h=Date:From:To:Subject:From;
        b=IkKcgMITv4PZKbxT9xlFSPYWjzKfWksrAMLZdrYF7iAT+UlOMzZUaEcWf/QEtSx0u
         REhc37TheG9tERAchlG6uLvfVdUs3dmQwvjQqybfC9k0a9oPBp1M7s85tbYGDAmb0t
         ftU4NSzLHbkhF6GRHwvChR7qlNXHv5HtGMbsXjDY=
Date:   Wed, 14 Oct 2020 14:00:58 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chinwen.chang@mediatek.com,
        daniel.kiss@arm.com, daniel.m.jordan@oracle.com, dbueso@suse.de,
        jgg@ziepe.ca, jimmyassarsson@gmail.com, ldufour@linux.ibm.com,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, steven.price@arm.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mmap-locking-api-add-mmap_lock_is_contended.patch removed from -mm tree
Message-ID: <20201014210058.UWH3K5mu0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmap locking API: add mmap_lock_is_contended()
has been removed from the -mm tree.  Its filename was
     mmap-locking-api-add-mmap_lock_is_contended.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chinwen Chang <chinwen.chang@mediatek.com>
Subject: mmap locking API: add mmap_lock_is_contended()

Patch series "Try to release mmap_lock temporarily in smaps_rollup", v4.

Recently, we have observed some janky issues caused by unpleasantly long
contention on mmap_lock which is held by smaps_rollup when probing large
processes.  To address the problem, we let smaps_rollup detect if anyone
wants to acquire mmap_lock for write attempts.  If yes, just release the
lock temporarily to ease the contention.

smaps_rollup is a procfs interface which allows users to summarize the
process's memory usage without the overhead of seq_* calls.  Android uses
it to sample the memory usage of various processes to balance its memory
pool sizes.  If no one wants to take the lock for write requests,
smaps_rollup with this patch will behave like the original one.

Although there are on-going mmap_lock optimizations like range-based
locks, the lock applied to smaps_rollup would be the coarse one, which is
hard to avoid the occurrence of aforementioned issues.  So the detection
and temporary release for write attempts on mmap_lock in smaps_rollup is
still necessary.


This patch (of 3):

Add new API to query if someone wants to acquire mmap_lock for write
attempts.

Using this instead of rwsem_is_contended makes it more tolerant of future
changes to the lock type.

Link: http://lkml.kernel.org/r/1597715898-3854-1-git-send-email-chinwen.chang@mediatek.com
Link: http://lkml.kernel.org/r/1597715898-3854-2-git-send-email-chinwen.chang@mediatek.com
Signed-off-by: Chinwen Chang <chinwen.chang@mediatek.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Michel Lespinasse <walken@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Daniel Kiss <daniel.kiss@arm.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/mmap_lock.h~mmap-locking-api-add-mmap_lock_is_contended
+++ a/include/linux/mmap_lock.h
@@ -87,4 +87,9 @@ static inline void mmap_assert_write_loc
 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
 }
 
+static inline int mmap_lock_is_contended(struct mm_struct *mm)
+{
+	return rwsem_is_contended(&mm->mmap_lock);
+}
+
 #endif /* _LINUX_MMAP_LOCK_H */
_

Patches currently in -mm which might be from chinwen.chang@mediatek.com are


