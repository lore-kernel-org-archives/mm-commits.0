Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C02AC54EAA
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 23:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjAZXSM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 18:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAZXSL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 18:18:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C5434C08
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 15:18:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CDABFCE2541
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 23:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9A4C433EF;
        Thu, 26 Jan 2023 23:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674775086;
        bh=x69s4pdAx1OXhEOvsqt4Kc15qNpgNZ+DkF4eryk4Mow=;
        h=Date:To:From:Subject:From;
        b=sBaswC72BqpGuwjjvOd+KfGQSZtb2UMrrcje1qegVtEXpvbS9SaK2PG/VhkhpzNZl
         n4oGtuRvrQnHi0zcrn+diYOhAYUSuZfgSaPu11yjo9ZG4K2TtghVpn3q4uTPRjsYqW
         BtS2p0opUO3srt5etVQRUAbBktmumn0EFykR3cX0=
Date:   Thu, 26 Jan 2023 15:18:05 -0800
To:     mm-commits@vger.kernel.org, iii@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, zaslonko@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch added to mm-nonmm-unstable branch
Message-Id: <20230126231806.0D9A4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/zlib: adjust offset calculation for dfltcc_state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch

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

 lib/zlib_dfltcc/dfltcc.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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

lib-zlib-adjust-offset-calculation-for-dfltcc_state.patch
lib-zlib-implement-switching-between-dfltcc-and-software.patch
lib-zlib-fix-dfltcc-not-flushing-eobs-when-creating-raw-streams.patch
lib-zlib-fix-dfltcc-ignoring-flush-modes-when-avail_in-==-0.patch
lib-zlib-dfltcc-not-writing-header-bits-when-avail_out-==-0.patch
lib-zlib-split-deflate-and-inflate-states-for-dfltcc.patch
lib-zlib-dfltcc-support-inflate-with-small-window.patch
lib-zlib-dfltcc-always-switch-to-software-inflate-for-z_packet_flush-option.patch

