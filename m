Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB6EC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 379D8619E4
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241399AbhKICi0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241574AbhKICiR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:38:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8EDD61502;
        Tue,  9 Nov 2021 02:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425332;
        bh=G0l1F3WsG9FsRS+VDOtRetv8+8BsbiT0vGzaWPCNyxE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bQdRQYclWX/HOHdLK0ZMHtOc03JVtR5Jua/CssrmJ8JYhL+tzPnqr2j0xwghUkAcN
         0xd/AMiddUjoQrzQpC3DrCh/sUnKPFs4wTpoQCGlEiv7gOlFy0NdTO3f9p2eYBRh28
         vdaLwC7zl7YQSufwkM4bNj44V512/y2+4l8k+O2o=
Date:   Mon, 08 Nov 2021 18:35:31 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        bigeasy@linutronix.de, dvyukov@google.com, elver@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        williams@redhat.com
Subject:  [patch 77/87] Documentation/kcov: define `ip' in the
 example
Message-ID: <20211109023531.IVZJo-TQ5%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Documentation/kcov: define `ip' in the example

The example code uses the variable `ip' but never declares it.

Declare `ip' as a 64bit variable which is the same type as the array
from which it loads its value.

Link: https://lkml.kernel.org/r/20210923164741.1859522-3-bigeasy@linutronix.de
Link: https://lore.kernel.org/r/20210830172627.267989-3-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/dev-tools/kcov.rst~documentation-kcov-define-ip-in-the-example
+++ a/Documentation/dev-tools/kcov.rst
@@ -178,6 +178,8 @@ Comparison operands collection is simila
 	/* Read number of comparisons collected. */
 	n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
 	for (i = 0; i < n; i++) {
+		uint64_t ip;
+
 		type = cover[i * KCOV_WORDS_PER_CMP + 1];
 		/* arg1 and arg2 - operands of the comparison. */
 		arg1 = cover[i * KCOV_WORDS_PER_CMP + 2];
_
