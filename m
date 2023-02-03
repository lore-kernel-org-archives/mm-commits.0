Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6EFC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbjBCGwe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbjBCGvk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C208E05A
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED5561DC1
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B0AC433D2;
        Fri,  3 Feb 2023 06:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407084;
        bh=9AiG2KSnVZvP7I9VpunokhGM2/RZ+Ct7bOLalMB2g04=;
        h=Date:To:From:Subject:From;
        b=kuXnx8ntboGuZFISABvqaqxFtcGqQY+aGNIYA5dgBfAmlKzdK3Z8S2LA0pI7eeDOP
         +H2DYMdlf5eqHK2zEyjIjyazQWuwZIWXBNfA5r26qZT9mvYSuBNz9sRd273erJH4Rd
         2FFyrnp2zpolQAsp81ZKv5Rhq7AM24AP1lxNiavU=
Date:   Thu, 02 Feb 2023 22:51:23 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch removed from -mm tree
Message-Id: <20230203065123.E2B0AC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/zlib: adjust offset calculation for dfltcc_state
has been removed from the -mm tree.  Its filename was
     lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Subject: lib/zlib: adjust offset calculation for dfltcc_state
Date: Thu, 26 Jan 2023 14:14:21 +0100

Patch series "lib/zlib: Set of s390 DFLTCC related patches for kernel zlib".

Patches 1-7 represent a set of s390 zlib hardware support (DFLTCC) related
fixes and enhancements integrated from zlib-ng repo relevant to kernel
zlib (https://github.com/zlib-ng/zlib-ng).

Since the official zlib repository never got DFLTCC support code merged,
all the patches have been picked from zlib-ng fork (zlib data compression
library for the next generation systems).  This repo contains new
optimizations and fixes not getting implemented into the official zlib
repository and falls under the same zlib License.  All of the original
patches from zlib-ng were authored by Ilya Leoshkevich
<iii@linux.ibm.com>.  Coding style has been preserved for future
maintainability.

Patches 1-2 should have no effect for the kernel zlib but make the code
closer to zlib-ng for future maintainability.

Only Patch 3 touches common zlib_deflate code, other patches are relevant
to s390 tree only.

Patch 8 is separate and intends to resolve an issue with kernel PPP driver
which can use kernel zlib for packet compression.  Without this patch PPP
decompression can fail due to error code returned by hardware
(dfltcc_inflate) and PPP disables zlib compression for further packets.


This patch (of 8):

This commit is based on:
  https://github.com/zlib-ng/zlib-ng/commit/d8b67f5

Link: https://lkml.kernel.org/r/20230126131428.1222214-1-zaslonko@linux.ibm.com
Link: https://lkml.kernel.org/r/20230126131428.1222214-2-zaslonko@linux.ibm.com
Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com> (s390)
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/zlib_dfltcc/dfltcc.h~lib-zlib-adjust-offset-calculation-for-dfltcc_state
+++ a/lib/zlib_dfltcc/dfltcc.h
@@ -100,8 +100,9 @@ struct dfltcc_state {
     char msg[64];                      /* Buffer for strm->msg */
 };
 
+#define ALIGN_UP(p, size) (__typeof__(p))(((uintptr_t)(p) + ((size) - 1)) & ~((size) - 1))
 /* Resides right after inflate_state or deflate_state */
-#define GET_DFLTCC_STATE(state) ((struct dfltcc_state *)((state) + 1))
+#define GET_DFLTCC_STATE(state) ((struct dfltcc_state *)((char *)(state) + ALIGN_UP(sizeof(*state), 8)))
 
 /* External functions */
 int dfltcc_can_deflate(z_streamp strm);
_

Patches currently in -mm which might be from zaslonko@linux.ibm.com are


