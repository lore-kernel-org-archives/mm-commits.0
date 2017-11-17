From: akpm@linux-foundation.org
Subject: [patch 76/94] kcov: remove pointless current != NULL check
Date: Fri, 17 Nov 2017 15:30:42 -0800
Message-ID: <20171117233042.LrHIMklJb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56046 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966959AbdKQXao (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kcov: remove pointless current != NULL check

__sanitizer_cov_trace_pc() is a hot code, so it's worth to remove
pointless '!current' check.  Current is never NULL.

Link: http://lkml.kernel.org/r/20170929162221.32500-1-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kcov.c~kcov-remove-pointless-current-=-null-check kernel/kcov.c
--- a/kernel/kcov.c~kcov-remove-pointless-current-=-null-check
+++ a/kernel/kcov.c
@@ -62,7 +62,7 @@ void notrace __sanitizer_cov_trace_pc(vo
 	 * We are interested in code coverage as a function of a syscall inputs,
 	 * so we ignore code executed in interrupts.
 	 */
-	if (!t || !in_task())
+	if (!in_task())
 		return;
 	mode = READ_ONCE(t->kcov_mode);
 	if (mode == KCOV_MODE_TRACE) {
_
