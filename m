From: akpm@linux-foundation.org
Subject: + support-resetting-warn_once-for-all-architectures.patch added
 to -mm tree
Date: Thu, 19 Oct 2017 14:42:44 -0700
Message-ID: <59e91c54.ZqYAFteCcrJzZUeP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52274 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbdJSVmp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 17:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel debug: support resetting WARN_ONCE for all architectures
has been added to the -mm tree.  Its filename is
     support-resetting-warn_once-for-all-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/support-resetting-warn_once-for-all-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/support-resetting-warn_once-for-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: kernel debug: support resetting WARN_ONCE for all architectures

Some architectures store the WARN_ONCE state in the flags field of the
bug_entry.  Clear that one too when resetting once state through
/sys/kernel/debug/clear_warn_once

Pointed out by Michael Ellerman

Improves the earlier patch that add clear_warn_once.

Link: http://lkml.kernel.org/r/20171019204642.7404-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h |    5 +++++
 kernel/panic.c      |    1 +
 lib/bug.c           |   21 +++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff -puN include/linux/bug.h~support-resetting-warn_once-for-all-architectures include/linux/bug.h
--- a/include/linux/bug.h~support-resetting-warn_once-for-all-architectures
+++ a/include/linux/bug.h
@@ -42,6 +42,8 @@ enum bug_trap_type report_bug(unsigned l
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
+void generic_bug_clear_once(void);
+
 #else	/* !CONFIG_GENERIC_BUG */
 
 static inline enum bug_trap_type report_bug(unsigned long bug_addr,
@@ -50,6 +52,9 @@ static inline enum bug_trap_type report_
 	return BUG_TRAP_TYPE_BUG;
 }
 
+
+static inline void generic_bug_clear_once(void) {}
+
 #endif	/* CONFIG_GENERIC_BUG */
 
 /*
diff -puN kernel/panic.c~support-resetting-warn_once-for-all-architectures kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once-for-all-architectures
+++ a/kernel/panic.c
@@ -595,6 +595,7 @@ EXPORT_SYMBOL(warn_slowpath_null);
 
 static int clear_warn_once_set(void *data, u64 val)
 {
+	generic_bug_clear_once();
 	memset(__start_once, 0, __end_once - __start_once);
 	return 0;
 }
diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures
+++ a/lib/bug.c
@@ -195,3 +195,24 @@ enum bug_trap_type report_bug(unsigned l
 
 	return BUG_TRAP_TYPE_BUG;
 }
+
+static void clear_once_table(struct bug_entry *start, struct bug_entry *end)
+{
+	struct bug_entry *bug;
+
+	for (bug = start; bug < end; bug++)
+		bug->flags &= ~BUGFLAG_ONCE;
+}
+
+void generic_bug_clear_once(void)
+{
+	struct module *mod;
+
+	rcu_read_lock_sched();
+	list_for_each_entry_rcu(mod, &module_bug_list, bug_list)
+		clear_once_table(mod->bug_table,
+				 mod->bug_table + mod->num_bugs);
+	rcu_read_unlock_sched();
+
+	clear_once_table(__start___bug_table, __stop___bug_table);
+}
_

Patches currently in -mm which might be from ak@linux.intel.com are

support-resetting-warn_once.patch
support-resetting-warn_once-for-all-architectures.patch

