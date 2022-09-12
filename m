Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41102ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiILE6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiILE5C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEFA27DE4
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18AEDB802BD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB9FC433C1;
        Mon, 12 Sep 2022 04:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958617;
        bh=fl1pSTJCiaKjKDWWT2JO2Qwxj6sYoanJNxUcKQJxIpQ=;
        h=Date:To:From:Subject:From;
        b=P3bboE8hon/PNOC+uxRDN2QlZfoL5xxIXXA3jsXZkjtQ9gu/dQbkxwceKDONH7hc5
         JCjTMoyXJc3c2R6R7Y8GeVfvT+bQiOZ+sI0XhRBCNQrK8Ku7UYquXhyOWc3P54NjHT
         tqkUMUyJMiw84frvbBVvh8dWJSW3NEKOCt4rkIv4=
Date:   Sun, 11 Sep 2022 21:56:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, mwilck@suse.com, ddiss@suse.de,
        wuchi.zero@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] initramfs-mask-my_inptr-as-__initdata.patch removed from -mm tree
Message-Id: <20220912045657.BAB9FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: initramfs: mark my_inptr as __initdata
has been removed from the -mm tree.  Its filename was
     initramfs-mask-my_inptr-as-__initdata.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: initramfs: mark my_inptr as __initdata
Date: Sat, 27 Aug 2022 15:11:16 +0800

As my_inptr is only used in __init function unpack_to_rootfs(), mark it as
__initdata to allow it be freed after boot.

Link: https://lkml.kernel.org/r/20220827071116.83078-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~initramfs-mask-my_inptr-as-__initdata
+++ a/init/initramfs.c
@@ -482,7 +482,7 @@ static long __init flush_buffer(void *bu
 	return origLen;
 }
 
-static unsigned long my_inptr; /* index of next byte to be processed in inbuf */
+static unsigned long my_inptr __initdata; /* index of next byte to be processed in inbuf */
 
 #include <linux/decompress/generic.h>
 
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
relay-use-kvcalloc-to-alloc-page-array-in-relay_alloc_page_array.patch

