Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF129C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjBCGn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjBCGm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A9623319
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0DD761DA8
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28E1C433EF;
        Fri,  3 Feb 2023 06:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406310;
        bh=LdXFbzxDe21Hdjox9Zevn09ydOW/4pakOk0PFVxmtUY=;
        h=Date:To:From:Subject:From;
        b=CoauuKS5XmDWbEAhRiuWQIUEU2QMjR48hL9AXyYQ/ubqvwVtAZGryyWmcHEdOPJzv
         rfrAB+uH48n9mjYmoqp7Bw0lHiZIjU3TxVkPyZRbyNwHZB36Dzev0DJYj95Hi3dEUb
         dihOram3tPq6FdMrNlWVAagDtmxFP0um+/WrQPrY=
Date:   Thu, 02 Feb 2023 22:38:28 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reject-vmap-with-vm_flush_reset_perms.patch removed from -mm tree
Message-Id: <20230203063829.F28E1C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reject vmap with VM_FLUSH_RESET_PERMS
has been removed from the -mm tree.  Its filename was
     mm-reject-vmap-with-vm_flush_reset_perms.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: reject vmap with VM_FLUSH_RESET_PERMS
Date: Sat, 21 Jan 2023 08:10:42 +0100

Patch series "cleanup vfree and vunmap".

This little series untangles the vfree and vunmap code path a bit.


This patch (of 10):

VM_FLUSH_RESET_PERMS is just for use with vmalloc as it is tied to freeing
the underlying pages.

Link: https://lkml.kernel.org/r/20230121071051.1143058-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230121071051.1143058-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmalloc.c~mm-reject-vmap-with-vm_flush_reset_perms
+++ a/mm/vmalloc.c
@@ -2868,6 +2868,9 @@ void *vmap(struct page **pages, unsigned
 
 	might_sleep();
 
+	if (WARN_ON_ONCE(flags & VM_FLUSH_RESET_PERMS))
+		return NULL;
+
 	/*
 	 * Your top guard is someone else's bottom guard. Not having a top
 	 * guard compromises someone else's mappings too.
_

Patches currently in -mm which might be from hch@lst.de are


