From: akpm@linux-foundation.org
Subject: +
 mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch added to -mm tree
Date: Tue, 28 Mar 2017 16:22:59 -0700
Message-ID: <58daf053.a6mMYveFxc2Eh40N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753237AbdC1XXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2017 19:23:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pushkar.iit@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/migrate.h: add arg names to prototype
has been added to the -mm tree.  Its filename is
     mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from pushkar.iit@gmail.com are

mm-include-linux-migrateh-fixing-checkpatch-warning-regarding-function-definition.patch

