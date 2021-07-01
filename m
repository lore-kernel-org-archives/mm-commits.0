Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3098BC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C56C6147D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbhGAB5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB5X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7F56141A;
        Thu,  1 Jul 2021 01:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104493;
        bh=Zay68I8W1NAS0TDg5JlNAJU7hfz/RJOB6jjX9bKT2uI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HwREGdCIKEqqsfayp5uk6HRm8706rc9zyZm1wypRcw6Hs8HswczK7L1TOLbHv9k4S
         MutIMAy+zoxE10a5X4RRrgstWAYfFEfHscHAWGrKz/NuptjQ0Gv+KXgY023d37Tr0d
         Lk3T8vGC9/8HgX41BcNjbLgU9rz+hwtmZztVIl/M=
Date:   Wed, 30 Jun 2021 18:54:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci@linux.alibaba.com, akpm@linux-foundation.org,
        andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jiapeng.chong@linux.alibaba.com, john.fastabend@gmail.com,
        kafai@fb.com, keescook@chromium.org, kpsingh@kernel.org,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        songliubraving@fb.com, torvalds@linux-foundation.org, yhs@fb.com,
        yzaikin@google.com
Subject:  [patch 144/192] sysctl: remove redundant assignment to
 first
Message-ID: <20210701015453.ABOmnCugY%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1494,7 +1494,6 @@ int proc_do_large_bitmap(struct ctl_tabl
 			 void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err = 0;
-	bool first = 1;
 	size_t left = *lenp;
 	unsigned long bitmap_len = table->maxlen;
 	unsigned long *bitmap = *(unsigned long **) table->data;
@@ -1579,12 +1578,12 @@ int proc_do_large_bitmap(struct ctl_tabl
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
