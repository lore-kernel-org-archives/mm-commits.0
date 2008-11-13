From: akpm@linux-foundation.org
Subject: - kprobes-disable-preempt-for-module_text_address-and-kernel_text_address.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:49 -0800
Message-ID: <200811132126.mADLQnq7027524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbYKMV15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, h-shimamoto@ct.jp.nec.com, laijs@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: disable preempt for module_text_address() and kernel_text_address()
has been removed from the -mm tree.  Its filename was
     kprobes-disable-preempt-for-module_text_address-and-kernel_text_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: disable preempt for module_text_address() and kernel_text_address()
From: Masami Hiramatsu <mhiramat@redhat.com>

__register_kprobe() can be preempted after checking probing address but
before module_text_address() or try_module_get(), and in this interval the
module can be unloaded.  In that case, try_module_get(probed_mod) will
access to invalid address, or kprobe will probe invalid address.

This patch uses preempt_disable() to protect it and uses
__module_text_address() and __kernel_text_address().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN kernel/kprobes.c~kprobes-disable-preempt-for-module_text_address-and-kernel_text_address kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-disable-preempt-for-module_text_address-and-kernel_text_address
+++ a/kernel/kprobes.c
@@ -613,30 +613,37 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	p->addr = addr;
 
-	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr))
+	preempt_disable();
+	if (!__kernel_text_address((unsigned long) p->addr) ||
+	    in_kprobes_functions((unsigned long) p->addr)) {
+		preempt_enable();
 		return -EINVAL;
+	}
 
 	p->mod_refcounted = 0;
 
 	/*
 	 * Check if are we probing a module.
 	 */
-	probed_mod = module_text_address((unsigned long) p->addr);
+	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
-		struct module *calling_mod = module_text_address(called_from);
+		struct module *calling_mod;
+		calling_mod = __module_text_address(called_from);
 		/*
 		 * We must allow modules to probe themself and in this case
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
 		if (calling_mod && calling_mod != probed_mod) {
-			if (unlikely(!try_module_get(probed_mod)))
+			if (unlikely(!try_module_get(probed_mod))) {
+				preempt_enable();
 				return -EINVAL;
+			}
 			p->mod_refcounted = 1;
 		} else
 			probed_mod = NULL;
 	}
+	preempt_enable();
 
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);
@@ -718,6 +725,10 @@ static void __kprobes __unregister_kprob
 	struct kprobe *old_p;
 
 	if (p->mod_refcounted) {
+		/*
+		 * Since we've already incremented refcount,
+		 * we don't need to disable preemption.
+		 */
 		mod = module_text_address((unsigned long)p->addr);
 		if (mod)
 			module_put(mod);
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch

