Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF55C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E27061C91
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhGFTWp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhGFTWp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:22:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70C156192B;
        Tue,  6 Jul 2021 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599206;
        bh=0UzeWcBcAfJzEIX0rhGoPR8TCFnwILygNN/riTC7owY=;
        h=Date:From:To:Subject:From;
        b=OyfyJL+PTq4hoY3asEp06S3CAKSiWh1/s74fx9Me7/ofLymlXou4o6S5gSLZshwTK
         a7rqmgDc7sLJKpdlGsr8lxKcrghE15swsABjJTgVWnQotobBFlEHv9Q9mNPlOlddMl
         dc8ZDZ2BWY0/7oZXsEONUFQmnvwOI5bW5Ax6zP8s=
Date:   Tue, 06 Jul 2021 12:20:06 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        Liam.Howlett@Oracle.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged] mm-nommu-unexport-do_munmap.patch removed from
 -mm tree
Message-ID: <20210706192006.q6UxAtR8e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: unexport do_munmap()
has been removed from the -mm tree.  Its filename was
     mm-nommu-unexport-do_munmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/nommu: unexport do_munmap()

do_munmap() does not take the mmap_write_lock().  vm_munmap() should be
used instead.

Link: https://lkml.kernel.org/r/20210604194002.648037-1-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/nommu.c~mm-nommu-unexport-do_munmap
+++ a/mm/nommu.c
@@ -1501,7 +1501,6 @@ erase_whole_vma:
 	delete_vma(mm, vma);
 	return 0;
 }
-EXPORT_SYMBOL(do_munmap);
 
 int vm_munmap(unsigned long addr, size_t len)
 {
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


