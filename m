Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3301C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 969E961AD0
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhJAXaC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhJAXaC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ECBE6136A;
        Fri,  1 Oct 2021 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633130897;
        bh=3dABtM3iKM/9oYxiM58ZKsbPHjMCwN3Q/vpK3R/X/Kg=;
        h=Date:From:To:Subject:From;
        b=0qbpKDe5v1JL94URxWtYmkIJ4TF4YayxBmxdVSMzOoDZU6GVxQLVQStGRAjxuM+KQ
         cKm6xwun0qy0oNVA8LYzy1M+PNqtSYCHnBZhUzRSNVb0ATwCRbWLj8f9PxOULyp4ld
         P86Dmufd3Wk2AGdfmXgPlKsf7x/ShetJIzNO3yfA=
Date:   Fri, 01 Oct 2021 16:28:17 -0700
From:   akpm@linux-foundation.org
To:     edumazet@google.com, lpf.vector@gmail.com,
        mm-commits@vger.kernel.org, urezki@gmail.com
Subject:  +
 mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch added
 to -mm tree
Message-ID: <20211001232817.H6gJXyL3K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: make sure to dump unpurged areas in /proc/vmallocinfo
has been added to the -mm tree.  Its filename is
     mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <edumazet@google.com>
Subject: mm/vmalloc: make sure to dump unpurged areas in /proc/vmallocinfo

If last va found in vmap_area_list does not have a vm pointer,
vmallocinfo.s_show() returns 0, and show_purge_info() is not called as it
should.

Link: https://lkml.kernel.org/r/20211001170815.73321-1-eric.dumazet@gmail.com
Fixes: dd3b8353bae7 ("mm/vmalloc: do not keep unpurged areas in the busy tree")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Pengfei Li <lpf.vector@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo
+++ a/mm/vmalloc.c
@@ -3929,7 +3929,7 @@ static int s_show(struct seq_file *m, vo
 			(void *)va->va_start, (void *)va->va_end,
 			va->va_end - va->va_start);
 
-		return 0;
+		goto final;
 	}
 
 	v = va->vm;
@@ -3970,6 +3970,7 @@ static int s_show(struct seq_file *m, vo
 	/*
 	 * As a final step, dump "unpurged" areas.
 	 */
+final:
 	if (list_is_last(&va->list, &vmap_area_list))
 		show_purge_info(m);
 
_

Patches currently in -mm which might be from edumazet@google.com are

mm-mempolicy-do-not-allow-illegal-mpol_f_numa_balancing-mpol_local-in-mbind.patch
mm-vmalloc-make-show_numa_info-aware-of-hugepage-mappings.patch
mm-vmalloc-make-sure-to-dump-unpurged-areas-in-proc-vmallocinfo.patch
mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash.patch
mm-do-not-acquire-zone-lock-in-is_free_buddy_page.patch

