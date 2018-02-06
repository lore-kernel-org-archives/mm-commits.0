From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch removed from
 -mm tree
Date: Tue, 06 Feb 2018 15:28:03 -0800
Message-ID: <5a7a3a03.WCwvHSAwEenn+mi5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50496 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753713AbeBFX2E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, psodagud@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-ubsan-remove-returns-nonnull-attribute-checks-fix
has been removed from the -mm tree.  Its filename was
     lib-ubsan-remove-returns-nonnull-attribute-checks-fix.patch

This patch was dropped because it was folded into lib-ubsan-remove-returns-nonnull-attribute-checks.patch

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
