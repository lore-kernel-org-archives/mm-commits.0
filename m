Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FD7C32771
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiI0C4J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiI0Cyv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564F01EC5E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5214B81988
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2B2C433D7;
        Tue, 27 Sep 2022 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664247000;
        bh=gYIaLoP7JLI1/Ohpwg/2iB0FvPTgZAazXSQQCU0nJHA=;
        h=Date:To:From:Subject:From;
        b=hlb4WJKIOurPi9BsQz9pIMjfkF6jWPTpHgzkM665zRKI4jeVvjOwBG30KrXUmltJZ
         7E56ntgSMFf1Cs/8KllQ1vhiMFV1aAkCHsWR6c1C8Bemc6iPWFZ0owGKiIuqbhxUFY
         WgLfTnXSweA3jPtvOZtxXE+i840Ntzkh4LXKkrSQ=
Date:   Mon, 26 Sep 2022 19:49:59 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-vma-iterator-instead-of-vm_next.patch removed from -mm tree
Message-Id: <20220927025000.5A2B2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmscan: use vma iterator instead of vm_next
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-vma-iterator-instead-of-vm_next.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liam R. Howlett <Liam.Howlett@oracle.com>
Subject: mm/vmscan: use vma iterator instead of vm_next
Date: Tue, 6 Sep 2022 19:49:05 +0000

Use the vma iterator in in get_next_vma() instead of the linked list.

[yuzhao@google.com: mm/vmscan: use the proper VMA iterator]
  Link: https://lkml.kernel.org/r/Yx+QGOgHg1Wk8tGK@google.com
Link: https://lkml.kernel.org/r/20220906194824.2110408-68-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
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

 mm/vmscan.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-vma-iterator-instead-of-vm_next
+++ a/mm/vmscan.c
@@ -3774,23 +3774,17 @@ static bool get_next_vma(unsigned long m
 {
 	unsigned long start = round_up(*vm_end, size);
 	unsigned long end = (start | ~mask) + 1;
+	VMA_ITERATOR(vmi, args->mm, start);
 
 	VM_WARN_ON_ONCE(mask & size);
 	VM_WARN_ON_ONCE((start & mask) != (*vm_start & mask));
 
-	while (args->vma) {
-		if (start >= args->vma->vm_end) {
-			args->vma = args->vma->vm_next;
-			continue;
-		}
-
+	for_each_vma(vmi, args->vma) {
 		if (end && end <= args->vma->vm_start)
 			return false;
 
-		if (should_skip_vma(args->vma->vm_start, args->vma->vm_end, args)) {
-			args->vma = args->vma->vm_next;
+		if (should_skip_vma(args->vma->vm_start, args->vma->vm_end, args))
 			continue;
-		}
 
 		*vm_start = max(start, args->vma->vm_start);
 		*vm_end = min(end - 1, args->vma->vm_end - 1) + 1;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


