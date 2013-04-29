From: akpm@linux-foundation.org
Subject: [folded-merged] argv_split-teach-it-to-handle-mutable-strings-fix-2.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:02:09 -0700
Message-ID: <20130429230209.A5B2D5A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:65433 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3D2XCK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:02:10 -0400
Received: by mail-qa0-f74.google.com with SMTP id bs12so474qab.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:02:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: argv_split-teach-it-to-handle-mutable-strings-fix-2
has been removed from the -mm tree.  Its filename was
     argv_split-teach-it-to-handle-mutable-strings-fix-2.patch

This patch was dropped because it was folded into argv_split-teach-it-to-handle-mutable-strings.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: argv_split-teach-it-to-handle-mutable-strings-fix-2

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix-2 lib/argv_split.c
--- a/lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix-2
+++ a/lib/argv_split.c
@@ -63,7 +63,7 @@ char **argv_split(gfp_t gfp, const char
 	char **argv, **argv_ret;
 	int argc;
 
-	argv_str = kstrndup(str, KMALLOC_MAX_SIZE, gfp);
+	argv_str = kstrndup(str, KMALLOC_MAX_SIZE - 1, gfp);
 	if (!argv_str)
 		return NULL;
 
_

Patches currently in -mm which might be from oleg@redhat.com are


