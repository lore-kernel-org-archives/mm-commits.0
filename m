Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE51C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiI0Czb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiI0CyE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174A114D2C
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45985615B9
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92733C433B5;
        Tue, 27 Sep 2022 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246992;
        bh=VA0AlHFU4jQy5HYcMol+sdHThNzsMr2q1gubW+Lk9Pg=;
        h=Date:To:From:Subject:From;
        b=hO8b3AkCzaPOxDPEY9NEPZwhZawoTMx+diuEubbCfNIi9MVbl87IjcPp7VOu8GzZt
         Izs8rqj7WcEA39vHfYcV2jDcGIO+Mb0M9IV5SR5eVur9EvPsb4CAquY4Y0fI8+hyua
         xogxZZQnURFihc8GbAfMjFj3Aoz7rcZt4njk2OOM=
Date:   Mon, 26 Sep 2022 19:49:51 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        will@kernel.org, vbabka@suse.cz, svens@linux.ibm.com,
        sj@kernel.org, dhowells@redhat.com, david@redhat.com,
        dave@stgolabs.net, catalin.marinas@arm.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-use-vma-iterators-instead-of-vma-linked-list.patch removed from -mm tree
Message-Id: <20220927024952.92733C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/oom_kill: use vma iterators instead of vma linked list
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-use-vma-iterators-instead-of-vma-linked-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/oom_kill: use vma iterators instead of vma linked list
Date: Tue, 6 Sep 2022 19:49:03 +0000

Use vma iterator in preparation of removing the linked list.

Link: https://lkml.kernel.org/r/20220906194824.2110408-62-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Tested-by: Yu Zhao <yuzhao@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_kill-use-vma-iterators-instead-of-vma-linked-list
+++ a/mm/oom_kill.c
@@ -513,6 +513,7 @@ bool __oom_reap_task_mm(struct mm_struct
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
+	VMA_ITERATOR(vmi, mm, 0);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -522,7 +523,7 @@ bool __oom_reap_task_mm(struct mm_struct
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	for (vma = mm->mmap ; vma; vma = vma->vm_next) {
+	for_each_vma(vmi, vma) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


