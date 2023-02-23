Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D723C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 20:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjBWUym (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 15:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBWUyl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 15:54:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5367115CB7
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 12:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1423E6178A
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 20:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4FFC433EF;
        Thu, 23 Feb 2023 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677185679;
        bh=G0c3gx/Khin0zmZaDBnyt1I+gWFEkiAXVfevSPnqkHo=;
        h=Date:To:From:Subject:From;
        b=u03u3BDJ1q/oWie5qcKRW6pu83pror8imvaQ4B99Z77psnC6dMSyctw0ABwjUeNgZ
         Q3AAXyqXap7nPVe7LrL7FgW6TcKeXT5PNvWZTsR79GngJWK0eGBRQQ841rkzr7rw7m
         qu+iMQkjFY2xc5vtXKTafIb8m9aDN+BsTAQ6nfAU=
Date:   Thu, 23 Feb 2023 12:54:38 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch added to mm-nonmm-unstable branch
Message-Id: <20230223205439.3B4FFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: DFLTCC deflate does not write all available bits for Z_NO_FLUSH
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch

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
Subject: lib/zlib: DFLTCC deflate does not write all available bits for Z_NO_FLUSH
Date: Tue, 21 Feb 2023 14:16:17 +0100

DFLTCC deflate with Z_NO_FLUSH might generate a corrupted stream when the
output buffer is not large enough to fit all the deflate output at once. 
The problem takes place on closing the deflate block since flush_pending()
might leave some output bits not written.  Similar problem for software
deflate with Z_BLOCK flush option (not supported by kernel zlib deflate)
has been fixed a while ago in userspace zlib but the fix never got to the
kernel.

Now flush_pending() flushes the bit buffer before copying out the byte
buffer, in order to really flush as much as possible.

Currently there are no users of DFLTCC deflate with Z_NO_FLUSH option in
the kernel so the problem remained hidden for a while.

This commit is based on the old zlib commit:
https://github.com/madler/zlib/commit/0b828b4

Link: https://lkml.kernel.org/r/20230221131617.3369978-2-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_deflate/defutil.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/zlib_deflate/defutil.h~lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush
+++ a/lib/zlib_deflate/defutil.h
@@ -420,9 +420,11 @@ static inline void flush_pending(
 	z_streamp strm
 )
 {
+    unsigned len;
     deflate_state *s = (deflate_state *) strm->state;
-    unsigned len = s->pending;
 
+    bi_flush(s);
+    len = s->pending;
     if (len > strm->avail_out) len = strm->avail_out;
     if (len == 0) return;
 
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are

lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch

