Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5476C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLAALR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiLAAJy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:09:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5358B89314
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1182361E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD6FC43470;
        Thu,  1 Dec 2022 00:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852988;
        bh=ceMxKnxAsiLldy40hooWt3uxVPMp6nkZuLXHTlomcjA=;
        h=Date:To:From:Subject:From;
        b=0y/nnYUthCJjJWJjFlYpIcj8iXfpDMLpvvSvluT9HryoEh3d7vH8yQKO8RgWcuvga
         pHDqF9Nrm31csiDa+TdFbgWLw8IWOCGRUGicZFPPJDxAN4qSY7weuVEwHKygVGVnch
         YV6B6pOCoxncIzvoIopGV5XXLt8JlDjnSjmFq+Oc=
Date:   Wed, 30 Nov 2022 16:03:07 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch removed from -mm tree
Message-Id: <20221201000308.3FD6FC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/min_ratio_fine knob
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/min_ratio_fine knob
Date: Fri, 18 Nov 2022 16:52:15 -0800

This documents the new /sys/class/bdi/<bdi>/max_ratio_fine knob.

[akpm@linux-foundation.org: fix htmldocs warnings]
Link: https://lkml.kernel.org/r/20221119005215.3052436-21-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-min_ratio_fine-knob
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -44,6 +44,21 @@ Description:
 
 	(read-write)
 
+What:		/sys/class/bdi/<bdi>/min_ratio_fine
+Date:		November 2022
+Contact:	Stefan Roesch <shr@devkernel.io>
+Description:
+	Under normal circumstances each device is given a part of the
+	total write-back cache that relates to its current average
+	writeout speed in relation to the other devices.
+
+	The 'min_ratio_fine' parameter allows assigning a minimum reserve
+	of the write-back cache to a particular device. The value is
+	expressed as part of 1 million. For example, this is useful for
+	providing a minimum QoS.
+
+	(read-write)
+
 What:		/sys/class/bdi/<bdi>/max_ratio
 Date:		January 2008
 Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
_

Patches currently in -mm which might be from shr@devkernel.io are


