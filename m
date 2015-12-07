From: akpm@linux-foundation.org
Subject: + ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch
 added to -mm tree
Date: Mon, 07 Dec 2015 15:28:13 -0800
Message-ID: <5666160d.oTWXkVce00ztbZO9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776AbbLGX2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2015 18:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-2
has been added to the -mm tree.  Its filename is
     ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ubsan-run-time-undefined-behavior-sanity-checker-fix-2.patch

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
Subject: ubsan-run-time-undefined-behavior-sanity-checker-fix-2

In GCC internals __ubsan_handle_builtin_unreachable() declared
with "noreturn" attribute. Make it noreturn in-kernel too.
Since we can't return from such function call panic() instead.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-2 lib/ubsan.c
--- a/lib/ubsan.c~ubsan-run-time-undefined-behavior-sanity-checker-fix-2
+++ a/lib/ubsan.c
@@ -422,16 +422,16 @@ void __ubsan_handle_shift_out_of_bounds(
 }
 EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
 
-void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
+
+void __noreturn
+__ubsan_handle_builtin_unreachable(struct unreachable_data *data)
 {
 	unsigned long flags;
 
-	if (suppress_report(&data->location))
-		return;
