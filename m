From: akpm@linux-foundation.org
Subject: + kcov-remove-pointless-current-=-null-check.patch added to -mm
 tree
Date: Fri, 29 Sep 2017 15:32:51 -0700
Message-ID: <59ceca13.5b6aSQk4/3r6d3SC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37018 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbdI2Wcw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2017 18:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, andreyknvl@google.com, dvyukov@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kcov: remove pointless current != NULL check
has been added to the -mm tree.  Its filename is
     kcov-remove-pointless-current-=-null-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcov-remove-pointless-current-%3D-null-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcov-remove-pointless-current-%3D-null-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -61,7 +61,7 @@ void notrace __sanitizer_cov_trace_pc(vo
 	 * We are interested in code coverage as a function of a syscall inputs,
 	 * so we ignore code executed in interrupts.
 	 */
-	if (!t || !in_task())
+	if (!in_task())
 		return;
 	mode = READ_ONCE(t->kcov_mode);
 	if (mode == KCOV_MODE_TRACE) {
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

kcov-remove-pointless-current-=-null-check.patch

