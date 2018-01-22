From: akpm@linux-foundation.org
Subject: + lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch
 added to -mm tree
Date: Mon, 22 Jan 2018 13:06:05 -0800
Message-ID: <5a66523d.sT9JhLUkr3rJR+js%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54418 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750878AbeAVVGG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 16:06:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, psodagud@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-ubsan-remove-returns-nonnull-attribute-checks-fix
has been added to the -mm tree.  Its filename is
     lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch

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
Subject: lib-ubsan-remove-returns-nonnull-attribute-checks-fix

Link: http://lkml.kernel.org/r/20180122165711.11510-1-aryabinin@virtuozzo.com
Fixes:
 lib/ubsan.c:144:13: warning: `location_is_valid' defined but not used [-Wunused-function]
 static bool location_is_valid(struct source_location *loc)

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Sodagudi Prasad <psodagud@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks-fix lib/ubsan.c
--- a/lib/ubsan.c~lib-ubsan-remove-returns-nonnull-attribute-checks-fix
+++ a/lib/ubsan.c
@@ -141,11 +141,6 @@ static void val_to_string(char *str, siz
 	}
 }
 
-static bool location_is_valid(struct source_location *loc)
-{
-	return loc->file_name != NULL;
-}
