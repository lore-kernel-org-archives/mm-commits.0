From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-remove-num_enabled-accounting.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:47 -0700
Message-ID: <201110272308.p9RN8lwf004150@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22374 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XIz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, arnd@arndb.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: remove num_enabled accounting
has been removed from the -mm tree.  Its filename was
     dynamic_debug-remove-num_enabled-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Baron <jbaron@redhat.com>
Subject: dynamic_debug: remove num_enabled accounting

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
@@ -41,7 +41,6 @@ struct ddebug_table {
 	struct list_head link;
 	char *mod_name;
 	unsigned int num_ddebugs;
-	unsigned int num_enabled;
 	struct _ddebug *ddebugs;
 };
 
@@ -151,11 +150,6 @@ static void ddebug_change(const struct d
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
@@ -763,7 +757,6 @@ int ddebug_add_module(struct _ddebug *ta
 	}
 	dt->mod_name = new_name;
 	dt->num_ddebugs = n;
-	dt->num_enabled = 0;
 	dt->ddebugs = tab;
 
 	mutex_lock(&ddebug_lock);
_

Patches currently in -mm which might be from jbaron@redhat.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
epoll-fix-spurious-lockdep-warnings.patch
epoll-limit-paths.patch

