Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B18B3C64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbjBCGwf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjBCGvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F13818B04
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40BEFB8298A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72E9C433D2;
        Fri,  3 Feb 2023 06:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407085;
        bh=hcV0sTlm/dMnGD1t3mlDQ0f0Nzxk1A5YG5jfHwRlmpE=;
        h=Date:To:From:Subject:From;
        b=ncaZ7qnZ0ekCiKBq0PwDYagrLTBZdj57uTRHjrtV0SAM6twnt/h97yz0JNH1WbaOB
         kV3CPiqEWekSMl3JPm/8fxQgJGP/PKOEA5csDMl8Ps9/Mx4VGrSfflFW621laOo8E8
         kmLSxMqOn8JZoxfoV99HqBuc7A57OLNsbNnuEfXQ=
Date:   Thu, 02 Feb 2023 22:51:25 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch removed from -mm tree
Message-Id: <20230203065125.D72E9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: fix DFLTCC not flushing EOBS when creating raw streams
has been removed from the -mm tree.  Its filename was
     lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: fix DFLTCC not flushing EOBS when creating raw streams
Date: Thu, 26 Jan 2023 14:14:23 +0100

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/ca99a88

Link: https://lkml.kernel.org/r/20230126131428.1222214-4-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_deflate/deflate.c~lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams
+++ a/lib/zlib_deflate/deflate.c
@@ -451,17 +451,24 @@ int zlib_deflate(
     Assert(strm->avail_out > 0, "bug2");
 
     if (flush != Z_FINISH) return Z_OK;
-    if (s->noheader) return Z_STREAM_END;
 
-    /* Write the zlib trailer (adler32) */
-    putShortMSB(s, (uInt)(strm->adler >> 16));
-    putShortMSB(s, (uInt)(strm->adler & 0xffff));
+    if (!s->noheader) {
+	/* Write zlib trailer (adler32) */
+	putShortMSB(s, (uInt)(strm->adler >> 16));
+	putShortMSB(s, (uInt)(strm->adler & 0xffff));
+    }
     flush_pending(strm);
     /* If avail_out is zero, the application will call deflate again
      * to flush the rest.
      */
-    s->noheader = -1; /* write the trailer only once! */
-    return s->pending != 0 ? Z_OK : Z_STREAM_END;
+    if (!s->noheader) {
+	s->noheader = -1; /* write the trailer only once! */
+    }
+    if (s->pending == 0) {
+	Assert(s->bi_valid == 0, "bi_buf not flushed");
+	return Z_STREAM_END;
+    }
+    return Z_OK;
 }
 
 /* ========================================================================= */
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


