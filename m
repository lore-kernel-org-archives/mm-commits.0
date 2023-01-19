Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBCEC678DD
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjASBTC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjASBQ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175186B9B1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A88C661B0E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14455C433F1;
        Thu, 19 Jan 2023 01:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090916;
        bh=d1gt+nyAaX4cvFEvjCq3ut3YqTLeF9kOjt6H8Hj1LxM=;
        h=Date:To:From:Subject:From;
        b=iJWTXSXPnhLeZz8QELM9zhJBpcNA8hr/0MQJ0a6YteQYt7vP4AFxC6qVUEhV3sA1A
         E9DPc/T0CDJ1K5geMszkYoXkjEBaJapoVvjiSYiaCW/CkuPyoUVmjRpQoWEO7MWzFk
         +57DaLZb5J98yoZJw4L/GVAKaJpwmN6SHRmG2Hsg=
Date:   Wed, 18 Jan 2023 17:15:15 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        roman.gushchin@linux.dev, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, lstoakes@gmail.com, hch@lst.de,
        hch@infradead.org, bhe@redhat.com, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-replace-bug_on-by-warn_on_once.patch removed from -mm tree
Message-Id: <20230119011516.14455C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: replace BUG_ON() by WARN_ON_ONCE()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-replace-bug_on-by-warn_on_once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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


