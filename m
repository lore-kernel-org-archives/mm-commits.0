Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84960C47089
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiLAAIu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiLAAHe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:07:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AD21AD84
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 041DD6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4BDC433D7;
        Thu,  1 Dec 2022 00:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852966;
        bh=otTg02UDGxZxIPV/FM7IN23FlqBvO6jHPesfnEmW3dw=;
        h=Date:To:From:Subject:From;
        b=jFMQk9/nl2aJb6txDOlqwFcLlYCAnsj0BAx3EZ10N9pngScjnWK3YOFiwz2jDCFcn
         HMbUP8eWFqboGgugWhkON/lyEjsc6Fkspcd071KU5v3dBO2Zlt/sEg7gkuRGAg/Utt
         DWTEuT04XcN4iGUcgFMdIc5b28XWZfvR+b86mhxk=
Date:   Wed, 30 Nov 2022 16:02:45 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-sys-class-bdi-bdi-strict_limit-knob.patch removed from -mm tree
Message-Id: <20221201000246.2F4BDC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/strict_limit knob
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-strict_limit-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/strict_limit knob
Date: Fri, 18 Nov 2022 16:51:58 -0800

This documents the new /sys/class/bdi/<bdi>/strict_limit knob.

Link: https://lkml.kernel.org/r/20221119005215.3052436-4-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-strict_limit-knob
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -56,6 +56,17 @@ Description:
 	be trusted to play fair.
 
 	(read-write)
+What:		/sys/class/bdi/<bdi>/strict_limit
+Date:		October 2022
+Contact:	Stefan Roesch <shr@devkernel.io>
+Description:
+	Forces per-BDI checks for the share of given device in the write-back
+	cache even before the global background dirty limit is reached. This
+	is useful in situations where the global limit is much higher than
+	affordable for given relatively slow (or untrusted) device. Turning
+	strictlimit on has no visible effect if max_ratio is equal to 100%.
+
+	(read-write)
 What:		/sys/class/bdi/<bdi>/stable_pages_required
 Date:		January 2008
 Contact:	Peter Zijlstra <a.p.zijlstra@chello.nl>
_

Patches currently in -mm which might be from shr@devkernel.io are


