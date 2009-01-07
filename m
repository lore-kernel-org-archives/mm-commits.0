From: akpm@linux-foundation.org
Subject: - kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:17:51 -0800
Message-ID: <200901072217.n07MHpAR017431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762294AbZAGWTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, h-shimamoto@ct.jp.nec.com, laijs@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: bugfix: try_module_get even if calling_mod is NULL
has been removed from the -mm tree.  Its filename was
     kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: bugfix: try_module_get even if calling_mod is NULL
From: Masami Hiramatsu <mhiramat@redhat.com>

When someone called register_*probe() from kernel-core code(not from
module) and that probes a kernel module, users can remove the probed
module because kprobe doesn't increment reference counter of the module. 
(on the other hand, if the kernel-module calls register_*probe, kprobe
increments refcount of the probed module.)

Currently, we have no register_*probe() calling from kernel-core(except
smoke-test, but the smoke-test doesn't probe module), so there is no real
bugs.  But the logic is wrong(or not fair) and it can causes a problem
when someone might want to probe module from kernel.

After this patch is applied, even if someone put register_*probe() call in
the kernel-core code, it increments the reference counter of the probed
module, and it prevents user to remove the module until stopping probing
it.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobes-bugfix-try_module_get-even-if-calling_mod-is-null kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-bugfix-try_module_get-even-if-calling_mod-is-null
+++ a/kernel/kprobes.c
@@ -634,7 +634,7 @@ static int __kprobes __register_kprobe(s
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
-		if (calling_mod && calling_mod != probed_mod) {
+		if (calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod))) {
 				preempt_enable();
 				return -EINVAL;
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

