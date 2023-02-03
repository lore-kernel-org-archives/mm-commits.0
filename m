Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9BBC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjBCGoD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjBCGme (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA122B0AC
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96CC6CE2EC6
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3A6C433EF;
        Fri,  3 Feb 2023 06:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406315;
        bh=5U6TylVWd09q5Jsrc7edYHHwosBGLgmpinD4fR50ASo=;
        h=Date:To:From:Subject:From;
        b=itVs0HtfPuUP+MEtkD5JUMWrapYfegNZw3shHrVDkJuHLENqlZCaLRxtXwR2YYKvB
         m5T/GQytpceuABEbTeWnsbPBd42yMRdcrhQRmJqmjfZZ6E2B8ZkRSMn4BAc8KNorpO
         /cSaPDhNFzXgfxw6srl5IXkfiomtUECCHBUBN9X8=
Date:   Thu, 02 Feb 2023 22:38:34 -0800
To:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        urezki@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
        dvyukov@google.com, david@redhat.com, andreyknvl@gmail.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch removed from -mm tree
Message-Id: <20230203063834.DD3A6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: call vfree instead of __vunmap from delayed_vfree_work
has been removed from the -mm tree.  Its filename was
     mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: call vfree instead of __vunmap from delayed_vfree_work
Date: Sat, 21 Jan 2023 08:10:46 +0100

This adds an extra, never taken, in_interrupt() branch, but will allow to
cut down the maze of vfree helpers.

Link: https://lkml.kernel.org/r/20230121071051.1143058-6-hch@lst.de
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


--- a/mm/vmalloc.c~mm-call-vfree-instead-of-__vunmap-from-delayed_vfree_work
+++ a/mm/vmalloc.c
@@ -2707,7 +2707,7 @@ static void delayed_vfree_work(struct wo
 	struct llist_node *t, *llnode;
 
 	llist_for_each_safe(llnode, t, llist_del_all(&p->list))
-		__vunmap((void *)llnode, 1);
+		vfree(llnode);
 }
 
 /**
_

Patches currently in -mm which might be from hch@lst.de are


