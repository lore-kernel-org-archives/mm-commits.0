From: akpm@linux-foundation.org
Subject: + init-mainc-use-list_for_each_entry.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:58:18 -0800
Message-ID: <56b1348a.xs3CKhjEEYJMi0iS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbcBBW6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: use list_for_each_entry()
has been added to the -mm tree.  Its filename is
     init-mainc-use-list_for_each_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-use-list_for_each_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-use-list_for_each_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: init/main.c: use list_for_each_entry()

Use list_for_each_entry() instead of list_for_each() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN init/main.c~init-mainc-use-list_for_each_entry init/main.c
--- a/init/main.c~init-mainc-use-list_for_each_entry
+++ a/init/main.c
@@ -727,7 +727,6 @@ static int __init initcall_blacklist(cha
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
 {
-	struct list_head *tmp;
 	struct blacklist_entry *entry;
 	char *fn_name;
 
@@ -735,8 +734,7 @@ static bool __init_or_module initcall_bl
 	if (!fn_name)
 		return false;
 
-	list_for_each(tmp, &blacklisted_initcalls) {
-		entry = list_entry(tmp, struct blacklist_entry, next);
+	list_for_each_entry(entry, &blacklisted_initcalls, next) {
 		if (!strcmp(fn_name, entry->buf)) {
 			pr_debug("initcall %s blacklisted\n", fn_name);
 			kfree(fn_name);
_

Patches currently in -mm which might be from geliangtang@163.com are

init-mainc-use-list_for_each_entry.patch

