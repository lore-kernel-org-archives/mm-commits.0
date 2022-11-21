Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6078EC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 22:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiKUWSz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiKUWSI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 17:18:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2985026AF7
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 14:18:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FBAA614BB
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 22:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA44FC433D6;
        Mon, 21 Nov 2022 22:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669069085;
        bh=YTlxeD7tkt5FH8p9GfS08lcoPKWL74VeWA7vX3FQjKA=;
        h=Date:To:From:Subject:From;
        b=VFovRU7Q8cHzEeHaVKvs7Ni+OLaT9YFaJvQLhdRe27QoUKCuWcx0mSyutsi3T/l1m
         yA/Rj+4Vrw+I9zuOfR4vRqQ5gglI/mefFXWDW4tNKU32do1At81aFjdkpN3WR6CmSq
         TiSa2SXyMClm/1z0+NrDz3wPrS/aHwAjPwrdD7Ns=
Date:   Mon, 21 Nov 2022 14:18:05 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch added to mm-unstable branch
Message-Id: <20221121221805.BA44FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/max_ratio_fine knob
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/max_ratio_fine knob
Date: Fri, 18 Nov 2022 16:52:12 -0800

This documents the new /sys/class/bdi/<bdi>/max_ratio_fine knob.

Link: https://lkml.kernel.org/r/20221119005215.3052436-18-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-max_ratio_fine-knob
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -57,6 +57,19 @@ Description:
 
 	(read-write)
 
+What:		/sys/class/bdi/<bdi>/max_ratio_fine
+Date:		November 2022
+Contact:	Stefan Roesch <shr@devkernel.io>
+Description:
+	Allows limiting a particular device to use not more than the
+	given value of the write-back cache.  The value is given as part
+    of 1 million. This is useful in situations where we want to avoid
+    one device taking all or most of the write-back cache.  For example
+    in case of an NFS mount that is prone to get stuck, or a FUSE mount
+    which cannot be trusted to play fair.
+
+	(read-write)
+
 What:		/sys/class/bdi/<bdi>/min_bytes
 Date:		October 2022
 Contact:	Stefan Roesch <shr@devkernel.io>
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-add-bdi_set_strict_limit-function.patch
mm-add-knob-sys-class-bdi-bdi-strict_limit.patch
mm-document-sys-class-bdi-bdi-strict_limit-knob.patch
mm-use-part-per-1000000-for-bdi-ratios.patch
mm-add-bdi_get_max_bytes-function.patch
mm-split-off-__bdi_set_max_ratio-function.patch
mm-add-bdi_set_max_bytes-function.patch
mm-add-knob-sys-class-bdi-bdi-max_bytes.patch
mm-document-sys-class-bdi-bdi-max_bytes-knob.patch
mm-add-bdi_get_min_bytes-function.patch
mm-split-off-__bdi_set_min_ratio-function.patch
mm-add-bdi_set_min_bytes-function.patch
mm-add-sys-class-bdi-bdi-min_bytes-knob.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob.patch
mm-add-bdi_set_max_ratio_no_scale-function.patch
mm-add-sys-class-bdi-bdi-max_ratio_fine-knob.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch
mm-add-bdi_set_min_ratio_no_scale-function.patch
mm-add-sys-class-bdi-bdi-min_ratio_fine-knob.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob.patch

