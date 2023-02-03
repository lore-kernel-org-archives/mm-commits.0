Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D020DC63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbjBCGwm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjBCGvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373F74E533
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B832E61DBF
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1861AC433EF;
        Fri,  3 Feb 2023 06:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407093;
        bh=yfM0C81lks98qzGL4FPxuELKEE6Ib6tqlIuqbDxDR1k=;
        h=Date:To:From:Subject:From;
        b=cSVLiE8EnSpG+pnjFm9pgC4fEZzZCsXUlQ5G3m2eI4R1SYZDIofbTLPgPIi0GMlIV
         z3R9Zmwd4U7YNRnVYyGyL3PbwISVwb/MFNBPEyYzPln0ixM9hKv2LW6fvViP0p5bNy
         7nhqi3FjIhBTH9O+Ys1PgneSJTvf12aVRsQQlnTY=
Date:   Thu, 02 Feb 2023 22:51:32 -0800
To:     mm-commits@vger.kernel.org, zaslonko@linux.ibm.com,
        iii@linux.ibm.com, trix@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-remove-redundation-assignement-of-avail_in-dfltcc_gdht.patch removed from -mm tree
Message-Id: <20230203065133.1861AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: remove redundation assignement of avail_in dfltcc_gdht()
has been removed from the -mm tree.  Its filename was
     lib-zlib-remove-redundation-assignement-of-avail_in-dfltcc_gdht.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc_deflate.c~lib-zlib-remove-redundation-assignement-of-avail_in-dfltcc_gdht
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


