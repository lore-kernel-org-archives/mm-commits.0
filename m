Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34812C3DA7A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Dec 2022 21:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLVVjA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Dec 2022 16:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLVVi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 22 Dec 2022 16:38:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437CB2331A
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 13:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F0061DA3
        for <mm-commits@vger.kernel.org>; Thu, 22 Dec 2022 21:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F43C433F0;
        Thu, 22 Dec 2022 21:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671745138;
        bh=tyoY5RwNpApUJgcgfNjLMs+/4YIu6uR4+8qyX/tXlYI=;
        h=Date:To:From:Subject:From;
        b=G2ZM4TkxXoxK5S2ihJlVd7zNh/mmiGYXXBtlDMYQ0+rUqBpvWczOyXf4ZX2Md460J
         DojL+mZfIxpmoVXMFY2OZ2iu0GIC4z97fCxfomZz7E/dJH/sfP6tG+8hQ0Spdc2GOS
         KXD0WuY3P8CJVfO9fKoqt9ErLeKulrDwXMY7YHF0=
Date:   Thu, 22 Dec 2022 13:38:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@lst.de,
        hch@infradead.org, bhe@redhat.com, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-replace-bug_on-by-warn_on_once.patch added to mm-unstable branch
Message-Id: <20221222213858.30F43C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: replace BUG_ON() by WARN_ON_ONCE()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-replace-bug_on-by-warn_on_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-replace-bug_on-by-warn_on_once.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: replace BUG_ON() by WARN_ON_ONCE()
Date: Thu, 22 Dec 2022 20:00:22 +0100

Currently a vm_unmap_ram() functions triggers a BUG() if an area is not
found.  Replace it by the WARN_ON_ONCE() error message and keep machine
alive instead of stopping it.

The worst case is a memory leaking.

Link: https://lkml.kernel.org/r/20221222190022.134380-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-vmalloc-replace-bug_on-by-warn_on_once
+++ a/mm/vmalloc.c
@@ -2253,7 +2253,9 @@ void vm_unmap_ram(const void *mem, unsig
 	}
 
 	va = find_unlink_vmap_area(addr);
-	BUG_ON(!va);
+	if (WARN_ON_ONCE(!va))
+		return;
+
 	debug_check_no_locks_freed((void *)va->va_start,
 				    (va->va_end - va->va_start));
 	free_unmap_vmap_area(va);
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-avoid-calling-__find_vmap_area-twice-in-__vunmap.patch
mm-vmalloc-switch-to-find_unlink_vmap_area-in-vm_unmap_ram.patch
mm-vmalloc-replace-bug_on-by-warn_on_once.patch

