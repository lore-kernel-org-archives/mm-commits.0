From: akpm@linux-foundation.org
Subject: + modules-warn-about-suspicious-return-values-from-modules-init-hook.patch added to -mm tree
Date: Mon, 11 Feb 2008 14:54:21 -0800
Message-ID: <200802112254.m1BMsL7x005330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbYBKWyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 17:54:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rusty@rustcorp.com.au


The patch titled
     modules: warn about suspicious return values from module's ->init() hook
has been added to the -mm tree.  Its filename is
     modules-warn-about-suspicious-return-values-from-modules-init-hook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: warn about suspicious return values from module's ->init() hook
From: Alexey Dobriyan <adobriyan@gmail.com>

Return value convention of module's init functions is 0/-E.  Sometimes,
e.g.  during forward-porting mistakes happen and buggy module created,
where result of comparison "workqueue != NULL" is propagated all the way up
to sys_init_module.  What happens is that some other module created
workqueue in question, our module created it again and module was
successfully loaded.

Or it could be some other bug.

Let's make such mistakes much more visible.  In retrospective, such
messages would noticeably shorten some of my head-scratching sessions.

Note, that dump_stack() is just a way to get attention from user.  Sample
message:

sys_init_module: 'foo'->init suspiciously returned 1, it should follow 0/-E convention
sys_init_module: loading module anyway...
Pid: 4223, comm: modprobe Not tainted 2.6.24-25f666300625d894ebe04bac2b4b3aadb907c861 #5

Call Trace:
 [<ffffffff80254b05>] sys_init_module+0xe5/0x1d0
 [<ffffffff8020b39b>] system_call_after_swapgs+0x7b/0x80

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN kernel/module.c~modules-warn-about-suspicious-return-values-from-modules-init-hook kernel/module.c
--- a/kernel/module.c~modules-warn-about-suspicious-return-values-from-modules-init-hook
+++ a/kernel/module.c
@@ -2184,6 +2184,14 @@ sys_init_module(void __user *umod,
 		wake_up(&module_wq);
 		return ret;
 	}
+	if (ret > 0) {
+		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
+				    "it should follow 0/-E convention\n"
+		       KERN_WARNING "%s: loading module anyway...\n",
+		       __func__, mod->name, ret,
+		       __func__);
+		dump_stack();
+	}
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
modules-warn-about-suspicious-return-values-from-modules-init-hook.patch
