From: akpm@linux-foundation.org
Subject: + driver-core-use-ret-variable-in-unregister_dynamic_debug_module.patch added to -mm tree
Date: Thu, 06 Nov 2008 13:22:38 -0800
Message-ID: <200811062122.mA6LMcdN026759@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735AbYKFVXw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 16:23:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johfel@users.sourceforge.net, greg@kroah.com, jbaron@redhat.com


The patch titled
     driver core: use 'ret' variable in unregister_dynamic_debug_module
has been added to the -mm tree.  Its filename is
     driver-core-use-ret-variable-in-unregister_dynamic_debug_module.patch

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
Subject: driver core: use 'ret' variable in unregister_dynamic_debug_module
From: Johann Felix Soden <johfel@users.sourceforge.net>

The 'ret' variable is assigned, but not used in the return statement.  Fix
this.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dynamic_printk.c~driver-core-use-ret-variable-in-unregister_dynamic_debug_module lib/dynamic_printk.c
--- a/lib/dynamic_printk.c~driver-core-use-ret-variable-in-unregister_dynamic_debug_module
+++ a/lib/dynamic_printk.c
@@ -135,7 +135,7 @@ int unregister_dynamic_debug_module(char
 	nr_entries--;
 out:
 	up(&debug_list_mutex);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_dynamic_debug_module);
 
_

Patches currently in -mm which might be from johfel@users.sourceforge.net are

driver-core-use-ret-variable-in-unregister_dynamic_debug_module.patch

