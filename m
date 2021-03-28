Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906AAC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A9DD6194B
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 21:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhC1Va0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 17:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhC1V3u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 17:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B205A61945;
        Sun, 28 Mar 2021 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616966989;
        bh=8q5hHa+63ynVwd5dG8A88+jpgKyrKhuFuL0ds/0bzBw=;
        h=Date:From:To:Subject:From;
        b=jIjMsnvAqn8gTCS5juRxqa7nnpuhLITIdPnXsLh0UPbWOWF9c581lmzdPY5jd/qbV
         1/ae7fxAa7cN8ItyJHl3RGJSQlhFWKMC3XQNiZQTPARuHTeSOuyYhdBqzC0jWwxuut
         doZsP+uJf+oxIoMahN/8x804yQV55DQVdGxntXBQ=
Date:   Sun, 28 Mar 2021 14:29:49 -0700
From:   akpm@linux-foundation.org
To:     glaubitz@physik.fu-berlin.de, mm-commits@vger.kernel.org
Subject:  +
 ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch added to
 -mm tree
Message-ID: <20210328212949.ihh5GClrH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: tools: remove duplicate definition of ia64_mf() on ia64
has been added to the -mm tree.  Its filename is
     ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-tools-remove-duplicate-definition-of-ia64_mf-on-ia64.patch

