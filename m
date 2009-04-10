From: akpm@linux-foundation.org
Subject: + dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk.patch added to -mm tree
Date: Fri, 10 Apr 2009 14:42:35 -0700
Message-ID: <200904102142.n3ALgZvg004325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbZDJVpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 17:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbaron@redhat.com, gnb@sgi.com, greg@kroah.com


The patch titled
     dynamic debug: remove pr_fmt() from dynamic_dev_dbg() printk
has been added to the -mm tree.  Its filename is
     dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk.patch

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

origin.patch
dynamic-debug-resurrect-old-pr_debug-semantics-as-pr_devel.patch
dynamic-debug-remove-pr_fmt-from-dynamic_dev_dbg-printk.patch

