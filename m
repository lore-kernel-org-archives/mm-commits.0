From: akpm@linux-foundation.org
Subject: [merged]
 dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:19 -0800
Message-ID: <52e8005f.ZjGJqh6JurjuoqJ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jbaron@akamai.com, a.ryabinin@samsung.com

Subject: [merged] dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch removed from -mm tree
To: a.ryabinin@samsung.com,jbaron@akamai.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:19 -0800


The patch titled
     Subject: dynamic_debug: replace obselete simple_strtoul() with kstrtouint()
has been removed from the -mm tree.  Its filename was
     dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: dynamic_debug: replace obselete simple_strtoul() with kstrtouint()

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-replace-obselete-simple_strtoul-with-kstrtouint
+++ a/lib/dynamic_debug.c
@@ -268,14 +268,12 @@ static int ddebug_tokenize(char *buf, ch
  */
 static inline int parse_lineno(const char *str, unsigned int *val)
 {
-	char *end = NULL;
 	BUG_ON(str == NULL);
 	if (*str == '\0') {
 		*val = 0;
 		return 0;
 	}
-	*val = simple_strtoul(str, &end, 10);
-	if (end == NULL || end == str || *end != '\0') {
+	if (kstrtouint(str, 10, val) < 0) {
 		pr_err("bad line-number: %s\n", str);
 		return -EINVAL;
 	}
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch

