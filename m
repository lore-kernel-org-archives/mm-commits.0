From: akpm@linux-foundation.org
Subject: [merged] dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk.patch removed from -mm tree
Date: Thu, 16 Apr 2009 13:09:45 -0700
Message-ID: <200904162009.n3GK9jc3022192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbZDPUM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 16:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@redhat.com, gnb@sgi.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     dynamic debug: remove pr_fmt() from dynamic_dev_dbg() printk
has been removed from the -mm tree.  Its filename was
     dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dynamic debug: remove pr_fmt() from dynamic_dev_dbg() printk
From: Jason Baron <jbaron@redhat.com>

When pr_fmt() was added to the pr_debug() code, we added it not only to
the dynamic_pr_debug() function, but also to the dynamic_dev_dbg()
funciton.  However, dev_dbg() doesn't make use of pr_fmt(), so neither
should dynamic_dev_dbg().

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>
Cc: Greg Banks <gnb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dynamic_debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/dynamic_debug.h~dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk
+++ a/include/linux/dynamic_debug.h
@@ -70,7 +70,7 @@ extern int ddebug_remove_module(char *mo
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
 			dev_printk(KERN_DEBUG, dev,			\
-					KBUILD_MODNAME ": " pr_fmt(fmt),\
+					KBUILD_MODNAME ": " fmt,	\
 					##__VA_ARGS__);			\
 	} while (0)
 
_

Patches currently in -mm which might be from jbaron@redhat.com are

linux-next.patch

