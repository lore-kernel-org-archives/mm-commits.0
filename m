Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ABCC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiLAAKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLAAI4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51D276140
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A7C461E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985EFC433B5;
        Thu,  1 Dec 2022 00:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852984;
        bh=J+fsz5YmSayHQuJT5hfzVIMpHDvouMwbpNGNyhb97Xo=;
        h=Date:To:From:Subject:From;
        b=a8+37kAHkGjzsL4x5uzxLEhmCBLL/NsHDIqNzlSaAR3ZAGhfIlbb4S6bIe8Yfz7Tq
         9Lalvdr44pNIavULOFcAjZWqrcj4sFpL7Xa0xSk9bkVRZVTLALdglhhi18dRoDJdiL
         VRoYKdXyBGweXWszchZyJV8AzzVT2n8EO8oaLFTo=
Date:   Wed, 30 Nov 2022 16:03:03 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch removed from -mm tree
Message-Id: <20221201000304.985EFC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/max_ratio_fine knob
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-max_ratio_fine-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/max_ratio_fine knob
Date: Fri, 18 Nov 2022 16:52:12 -0800

This documents the new /sys/class/bdi/<bdi>/max_ratio_fine knob.

[akpm@linux-foundation.org: fix htmldocs warnings]
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
+	of 1 million. This is useful in situations where we want to avoid
+	one device taking all or most of the write-back cache.  For example
+	in case of an NFS mount that is prone to get stuck, or a FUSE mount
+	which cannot be trusted to play fair.
+
+	(read-write)
+
 What:		/sys/class/bdi/<bdi>/min_bytes
 Date:		October 2022
 Contact:	Stefan Roesch <shr@devkernel.io>
_

Patches currently in -mm which might be from shr@devkernel.io are


