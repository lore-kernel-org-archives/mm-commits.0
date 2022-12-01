Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA85C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLAAKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiLAAIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC465447E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419B2B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E14C433D7;
        Thu,  1 Dec 2022 00:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852975;
        bh=Re9g7D6DForQRdd0FqxiXLCML52iMq4HjBJ3NG54n3I=;
        h=Date:To:From:Subject:From;
        b=jpXOZik++3Cp2DLFBRy8PeoszfEhVSRKj3xpeXfORQ/66cscyD2jQIKCt/ZSWoGDV
         cGPOJl39aNMKHJzYDJytzYOvkaLZ5m28ZEMZuJQBupTo2xHtb8pNJLh3rfKignudmu
         B/h2c8vfPQf/hYjfsJqeENSbk0OHDwyZzS6MC2SI=
Date:   Wed, 30 Nov 2022 16:02:54 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-sys-class-bdi-bdi-max_bytes-knob.patch removed from -mm tree
Message-Id: <20221201000254.F3E14C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/max_bytes knob
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-max_bytes-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/max_bytes knob
Date: Fri, 18 Nov 2022 16:52:04 -0800

This documents the new /sys/class/bdi/<bdi>/max_bytes knob.

Link: https://lkml.kernel.org/r/20221119005215.3052436-10-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-max_bytes-knob
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -56,6 +56,20 @@ Description:
 	be trusted to play fair.
 
 	(read-write)
+
+What:		/sys/class/bdi/<bdi>/max_bytes
+Date:		October 2022
+Contact:	Stefan Roesch <shr@devkernel.io>
+Description:
+	Allows limiting a particular device to use not more than the
+	given 'max_bytes' of the write-back cache.  This is useful in
+	situations where we want to avoid one device taking all or
+	most of the write-back cache.  For example in case of an NFS
+	mount that is prone to get stuck, a FUSE mount which cannot be
+	trusted to play fair, or a nbd device.
+
+	(read-write)
+
 What:		/sys/class/bdi/<bdi>/strict_limit
 Date:		October 2022
 Contact:	Stefan Roesch <shr@devkernel.io>
_

Patches currently in -mm which might be from shr@devkernel.io are


