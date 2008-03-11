From: akpm@linux-foundation.org
Subject: - modules-warn-about-suspicious-return-values-from-modules-init-hook.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:22:27 -0700
Message-ID: <200803110322.m2B3MR5j019816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348AbYCKDWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     modules: warn about suspicious return values from module's ->init() hook
has been removed from the -mm tree.  Its filename was
     modules-warn-about-suspicious-return-values-from-modules-init-hook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2178,6 +2178,14 @@ sys_init_module(void __user *umod,
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
 
 	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
 	mod->state = MODULE_STATE_LIVE;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
tags-add-menuconfig-symbols-as-well.patch
remove-the-macro-get_personality.patch

