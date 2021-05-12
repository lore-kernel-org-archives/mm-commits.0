Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A676C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3081161155
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346165AbhELVNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386273AbhELUUZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 16:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23142613FB;
        Wed, 12 May 2021 20:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620850756;
        bh=o7YeEPFizg2dw1V7fh/7IRJUeZXarx0MHF33vntTXsU=;
        h=Date:From:To:Subject:From;
        b=i+IENx2g/nLt+FBk8/Gr9Nb85TiAW7sNQ8/T+3i0uV94pFNie3fj6uh+hssIlsk4h
         kYn/rZAgfL3ZyLGQUwzuk9Co2JDJiuBDR56pCsmzXEX6BPwt1TJ2TmX183kIg46SYO
         +iwGxXLbyFGHr5HpRZXFm/HmxXdTEJhkf2WaOuGw=
Date:   Wed, 12 May 2021 13:19:15 -0700
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, andrii@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jiapeng.chong@linux.alibaba.com,
        john.fastabend@gmail.com, kafai@fb.com, keescook@chromium.org,
        kpsingh@kernel.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, yzaikin@google.com
Subject:  + sysctl-remove-redundant-assignment-to-first.patch added
 to -mm tree
Message-ID: <20210512201915.bnvaMfq8w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: remove redundant assignment to first
has been added to the -mm tree.  Its filename is
     sysctl-remove-redundant-assignment-to-first.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-remove-redundant-assignment-to-first.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-remove-redundant-assignment-to-first.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: sysctl: remove redundant assignment to first

Variable first is set to '0', but this value is never read as it is not
used later on, hence it is a redundant assignment and can be removed.

Clean up the following clang-analyzer warning:

kernel/sysctl.c:1562:4: warning: Value stored to 'first' is never read
[clang-analyzer-deadcode.DeadStores].

Link: https://lkml.kernel.org/r/1620469990-22182-1-git-send-email-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sysctl.c~sysctl-remove-redundant-assignment-to-first
+++ a/kernel/sysctl.c
@@ -1474,7 +1474,6 @@ int proc_do_large_bitmap(struct ctl_tabl
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err = 0;
-	bool first = 1;
 	size_t left = *lenp;
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
@@ -1559,12 +1558,12 @@ int proc_do_large_bitmap(struct ctl_tabl
 			}
 
 			bitmap_set(tmp_bitmap, val_a, val_b - val_a + 1);
-			first = 0;
 			proc_skip_char(&p, &left, '\n');
 		}
 		left += skipped;
 	} else {
 		unsigned long bit_a, bit_b = 0;
+		bool first = 1;
 
 		while (left) {
 			bit_a = find_next_bit(bitmap, bitmap_len, bit_b);
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are

sysctl-remove-redundant-assignment-to-first.patch

