From: akpm@linux-foundation.org
Subject: [folded-merged] argv_split-teach-it-to-handle-mutable-strings-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:02:06 -0700
Message-ID: <20130429230206.A648631C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:50753 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3D2XCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:02:07 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so200130yha.2
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:02:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: argv_split-teach-it-to-handle-mutable-strings-fix
has been removed from the -mm tree.  Its filename was
     argv_split-teach-it-to-handle-mutable-strings-fix.patch

This patch was dropped because it was folded into argv_split-teach-it-to-handle-mutable-strings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: argv_split-teach-it-to-handle-mutable-strings-fix

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/argv_split.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix lib/argv_split.c
--- a/lib/argv_split.c~argv_split-teach-it-to-handle-mutable-strings-fix
+++ a/lib/argv_split.c
@@ -51,6 +51,10 @@ EXPORT_SYMBOL(argv_free);
  * considered to be a single argument separator.  The returned array
  * is always NULL-terminated.  Returns NULL on memory allocation
  * failure.
+ *
+ * The source string at `str' may be undergoing concurrent alteration via
+ * userspace sysctl activity (at least).  The argv_split() implementation
+ * attempts to handle this gracefully by taking a local copy to work on.
  */
 char **argv_split(gfp_t gfp, const char *str, int *argcp)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


