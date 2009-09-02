From: akpm@linux-foundation.org
Subject: + module-preferred-way-to-use-module_author.patch added to -mm tree
Date: Wed, 02 Sep 2009 12:43:46 -0700
Message-ID: <200909021943.n82Jhkpc010431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbZIBTp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, jkosina@suse.cz, luciano.coelho@nokia.com, rusty@rustcorp.com.au


The patch titled
     module: preferred way to use MODULE_AUTHOR
has been added to the -mm tree.  Its filename is
     module-preferred-way-to-use-module_author.patch

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
module-preferred-way-to-use-module_author.patch

