From: akpm@linux-foundation.org
Subject: [folded-merged]
 support-resetting-warn_once-for-all-architectures-v2-fix.patch removed from -mm tree
Date: Fri, 17 Nov 2017 15:12:16 -0800
Message-ID: <5a0f6cd0.E4C6zPG3AoTHxyqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966887AbdKQXMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-for-all-architectures-v2-fix
has been removed from the -mm tree.  Its filename was
     support-resetting-warn_once-for-all-architectures-v2-fix.patch

This patch was dropped because it was folded into support-resetting-warn_once-for-all-architectures.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: support-resetting-warn_once-for-all-architectures-v2-fix

fix unused var warning

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures-v2-fix
+++ a/lib/bug.c
@@ -207,9 +207,9 @@ static void clear_once_table(struct bug_
 
 void generic_bug_clear_once(void)
 {
+#ifdef CONFIG_MODULES
 	struct module *mod;
 
-#ifdef CONFIG_MODULES
 	rcu_read_lock_sched();
 	list_for_each_entry_rcu(mod, &module_bug_list, bug_list)
 		clear_once_table(mod->bug_table,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

support-resetting-warn_once-for-all-architectures.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

