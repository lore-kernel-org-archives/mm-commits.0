Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59765EE49AE
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjHUUoO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjHUUnY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB1ECE0
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F58C64B11
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B8EC433C7;
        Mon, 21 Aug 2023 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650521;
        bh=q43F9FHPvCv0d8b7Y2qB8lmNeyPQ+q/4yAvN36t3BMU=;
        h=Date:To:From:Subject:From;
        b=OGiuOeDH2UdnPm3VzDdLtr/j1dnHYhNZqjmiTdYtcm8LRF3/VcJDFpXZOHWH4SwtF
         jQwSFCcrw1wPU44XO6Wu/scZeYH0LVj612wKdBb0Eovj56GQrM19ZqUkx/hGwmW9F7
         VuLXXb39SAc4E2SCACxQMTk6A2wRTNl3giHkWSpg=
Date:   Mon, 21 Aug 2023 13:42:01 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, adobriyan@gmail.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmthp-no-space-after-colon-in-mem-info-fields.patch removed from -mm tree
Message-Id: <20230821204201.B3B8EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm,thp: no space after colon in Mem-Info fields
has been removed from the -mm tree.  Its filename was
     mmthp-no-space-after-colon-in-mem-info-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: no space after colon in Mem-Info fields
Date: Mon, 14 Aug 2023 13:00:18 -0700 (PDT)

Patch series "mm,thp: fix sloppy text output".

Three independent trivial patches, fixing sloppy text output which has
annoyed me; but might risk surprising a parser, so any can be dropped.


This patch (of 3):

The SysRq-m or OOM Mem-Info dmesg showed (long lines containing) ... 
shmem:NkB shmem_thp: NkB shmem_pmdmapped: NkB anon_thp: NkB ...

Delete the space after the colon after shmem_thp, shmem_pmdmapped,
anon_thp: as the shmem example shows, no other fields have a space after
the colon in this output.

Link: https://lkml.kernel.org/r/dc264fd6-40bb-6510-db36-9340a5f01d94@google.com
Link: https://lkml.kernel.org/r/c1edd7da-5493-c542-6feb-92452b4dab3b@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/show_mem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/show_mem.c~mmthp-no-space-after-colon-in-mem-info-fields
+++ a/mm/show_mem.c
@@ -251,9 +251,9 @@ static void show_free_areas(unsigned int
 			" writeback:%lukB"
 			" shmem:%lukB"
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			" shmem_thp: %lukB"
-			" shmem_pmdmapped: %lukB"
-			" anon_thp: %lukB"
+			" shmem_thp:%lukB"
+			" shmem_pmdmapped:%lukB"
+			" anon_thp:%lukB"
 #endif
 			" writeback_tmp:%lukB"
 			" kernel_stack:%lukB"
_

Patches currently in -mm which might be from hughd@google.com are

tmpfsxattr-gfp_kernel_account-for-simple-xattrs.patch

