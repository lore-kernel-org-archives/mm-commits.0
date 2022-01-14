Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EF6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiANWG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWG5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C60C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 624CFB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13AEC36AE5;
        Fri, 14 Jan 2022 22:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198015;
        bh=/oovxXJXTKtKuvnlkNmYq68O5ONmf4m79qsZGWgSX5k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jWNdtpuhK133rjj30s3o+yy1R+uG84R7rynEpeaf0XXpCTeXdFZK2c/zyB23lBS7M
         RGjN70c670O/kZIIMvZPuwPH5Qiy0Rx+N984cik0rpbrbu/TjNpUVgHn37GPQzZ8tq
         Hcv8FHYpceicrng+USlsM3iCyojcZUbxJI5hgwyI=
Date:   Fri, 14 Jan 2022 14:06:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@suse.de, akpm@linux-foundation.org, christian.koenig@amd.com,
        clameter@sgi.com, greg@kroah.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, yinghai.lu@sun.com
Subject:  [patch 072/146] mm/dmapool.c: revert "make dma pool to
 use kmalloc_node"
Message-ID: <20220114220654.Mqg0T2wlx%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
