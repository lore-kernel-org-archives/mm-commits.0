From: akpm@linux-foundation.org
Subject: [merged] module-preferred-way-to-use-module_author.patch removed from -mm tree
Date: Fri, 04 Sep 2009 11:36:33 -0700
Message-ID: <200909041836.n84IaXvV011309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbZIDShg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 14:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, jkosina@suse.cz, luciano.coelho@nokia.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module: preferred way to use MODULE_AUTHOR
has been removed from the -mm tree.  Its filename was
     module-preferred-way-to-use-module_author.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: module: preferred way to use MODULE_AUTHOR
From: Johannes Berg <johannes@sipsolutions.net>

For the longest time now we've been using multiple MODULE_AUTHOR()
statements when a module has more than one author, but the comment here
disagrees.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/module.h~module-preferred-way-to-use-module_author include/linux/module.h
--- a/include/linux/module.h~module-preferred-way-to-use-module_author
+++ a/include/linux/module.h
@@ -129,7 +129,10 @@ extern struct module __this_module;
  */
 #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
 
-/* Author, ideally of form NAME[, NAME]*[ and NAME] */
+/*
+ * Author(s), use "Name <email>" or just "Name", for multiple
+ * authors use multiple MODULE_AUTHOR() statements/lines.
+ */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
 /* What your module does. */
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
linux-next.patch

