Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94635C11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D43B61D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhF2CmG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231876AbhF2CmD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:42:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A616E619AB;
        Tue, 29 Jun 2021 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934375;
        bh=MTOodi2rcvbHxbq9IBtE/t0wNHafOQ6+YhoUvEQvA9s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uMEx7RVsp7q1YnUhW2rny0XNaPP6yG0qNn5WxXr6eARZqhnr5XrNmZRexza6VQZOE
         k4gbyy/JbQveHtbq97qgZeIK55a+xzMy2AM+DSA6erX2VZpzGp8ghkbzcGt6TtMSA4
         y/F1d0uL7eW6cWONOz1BzZgVp7fwS+ih1aMgZA3I=
Date:   Mon, 28 Jun 2021 19:39:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 120/192] kernel/events/uprobes: use vma_lookup()
 in find_active_uprobe()
Message-ID: <20210629023935.bjKaAw6m9%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: kernel/events/uprobes: use vma_lookup() in find_active_uprobe()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-17-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/uprobes.c~kernel-events-uprobes-use-vma_lookup-in-find_active_uprobe
+++ a/kernel/events/uprobes.c
@@ -2046,8 +2046,8 @@ static struct uprobe *find_active_uprobe
 	struct vm_area_struct *vma;
 
 	mmap_read_lock(mm);
-	vma = find_vma(mm, bp_vaddr);
-	if (vma && vma->vm_start <= bp_vaddr) {
+	vma = vma_lookup(mm, bp_vaddr);
+	if (vma) {
 		if (valid_vma(vma, false)) {
 			struct inode *inode = file_inode(vma->vm_file);
 			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
_
