Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725980C07
	for <mm-commits@vger.kernel.org>; Thu, 18 Jul 2024 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721345150; cv=none; b=guWZLgd0BOl0izVy6ecuymIC4SeHUZvgN6dNwdSN8zAw0hqD5Yjo1HVR8SvgVZFHp2KZ19uOJSVW8PjKW6Ow0c+Wgu1sgsX4xzqyFAQKTR/WqSHyDJ6P8yUZH4gmYsZyvdHOytqcflf3SWPsNwvLg4sXKyHV5XPzbnPYlt4YDdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721345150; c=relaxed/simple;
	bh=iptaQw4U1XJpJA7lLHbh06ZqQid8xR/btae4TPs6pqc=;
	h=Date:To:From:Subject:Message-Id; b=ojNMtVTv9hMsKGp2MK56tVVY2d9GELCmn2KBX/lxVTL/vstbVdHmOtQfTSOta8nY0wWP5BNMYgsJG0RvG1+53hZE+ztZcF859xqKMBnU8Bkvu5hOuFHMmTmUn69Kx6QEqeNiHpiM/2PGm7Z0Gx+HSI0wUvd+7lE5NiqSUES47ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h2GxfVgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h2GxfVgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BD7C116B1;
	Thu, 18 Jul 2024 23:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721345150;
	bh=iptaQw4U1XJpJA7lLHbh06ZqQid8xR/btae4TPs6pqc=;
	h=Date:To:From:Subject:From;
	b=h2GxfVgIbZh5eztiqIDrH+OB/0KWXbYa7UK0VyQ0G/Ejv7iWdTAS8/B6AQpwFQKvF
	 MMZWB1Jw+7sZiULLt5CC0leiuvfT5g5nO09BwQRdAVZrWZVZYxVMfOkBCDn/DDoj6z
	 62rZ1THpWB7oyY/pM0XK29/81AYC7RnK+gQFKRcA=
Date: Thu, 18 Jul 2024 16:25:49 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,thorsten.blum@toblux.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch removed from -mm tree
Message-Id: <20240718232550.10BD7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: Remove duplicate included header file linux/bootconfig.h
has been removed from the -mm tree.  Its filename was
     bootconfig-remove-duplicate-included-header-file-linux-bootconfigh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@toblux.com>
Subject: bootconfig: Remove duplicate included header file linux/bootconfig.h
Date: Thu, 11 Jul 2024 10:43:16 +0200

The header file linux/bootconfig.h is included whether __KERNEL__ is
defined or not.

Include it only once before the #ifdef/#else/#endif preprocessor
directives and remove the following make includecheck warning:

  linux/bootconfig.h is included more than once

Move the comment to the top and delete the now empty #else block.

Link: https://lkml.kernel.org/r/20240711084315.1507-1-thorsten.blum@toblux.com
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/lib/bootconfig.c~bootconfig-remove-duplicate-included-header-file-linux-bootconfigh
+++ a/lib/bootconfig.c
@@ -4,8 +4,16 @@
  * Masami Hiramatsu <mhiramat@kernel.org>
  */
 
-#ifdef __KERNEL__
+/*
+ * NOTE: This is only for tools/bootconfig, because tools/bootconfig will
+ * run the parser sanity test.
+ * This does NOT mean lib/bootconfig.c is available in the user space.
+ * However, if you change this file, please make sure the tools/bootconfig
+ * has no issue on building and running.
+ */
 #include <linux/bootconfig.h>
+
+#ifdef __KERNEL__
 #include <linux/bug.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
@@ -24,16 +32,6 @@ const char * __init xbc_get_embedded_boo
 	return (*size) ? embedded_bootconfig_data : NULL;
 }
 #endif
-
-#else /* !__KERNEL__ */
-/*
- * NOTE: This is only for tools/bootconfig, because tools/bootconfig will
- * run the parser sanity test.
- * This does NOT mean lib/bootconfig.c is available in the user space.
- * However, if you change this file, please make sure the tools/bootconfig
- * has no issue on building and running.
- */
-#include <linux/bootconfig.h>
 #endif
 
 /*
_

Patches currently in -mm which might be from thorsten.blum@toblux.com are


