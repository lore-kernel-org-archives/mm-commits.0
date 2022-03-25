Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B8C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356766AbiCYBd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357456AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCBABF50B
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19996B8272B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1154C340EC;
        Fri, 25 Mar 2022 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171874;
        bh=0X198eZbzghwOE62wBeJNY5yCpWvdFPurSmN/BoRzOk=;
        h=Date:To:From:Subject:From;
        b=jtuf5Se03NEWEDZvtzhG6tHX/wCeelIB0rxHSMC0RHaZjJOiy05NBQcXUJ7TsPZuf
         ydpCRLoVGBpbRp7Epn8zDB0pkwkcwGdRCSCOhzb2Ji4+RoWw8wE5aSSrmMcDJI1NJr
         IAFU2pSf4uxolWOVWq+MB25q9VCLjQdVz7mq0kZg=
Date:   Thu, 24 Mar 2022 18:31:14 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, lpf.vector@gmail.com,
        libang.linuxer@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmalloc-fix-comments-about-vmap_area-struct.patch removed from -mm tree
Message-Id: <20220325013114.B1154C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix comments about vmap_area struct
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-comments-about-vmap_area-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/vmalloc: fix comments about vmap_area struct

The vmap_area_root should be in the "busy" tree and the
free_vmap_area_root should be in the "free" tree.

Link: https://lkml.kernel.org/r/20220305011510.33596-1-libang.linuxer@gmail.com
Fixes: 688fcbfc06e4 ("mm/vmalloc: modify struct vmap_area to reduce its size")
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Pengfei Li <lpf.vector@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-vmalloc-fix-comments-about-vmap_area-struct
+++ a/include/linux/vmalloc.h
@@ -80,8 +80,8 @@ struct vmap_area {
 	/*
 	 * The following two variables can be packed, because
 	 * a vmap_area object can be either:
-	 *    1) in "free" tree (root is vmap_area_root)
-	 *    2) or "busy" tree (root is free_vmap_area_root)
+	 *    1) in "free" tree (root is free_vmap_area_root)
+	 *    2) or "busy" tree (root is vmap_area_root)
 	 */
 	union {
 		unsigned long subtree_max_size; /* in "free" tree */
_

Patches currently in -mm which might be from libang.linuxer@gmail.com are


