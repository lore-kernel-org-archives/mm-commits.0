Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D03C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 22:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhLUWEa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:04:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54270 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhLUWEa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 17:04:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5888617CD
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 22:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4D7C36AE8;
        Tue, 21 Dec 2021 22:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640124269;
        bh=8iuqNmdKMZEZMKI+IKzfejjumtwDxtvd+TGxzW+NQd0=;
        h=Date:From:To:Subject:From;
        b=m+8ye5xarW4j1YRqc1NFmgEHIgL7V0PHtIYNznRvRnJ9ft71PmJTjtz9CYuGYFpMr
         6a5hxzK+fB6ivhNvor6pzZW8kDEqfhBLQuTzsO43Ry7Nf1y9rHO6HxTHXrU+/VRxAF
         qwGrzFKOsozIqYDbxsGZ0XfzcQcPeXf4H42tae7g=
Date:   Tue, 21 Dec 2021 14:04:28 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yinghai.lu@sun.com,
        rientjes@google.com, greg@kroah.com, clameter@sgi.com,
        christian.koenig@amd.com, ak@suse.de,
        ckoenig.leichtzumerken@gmail.com
Subject:  + dma-revert-make-dma-pool-to-use-kmalloc_node.patch added
 to -mm tree
Message-ID: <20211221220428.fZJz3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/dmapool.c: revert "make dma pool to use kmalloc_node"
has been added to the -mm tree.  Its filename is
     dma-revert-make-dma-pool-to-use-kmalloc_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dma-revert-make-dma-pool-to-u=
se-kmalloc_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dma-revert-make-dma-pool-to-u=
se-kmalloc_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "=3D?UTF-8?q?Christian=3D20K=3DC3=3DB6nig?=3D" <ckoenig.leichtzumerke=
n@gmail.com>
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

Patches currently in -mm which might be from ckoenig.leichtzumerken@gmail.c=
om are

dma-revert-make-dma-pool-to-use-kmalloc_node.patch

