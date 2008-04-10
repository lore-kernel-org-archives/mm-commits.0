From: akpm@linux-foundation.org
Subject: + printk-dont-read-beyond-string-arguments-terminating-zero.patch added to -mm tree
Date: Thu, 10 Apr 2008 13:59:52 -0700
Message-ID: <200804102100.m3AKxqM7017146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755589AbYDJVAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 17:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: armbru@redhat.com


The patch titled
     printk: don't read beyond string arguments' terminating zero
has been added to the -mm tree.  Its filename is
     printk-dont-read-beyond-string-arguments-terminating-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -906,7 +906,7 @@ int update_console_cmdline(char *name, i
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

git-x86.patch
git-v9fs.patch
printk-dont-read-beyond-string-arguments-terminating-zero.patch

