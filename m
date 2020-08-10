Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B4CC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DB92078D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027087;
	bh=/3kOjxf2rbOTfxO5DdGCKi4/2UKXiCKRJn3b3AIcMD8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0jOC8EpSRSERHl29U1boO419xVLOSJpDcZXArXjuvciMzAJJ7OBo0DQUUg9sKpxpB
	 ZiKH0qTUIbdrMhSksl3y1AkHpE3DOeJ/es1ACUpOtvMPmS901q37UcQFVyQmQWgZDT
	 SAsHLfl7Q4NJpYsAFEvhik+yrjk/hjVReIe7zs+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCiH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCiH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:07 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AFC820723;
        Mon, 10 Aug 2020 02:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027085;
        bh=/3kOjxf2rbOTfxO5DdGCKi4/2UKXiCKRJn3b3AIcMD8=;
        h=Date:From:To:Subject:From;
        b=xjjZYNQxGuwqypg4FGVK2nBqukkD99i8HrS/DgLugy9uSG1ZQeq4xG4LRaZJZBPL0
         hb9PVDqZXdUNVJO+cP/bTI6Z4IWi80gXllOZ24qV8fIzcfWaXlt9gvBkxIkZJ+jQHP
         MVV8HhbwapZX8pBd1PIDTrBmf5hw/85QZ0MR45Xg=
Date:   Sun, 09 Aug 2020 19:38:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        thunder.leizhen@huawei.com
Subject:  [merged]
 mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch removed from
 -mm tree
Message-ID: <20200810023805.uYcTRgN4P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/mmap: optimize a branch judgment in ksys_mmap_pgoff()

Look at the pseudo code below.  It's very clear that, the judgement
"!is_file_hugepages(file)" at 3) is duplicated to the one at 1), we can
use "else if" to avoid it.  And the assignment "retval = -EINVAL" at 2) is
only needed by the branch 3), because "retval" will be overwritten at 4).

No functional change, but it can reduce the code size. Maybe more clearer?
Before:
text    data     bss     dec     hex filename
28733    1590       1   30324    7674 mm/mmap.o

After:
text    data     bss     dec     hex filename
28701    1590       1   30292    7654 mm/mmap.o

====pseudo code====:
	if (!(flags & MAP_ANONYMOUS)) {
		...
1)		if (is_file_hugepages(file))
			len = ALIGN(len, huge_page_size(hstate_file(file)));
2)		retval = -EINVAL;
3)		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
			goto out_fput;
	} else if (flags & MAP_HUGETLB) {
		...
	}
	...

4)	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
out_fput:
	...
	return retval;

Link: http://lkml.kernel.org/r/20200705080112.1405-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-optimize-a-branch-judgment-in-ksys_mmap_pgoff
+++ a/mm/mmap.c
@@ -1562,11 +1562,12 @@ unsigned long ksys_mmap_pgoff(unsigned l
 		file = fget(fd);
 		if (!file)
 			return -EBADF;
-		if (is_file_hugepages(file))
+		if (is_file_hugepages(file)) {
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
-		retval = -EINVAL;
-		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
+		} else if (unlikely(flags & MAP_HUGETLB)) {
+			retval = -EINVAL;
 			goto out_fput;
+		}
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		struct hstate *hs;
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are


