From: akpm@linux-foundation.org
Subject: [merged] init-mainc-use-list_for_each_entry.patch removed from
 -mm tree
Date: Wed, 16 Mar 2016 12:52:48 -0700
Message-ID: <56e9b990.BvTWHnooU+GIedhG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbcCPTwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: use list_for_each_entry()
has been removed from the -mm tree.  Its filename was
     init-mainc-use-list_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -719,7 +719,6 @@ static int __init initcall_blacklist(cha
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
 {
-	struct list_head *tmp;
 	struct blacklist_entry *entry;
 	char *fn_name;
 
@@ -727,8 +726,7 @@ static bool __init_or_module initcall_bl
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


