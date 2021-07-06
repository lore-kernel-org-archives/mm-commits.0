Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8F0C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090E960FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhGFTP2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhGFTP2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDD56023F;
        Tue,  6 Jul 2021 19:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598768;
        bh=POKmz/8Zv7TFp5b+obhsmwwNeoN90LRmmDfRqJ+FRWg=;
        h=Date:From:To:Subject:From;
        b=poMWatybR6jxGSIXcTcrtQzZSCt5xZ03YdvYGzAoyyzLdNh3fjVOfoYAq9EJodClM
         zhLOE36HigPGyrDkUm7xJzdmEr4waZIwg39XClVInLl3MfMv+P1MIm/MjgqQ6LSWm5
         UUdayNtU6tWNzO+u7Mj2Agvm6XNo14ZBZO/Sjv/0=
Date:   Tue, 06 Jul 2021 12:12:48 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 media-videobuf2-use-vma_lookup-in-get_vaddr_frames.patch removed from -mm
 tree
Message-ID: <20210706191248.3b2dUhHdy%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: media: videobuf2: use vma_lookup() in get_vaddr_frames()
has been removed from the -mm tree.  Its filename was
     media-videobuf2-use-vma_lookup-in-get_vaddr_frames.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: media: videobuf2: use vma_lookup() in get_vaddr_frames()

vma_lookup() finds the vma of a specific address with a cleaner interface
and is more readable.

Link: https://lkml.kernel.org/r/20210521174745.2219620-15-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/common/videobuf2/frame_vector.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/common/videobuf2/frame_vector.c~media-videobuf2-use-vma_lookup-in-get_vaddr_frames
+++ a/drivers/media/common/videobuf2/frame_vector.c
@@ -64,7 +64,7 @@ int get_vaddr_frames(unsigned long start
 	do {
 		unsigned long *nums = frame_vector_pfns(vec);
 
-		vma = find_vma_intersection(mm, start, start + 1);
+		vma = vma_lookup(mm, start);
 		if (!vma)
 			break;
 
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


