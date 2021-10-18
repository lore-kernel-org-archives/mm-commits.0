Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85986C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6714660F11
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 18:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhJRSCh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhJRSCe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 14:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA4AF60F02;
        Mon, 18 Oct 2021 18:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634580022;
        bh=mWDF0NK6DBeu4V5hJDYRlSIZXHWic/lOcI1i0KX4m3I=;
        h=Date:From:To:Subject:From;
        b=FSVyfGoHLLQSB/h+PaA0g9UWYK1UV5eQJKE5T5i+N82ps9O+UH1deWaRV51fr4mdD
         ml5wEBJVxpiphzhkjVElsKsa4CkU0hcsq17RKdKVyRniUUU9md9sta/LLr1XB4S/XN
         +Mzo9sXuK2SyyvWmPYE6VLGKZli3Wsn78ubY5XgY=
Date:   Mon, 18 Oct 2021 11:00:22 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, faiyazm@codeaurora.org, guptap@codeaurora.org,
        mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  +
 mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory.patch
 added to -mm tree
Message-ID: <20211018180022.q74Dn4Jwg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: add debug log in free_reserved_area for static memory
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: mm: page_alloc: add debug log in free_reserved_area for static memory

For INITRD and initmem memory is reserved through "memblock_reserve"
during boot up but it is free via "free_reserved_area" instead of
"memblock_free".

For example:
[    0.294848] Freeing initrd memory: 12K.
[    0.696688] Freeing unused kernel memory: 4096K.

To get the start and end address of the above freed memory and to account
proper memblock added pr_debug log in "free_reserved_area".  After adding
log:

[    0.294848] Freeing initrd memory: 12K.
[    0.294837] 0x00000083600000-0x00000083603000 free_initrd_mem+0x20/0x28
[    0.696688] Freeing unused kernel memory: 4096K.
[    0.695246] 0x00000081600000-0x00000081a00000 free_initmem+0x70/0xc8

Link: https://lkml.kernel.org/r/1634540053-23304-1-git-send-email-faiyazm@codeaurora.org
Signed-off-by: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Prakash Gupta <guptap@codeaurora.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory
+++ a/mm/page_alloc.c
@@ -8118,6 +8118,8 @@ EXPORT_SYMBOL(adjust_managed_page_count)
 
 unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
 {
+	const phys_addr_t pstart = __pa(start);
+	const phys_addr_t pend = __pa(end);
 	void *pos;
 	unsigned long pages = 0;
 
@@ -8146,8 +8148,10 @@ unsigned long free_reserved_area(void *s
 		free_reserved_page(page);
 	}
 
-	if (pages && s)
+	if (pages && s) {
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
+		pr_debug("[%pa-%pa] %pS\n", &pstart, &pend, (void *)_RET_IP_);
+	}
 
 	return pages;
 }
_

Patches currently in -mm which might be from faiyazm@codeaurora.org are

mm-page_alloc-add-debug-log-in-free_reserved_area-for-static-memory.patch

