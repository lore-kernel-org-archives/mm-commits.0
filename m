From: akpm@linux-foundation.org
Subject: [patch 062/102] include/linux/migrate.h: add arg names to
 prototype
Date: Wed, 03 May 2017 14:54:45 -0700
Message-ID: <20170503215445.CONFo1EiX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49630 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdECVzA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, pushkar.iit@gmail.com, torvalds@linux-foundation.org

From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: include/linux/migrate.h: add arg names to prototype

It is preferred, and the rest of migrate.h gets it right.

Link: http://lkml.kernel.org/r/1490336009-8024-1-git-send-email-pushkar.iit@gmail.com
Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/migrate.h~mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition include/linux/migrate.h
--- a/include/linux/migrate.h~mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition
+++ a/include/linux/migrate.h
@@ -33,8 +33,9 @@ extern char *migrate_reason_names[MR_TYP
 #ifdef CONFIG_MIGRATION
 
 extern void putback_movable_pages(struct list_head *l);
-extern int migrate_page(struct address_space *,
-			struct page *, struct page *, enum migrate_mode);
+extern int migrate_page(struct address_space *mapping,
+			struct page *newpage, struct page *page,
+			enum migrate_mode mode);
 extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason);
 extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
_
