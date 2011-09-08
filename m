From: akpm@linux-foundation.org
Subject: + dynamic_debug-remove-num_enabled-accounting.patch added to -mm tree
Date: Thu, 08 Sep 2011 16:56:21 -0700
Message-ID: <201109082356.p88NuLpd016089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab1IHX43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2011 19:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com


The patch titled
     dynamic_debug: remove num_enabled accounting
has been added to the -mm tree.  Its filename is
     dynamic_debug-remove-num_enabled-accounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dynamic_debug: remove num_enabled accounting
From: Jason Baron <jbaron@redhat.com>

The num_enabled accounting isn't actually used anywhere - remove them.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN lib/dynamic_debug.c~dynamic_debug-remove-num_enabled-accounting lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-remove-num_enabled-accounting
+++ a/lib/dynamic_debug.c
@@ -42,7 +42,6 @@ struct ddebug_table {
 	struct list_head link;
 	char *mod_name;
 	unsigned int num_ddebugs;
-	unsigned int num_enabled;
 	struct _ddebug *ddebugs;
 };
 
@@ -152,11 +151,6 @@ static void ddebug_change(const struct d
 			newflags = (dp->flags & mask) | flags;
 			if (newflags == dp->flags)
 				continue;
-
-			if (!newflags)
-				dt->num_enabled--;
-			else if (!dp->flags)
-				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags)
 				dp->enabled = 1;
@@ -764,7 +758,6 @@ int ddebug_add_module(struct _ddebug *ta
 	}
 	dt->mod_name = new_name;
 	dt->num_ddebugs = n;
-	dt->num_enabled = 0;
 	dt->ddebugs = tab;
 
 	mutex_lock(&ddebug_lock);
_

Patches currently in -mm which might be from jbaron@redhat.com are

linux-next.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions-fix.patch
dynamic_debug-remove-num_enabled-accounting.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
dynamic_debug-use-a-single-printk-to-emit-messages-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
epoll-limit-paths.patch

