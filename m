From: akpm@linux-foundation.org
Subject: - printk-dont-read-beyond-string-arguments-terminating-zero.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:37 -0700
Message-ID: <200805010932.m419WbbZ030998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbYEAJdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: armbru@redhat.com, mm-commits@vger.kernel.org


The patch titled
     printk: don't read beyond string arguments' terminating zero
has been removed from the -mm tree.  Its filename was
     printk-dont-read-beyond-string-arguments-terminating-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: don't read beyond string arguments' terminating zero
From: Markus Armbruster <armbru@redhat.com>

Fix update_console_cmdline() not to to read beyond the terminating zero of its
name argument.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-dont-read-beyond-string-arguments-terminating-zero kernel/printk.c
--- a/kernel/printk.c~printk-dont-read-beyond-string-arguments-terminating-zero
+++ a/kernel/printk.c
@@ -921,7 +921,7 @@ int update_console_cmdline(char *name, i
 		if (strcmp(console_cmdline[i].name, name) == 0 &&
 			  console_cmdline[i].index == idx) {
 				c = &console_cmdline[i];
-				memcpy(c->name, name_new, sizeof(c->name));
+				strlcpy(c->name, name_new, sizeof(c->name));
 				c->name[sizeof(c->name) - 1] = 0;
 				c->options = options;
 				c->index = idx_new;
_

Patches currently in -mm which might be from armbru@redhat.com are

origin.patch
git-v9fs.patch

