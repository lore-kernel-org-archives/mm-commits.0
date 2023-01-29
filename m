Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6831BC54EED
	for <mm-commits@archiver.kernel.org>; Sun, 29 Jan 2023 21:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbjA2VVj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Jan 2023 16:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2VVi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 29 Jan 2023 16:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA83C7DB4
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 13:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82F2060DF3
        for <mm-commits@vger.kernel.org>; Sun, 29 Jan 2023 21:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC946C433EF;
        Sun, 29 Jan 2023 21:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675027297;
        bh=fses+GXKlxo+CLpj5yBQiqOys1rRaQI7bGKbWdcg2VY=;
        h=Date:To:From:Subject:From;
        b=xXf34PbuStB8/YxP6H20SmXs+JABIlxBNGHX+74KL2NpD/VA8MkM3kAhUbM65xqag
         TcY8mzOgg9czTgE74EVTdU0Vdvp6AQ664KtLYr/mrvjnK247QlGFop+9G3ZDnPuDI5
         RdV7dp+oJy2K+Gweyyz3aiI4G3dPWQBhEgwj5cr4=
Date:   Sun, 29 Jan 2023 13:21:36 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, trix@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + a.patch added to mm-nonmm-unstable branch
Message-Id: <20230129212136.DC946C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: remove redundation assignement of avail_in dfltcc_gdht()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     a.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/a.patch

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
From: Tom Rix <trix@redhat.com>
Subject: lib/zlib: remove redundation assignement of avail_in dfltcc_gdht()
Date: Sat, 28 Jan 2023 08:50:48 -0800

cppcheck reports
lib/zlib_dfltcc/dfltcc_deflate.c:65:21: warning: Redundant assignment of 'avail_in' to itself. [selfAssignment]
    size_t avail_in = avail_in = strm->avail_in;

Only setting avail_in once is needed.

Link: https://lkml.kernel.org/r/20230128165048.1245792-1-trix@redhat.com
Fixes: aa5b395b69b6 ("lib/zlib: add s390 hardware support for kernel zlib_deflate")
Signed-off-by: Tom Rix <trix@redhat.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_deflate.c~a
+++ a/lib/zlib_dfltcc/dfltcc_deflate.c
@@ -62,7 +62,7 @@ static void dfltcc_gdht(
 {
     deflate_state *state = (deflate_state *)strm->state;
     struct dfltcc_param_v0 *param = &GET_DFLTCC_STATE(state)->param;
-    size_t avail_in = avail_in = strm->avail_in;
+    size_t avail_in = strm->avail_in;
 
     dfltcc(DFLTCC_GDHT,
            param, NULL, NULL,
_

Patches currently in -mm which might be from trix@redhat.com are

a.patch

