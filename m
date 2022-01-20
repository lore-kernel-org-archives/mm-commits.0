Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190C2C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347354AbiATV0A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57738 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377846AbiATV0A (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34B63B81E66
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E3C340E0;
        Thu, 20 Jan 2022 21:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713958;
        bh=e5WP0uK/PdlUSTVVlRrZlhsWT/qP5SIEMvbGlz/hdiM=;
        h=Date:From:To:Subject:From;
        b=B3hKOxwyvQpEZpOH3XjXpicK+tPeh03ZGQp0iv6Yu4F2jKxNeYJyW8VYtSVk42eaL
         hII2g/QAJ5+YBGlHnpKbpjLfluD4zt4JmYfMX2O4LlnL78gYoze68EAXK546ymUqZV
         kPQhPuvnvDgwYRl3qE/RT/gYhc0JYxeq1K7c3hYM=
Date:   Thu, 20 Jan 2022 13:25:57 -0800
From:   akpm@linux-foundation.org
To:     ak@suse.de, christian.koenig@amd.com, clameter@sgi.com,
        greg@kroah.com, mm-commits@vger.kernel.org, rientjes@google.com,
        yinghai.lu@sun.com
Subject:  [merged]
 dma-revert-make-dma-pool-to-use-kmalloc_node.patch removed from -mm tree
Message-ID: <20220120212557.7zOrM9sOm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: revert "make dma pool to use kmalloc_node"
has been removed from the -mm tree.  Its filename was
     dma-revert-make-dma-pool-to-use-kmalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Christian K=C3=B6nig <christian.koenig@amd.com>
Subject: mm/dmapool.c: revert "make dma pool to use kmalloc_node"

This reverts commit 2618c60b8b5836 ("dma: make dma pool to use
kmalloc_node").

While working myself into the dmapool code I've found this little odd
kmalloc_node().

What basically happens here is that we allocate the housekeeping structure
on the numa node where the device is attached to.  Since the device is
never doing DMA to or from that memory this doesn't seem to make sense at
all.

So while this doesn't seem to cause much harm it's probably cleaner to
revert the change for consistency.

Link: https://lkml.kernel.org/r/20211221110724.97664-1-christian.koenig@amd=
.com
Signed-off-by: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/dmapool.c~dma-revert-make-dma-pool-to-use-kmalloc_node
+++ a/mm/dmapool.c
@@ -152,7 +152,7 @@ struct dma_pool *dma_pool_create(const c
 	else if ((boundary < size) || (boundary & (boundary - 1)))
 		return NULL;
=20
-	retval =3D kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
+	retval =3D kmalloc(sizeof(*retval), GFP_KERNEL);
 	if (!retval)
 		return retval;
=20
_

Patches currently in -mm which might be from christian.koenig@amd.com are


