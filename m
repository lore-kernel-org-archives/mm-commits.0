Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EA7C64ED6
	for <mm-commits@archiver.kernel.org>; Tue, 28 Feb 2023 01:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjB1BA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjB1BAw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 20:00:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DC12943C
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2023 17:00:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE5960F3E
        for <mm-commits@vger.kernel.org>; Tue, 28 Feb 2023 01:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724C4C433EF;
        Tue, 28 Feb 2023 01:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677546050;
        bh=N1QGf9znd8CeMzdmg25QAb3FUnmgVF/lrCKFpcuwr+Q=;
        h=Date:To:From:Subject:From;
        b=lgvh2opgbzebIgV+7TkxbJFJXpyljInFfm+Jh/TZHzOestNYykgOED1yoB3+h4KNy
         Gbmay+o6f0qu8G6+lv3RLQGGwnZs532zsnJvhwxsBVjIgtvF9o5JcrcwX3WUOEz57X
         e0zhnIOuJszHd5tKD6Gff4VIojnKra0zuQoHGXyI=
Date:   Mon, 27 Feb 2023 17:00:49 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch removed from -mm tree
Message-Id: <20230228010050.724C4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: DFLTCC deflate does not write all available bits for Z_NO_FLUSH
has been removed from the -mm tree.  Its filename was
     lib-zlib-dfltcc-deflate-does-not-write-all-available-bits-for-z_no_flush.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


