From: akpm@linux-foundation.org
Subject: - kprobes-remove-called_from-argument-fix.patch removed from -mm tree
Date: Tue, 06 Jan 2009 12:36:21 -0800
Message-ID: <200901062036.n06KaMMQ029761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbZAFUgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 15:36:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mhiramat@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kprobes-remove-called_from-argument-fix
has been removed from the -mm tree.  Its filename was
     kprobes-remove-called_from-argument-fix.patch

This patch was dropped because it was folded into kprobes-remove-called_from-argument.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes-remove-called_from-argument-fix
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

You also need the following to get this to compile, don't you?

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/kprobes.c~kprobes-remove-called_from-argument-fix kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-remove-called_from-argument-fix
+++ a/kernel/kprobes.c
@@ -669,8 +669,6 @@ int __kprobes register_kprobe(struct kpr
 	 */
 	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
-		struct module *calling_mod;
-		calling_mod = __module_text_address(called_from);
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
_

Patches currently in -mm which might be from ananth@in.ibm.com are

kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

