Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5907CC32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiI0Cyj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiI0CxB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3879AA458
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54C056153F
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA79DC433B5;
        Tue, 27 Sep 2022 02:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246984;
        bh=UI7Qhs38uVaTZ/eC3kUVH08ylFpTuRag1L9/4DfvG9Y=;
        h=Date:To:From:Subject:From;
        b=2No7jV4y0/4LJyxn28HKnUJTmat1Y2AvDkl6eAnE0AbhLVH+uyXVsXvjBPtSahxIW
         OmeleZTKsbaorIeMSyC8LetjhcUKZiYfkjhF2nYpgy2pVq+M8/xkeNXP1mHKqe6Npk
         i3hl2pDd7cjbB3t6laiZ1AMVzq81XRXF4vDNMowE=
Date:   Mon, 26 Sep 2022 19:49:44 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-stop-using-mm-highest_vm_end.patch removed from -mm tree
Message-Id: <20220927024944.AA79DC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcontrol: stop using mm->highest_vm_end
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-stop-using-mm-highest_vm_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/memcontrol: stop using mm->highest_vm_end
Date: Tue, 6 Sep 2022 19:49:01 +0000

Pass through ULONG_MAX instead.

Link: https://lkml.kernel.org/r/20220906194824.2110408-56-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-stop-using-mm-highest_vm_end
+++ a/mm/memcontrol.c
@@ -5879,7 +5879,7 @@ static unsigned long mem_cgroup_count_pr
 	unsigned long precharge;
 
 	mmap_read_lock(mm);
-	walk_page_range(mm, 0, mm->highest_vm_end, &precharge_walk_ops, NULL);
+	walk_page_range(mm, 0, ULONG_MAX, &precharge_walk_ops, NULL);
 	mmap_read_unlock(mm);
 
 	precharge = mc.precharge;
@@ -6177,9 +6177,7 @@ retry:
 	 * When we have consumed all precharges and failed in doing
 	 * additional charge, the page walk just aborts.
 	 */
-	walk_page_range(mc.mm, 0, mc.mm->highest_vm_end, &charge_walk_ops,
-			NULL);
-
+	walk_page_range(mc.mm, 0, ULONG_MAX, &charge_walk_ops, NULL);
 	mmap_read_unlock(mc.mm);
 	atomic_dec(&mc.from->moving_account);
 }
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


