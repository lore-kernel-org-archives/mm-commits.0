Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BEFFC43460
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6C3D61406
	for <mm-commits@archiver.kernel.org>; Tue, 20 Apr 2021 22:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhDTW4X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Apr 2021 18:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhDTW4X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Apr 2021 18:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A332A613E7;
        Tue, 20 Apr 2021 22:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618959349;
        bh=OQby0N/6pjU6kPq2SCaVl4E43KzGZpGOYwo9rks7pyo=;
        h=Date:From:To:Subject:From;
        b=FnfYnAphCne8M4HW2NzFaNxfDSPt7LZK+95o5UKSq29sJwotDTK7Ikxs9Dc4WeMX8
         NIUFQrKoqjmwZPCk9B4p/cUi4SREjFRstqP1TYMWCYobofToEXminFF7uiFRjOzQMJ
         U93nK55rmlFRabNsAfAtXggo8XFkhLl2Z1lD/4cU=
Date:   Tue, 20 Apr 2021 15:55:49 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org
Subject:  [merged]
 ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch removed
 from -mm tree
Message-ID: <20210420225549.oGqvSXrCW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: tools: remove duplicate definition of ia64_mf() on ia64
has been removed from the -mm tree.  Its filename was
     ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: ia64: tools: remove duplicate definition of ia64_mf() on ia64

The ia64_mf() macro defined in tools/arch/ia64/include/asm/barrier.h is
already defined in <asm/gcc_intrin.h> on ia64 which causes libbpf failing
to build:

  CC       /usr/src/linux/tools/bpf/bpftool//libbpf/staticobjs/libbpf.o
In file included from /usr/src/linux/tools/include/asm/barrier.h:24,
                 from /usr/src/linux/tools/include/linux/ring_buffer.h:4,
                 from libbpf.c:37:
/usr/src/linux/tools/include/asm/../../arch/ia64/include/asm/barrier.h:43: error: "ia64_mf" redefined [-Werror]
   43 | #define ia64_mf()       asm volatile ("mf" ::: "memory")
      |
In file included from /usr/include/ia64-linux-gnu/asm/intrinsics.h:20,
                 from /usr/include/ia64-linux-gnu/asm/swab.h:11,
                 from /usr/include/linux/swab.h:8,
                 from /usr/include/linux/byteorder/little_endian.h:13,
                 from /usr/include/ia64-linux-gnu/asm/byteorder.h:5,
                 from /usr/src/linux/tools/include/uapi/linux/perf_event.h:20,
                 from libbpf.c:36:
/usr/include/ia64-linux-gnu/asm/gcc_intrin.h:382: note: this is the location of the previous definition
  382 | #define ia64_mf() __asm__ volatile ("mf" ::: "memory")
      |
cc1: all warnings being treated as errors

Thus, remove the definition from tools/arch/ia64/include/asm/barrier.h.

Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/arch/ia64/include/asm/barrier.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/arch/ia64/include/asm/barrier.h~ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64
+++ a/tools/arch/ia64/include/asm/barrier.h
@@ -39,9 +39,6 @@
  * sequential memory pages only.
  */
 
-/* XXX From arch/ia64/include/uapi/asm/gcc_intrin.h */
-#define ia64_mf()       asm volatile ("mf" ::: "memory")
-
 #define mb()		ia64_mf()
 #define rmb()		mb()
 #define wmb()		mb()
_

Patches currently in -mm which might be from glaubitz@physik.fu-berlin.de are


