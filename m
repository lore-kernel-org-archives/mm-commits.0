Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEA1C43461
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91723613CF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbhDPWql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234797AbhDPWqk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FAE613D1;
        Fri, 16 Apr 2021 22:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613175;
        bh=TLb5oVVx1Av3NYepD3n/B/8RNdcDVOkGEad/izZ0U3E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GcMI0lMtCtXIINm7UTE1uADsFK4utklcxxSXfrPiOtBpyIhTc1eU1JwNbSSduUJd5
         f4g8o+oCJ6cycEpDlw9RacY8na1AS6H99pmq7tJEC6IhaOUVoK57/6aXOikAECkpoR
         q0T4monidEVmCH61lxBiifW8Xu2Nng4MVPyWG2Xg=
Date:   Fri, 16 Apr 2021 15:46:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 08/12] ia64: tools: remove duplicate definition of
 ia64_mf() on ia64
Message-ID: <20210416224615._syscQRrG%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
