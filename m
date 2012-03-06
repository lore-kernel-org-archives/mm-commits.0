From: akpm@linux-foundation.org
Subject: [merged] kprobes-return-proper-error-code-from-register_kprobe.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:34:50 -0800
Message-ID: <20120306193450.6F233A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50737 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab2CFTex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: prashanth@linux.vnet.ibm.com, ananth@in.ibm.com, jbaron@redhat.com, masami.hiramatsu.pt@hitachi.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: return proper error code from register_kprobe()
has been removed from the -mm tree.  Its filename was
     kprobes-return-proper-error-code-from-register_kprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Subject: kprobes: return proper error code from register_kprobe()

register_kprobe() aborts if the address of the new request falls in a
prohibited area (such as ftrace pouch, __kprobes annotated functions,
non-kernel text addresses, jump label text).  We however don't return the
right error on this abort, resulting in a silent failure - incorrect
adding/reporting of kprobes ('perf probe do_fork+18' or 'perf probe
mcount' for instance).

In V2 we are incorporating Masami Hiramatsu's  feedback.

This patch fixes it by returning -EINVAL upon failure.

While we are here, rename the label used for exit to be more appropriate.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Prashanth K Nageshappa <prashanth@linux.vnet.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/kprobes.c~kprobes-return-proper-error-code-from-register_kprobe kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-return-proper-error-code-from-register_kprobe
+++ a/kernel/kprobes.c
@@ -1334,8 +1334,10 @@ int __kprobes register_kprobe(struct kpr
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
 	    ftrace_text_reserved(p->addr, p->addr) ||
-	    jump_label_text_reserved(p->addr, p->addr))
-		goto fail_with_jump_label;
+	    jump_label_text_reserved(p->addr, p->addr)) {
+		ret = -EINVAL;
+		goto cannot_probe;
+	}
 
 	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
 	p->flags &= KPROBE_FLAG_DISABLED;
@@ -1352,7 +1354,7 @@ int __kprobes register_kprobe(struct kpr
 		 * its code to prohibit unexpected unloading.
 		 */
 		if (unlikely(!try_module_get(probed_mod)))
-			goto fail_with_jump_label;
+			goto cannot_probe;
 
 		/*
 		 * If the module freed .init.text, we couldn't insert
@@ -1361,7 +1363,7 @@ int __kprobes register_kprobe(struct kpr
 		if (within_module_init((unsigned long)p->addr, probed_mod) &&
 		    probed_mod->state != MODULE_STATE_COMING) {
 			module_put(probed_mod);
-			goto fail_with_jump_label;
+			goto cannot_probe;
 		}
 		/* ret will be updated by following code */
 	}
@@ -1409,7 +1411,7 @@ out:
 
 	return ret;
 
-fail_with_jump_label:
+cannot_probe:
 	preempt_enable();
 	jump_label_unlock();
 	return ret;
_

Patches currently in -mm which might be from prashanth@linux.vnet.ibm.com are

origin.patch

