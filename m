Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B10C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE53F6162E
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhKKC4y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234629AbhKKC4w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 808BF610A2;
        Thu, 11 Nov 2021 02:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599243;
        bh=V/9wZ2kaI2Ysy9ENDvqR0x9pDwOpINLDqZW+mlkFoo0=;
        h=Date:From:To:Subject:From;
        b=187ZIPqVxwn0Mau8mAoMNTC/6vWhr2ZtRI0VZ8LrlycFsZSaNzJRjPtWX2daAmd2b
         4+wMnTH/cjqxBmct7ENVe2aWXQq1+8RXFAcPadaxPcQWENmPP+cg9BPVy7NW/8YPCo
         5eHRJZT+6cXf8MEYlaYphPTLqGcgKWIFK6HB4PXo=
Date:   Wed, 10 Nov 2021 18:54:03 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, mm-commits@vger.kernel.org, rostedt@goodmis.org,
        williams@redhat.com
Subject:  [merged]
 documentation-kcov-define-ip-in-the-example.patch removed from -mm tree
Message-ID: <20211111025403.H_WfBh8EP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/kcov: define `ip' in the example
has been removed from the -mm tree.  Its filename was
     documentation-kcov-define-ip-in-the-example.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from bigeasy@linutronix.de are


