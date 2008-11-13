From: akpm@linux-foundation.org
Subject: - driver-core-use-ret-variable-in-unregister_dynamic_debug_module.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:27:57 -0800
Message-ID: <200811132127.mADLRvOS028226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYKMV2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johfel@users.sourceforge.net, greg@kroah.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     driver core: use 'ret' variable in unregister_dynamic_debug_module
has been removed from the -mm tree.  Its filename was
     driver-core-use-ret-variable-in-unregister_dynamic_debug_module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

