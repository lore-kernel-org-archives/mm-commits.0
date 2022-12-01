Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1B3C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLAAKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiLAAIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:08:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2571766CB7
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C351F61E69
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA71C433B5;
        Thu,  1 Dec 2022 00:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852981;
        bh=N1Sv35o9+L47Lv++a9BRMIGxpfARsrPYN6v7aL34wHw=;
        h=Date:To:From:Subject:From;
        b=E1MXGwZsT1niAeLS49ygSBplbmrg1hoxy2VmBgU6nr4oFMYID345BbLMqMUozVBnY
         z3rVxFA6w0TqdIhUiUbGFwLnyUg2xfPRLmdmygdfjDwJrxTk+HanY25xCZTwhKtqhr
         4DLFL2QIIEGMMtYDDpkz1aGNVsBbkFm/eyJLz46Q=
Date:   Wed, 30 Nov 2022 16:03:00 -0800
To:     mm-commits@vger.kernel.org, clm@meta.com, axboe@kernel.dk,
        shr@devkernel.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-document-sys-class-bdi-bdi-min_bytes-knob.patch removed from -mm tree
Message-Id: <20221201000300.ECA71C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: document /sys/class/bdi/<bdi>/min_bytes knob
has been removed from the -mm tree.  Its filename was
     mm-document-sys-class-bdi-bdi-min_bytes-knob.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Stefan Roesch <shr@devkernel.io>
Subject: mm: document /sys/class/bdi/<bdi>/min_bytes knob
Date: Fri, 18 Nov 2022 16:52:09 -0800

This documents the new /sys/class/bdi/<bdi>/min_bytes knob.

[akpm@linux-foundation.org: fix htmldocs warnings]
Link: https://lkml.kernel.org/r/20221119005215.3052436-15-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-min_bytes-knob
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -57,6 +57,21 @@ Description:
 
 	(read-write)
 
+What:		/sys/class/bdi/<bdi>/min_bytes
+Date:		October 2022
+Contact:	Stefan Roesch <shr@devkernel.io>
+Description:
+	Under normal circumstances each device is given a part of the
+	total write-back cache that relates to its current average
+	writeout speed in relation to the other devices.
+
+	The 'min_bytes' parameter allows assigning a minimum
+	percentage of the write-back cache to a particular device
+	expressed in bytes.
+	For example, this is useful for providing a minimum QoS.
+
+	(read-write)
+
 What:		/sys/class/bdi/<bdi>/max_bytes
 Date:		October 2022
 Contact:	Stefan Roesch <shr@devkernel.io>
_

Patches currently in -mm which might be from shr@devkernel.io are


