Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A34C05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbjAZXSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjAZXSN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E8634C08
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15ACDB81DC2
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1870C433EF;
        Thu, 26 Jan 2023 23:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775089;
        bh=i+2TuLljqdzmb/c1/N0Hd4VIG8w+ohYks6vP4kT8pUI=;
        h=Date:To:From:Subject:From;
        b=mUFJPRV8AQB/kw28IbCcSOxoFfJG9XAI+za7l8F/4CbkfIuH23eG8dGaPseqw3KHv
         tQwdvjz9HxIofwOthbcsLukM/gvnxEsznxV0sOJpBanJr5cHF3B8VTZ189717OFYyI
         WI3wXYFu2BbZr7+Fw4LyyZKNWlQch5kRd0HllXts=
Date:   Thu, 26 Jan 2023 15:18:09 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231809.B1870C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: fix DFLTCC not flushing EOBS when creating raw streams
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

 lib/zlib_deflate/deflate.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

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

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

