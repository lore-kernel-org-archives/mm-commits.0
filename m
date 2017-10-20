From: akpm@linux-foundation.org
Subject: + support-resetting-warn_once-for-all-architectures-v2.patch
 added to -mm tree
Date: Fri, 20 Oct 2017 14:50:56 -0700
Message-ID: <59ea6fc0.LsYHEczL1FzWDaRH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57480 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753332AbdJTVu6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2017 17:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-for-all-architectures-v2
has been added to the -mm tree.  Its filename is
     support-resetting-warn_once-for-all-architectures-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/support-resetting-warn_once-for-all-architectures-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/support-resetting-warn_once-for-all-architectures-v2.patch

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
Subject: support-resetting-warn_once-for-all-architectures-v2

add a missing ifdef CONFIG_MODULES. Thanks 0day!

Link: http://lkml.kernel.org/r/20171020170633.9593-1-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN lib/bug.c~support-resetting-warn_once-for-all-architectures-v2 lib/bug.c
--- a/lib/bug.c~support-resetting-warn_once-for-all-architectures-v2
+++ a/lib/bug.c
@@ -208,11 +208,13 @@ void generic_bug_clear_once(void)
 {
 	struct module *mod;
 
+#ifdef CONFIG_MODULES
 	rcu_read_lock_sched();
 	list_for_each_entry_rcu(mod, &module_bug_list, bug_list)
 		clear_once_table(mod->bug_table,
 				 mod->bug_table + mod->num_bugs);
 	rcu_read_unlock_sched();
+#endif
 
 	clear_once_table(__start___bug_table, __stop___bug_table);
 }
_

Patches currently in -mm which might be from ak@linux.intel.com are

support-resetting-warn_once.patch
support-resetting-warn_once-for-all-architectures.patch
support-resetting-warn_once-for-all-architectures-v2.patch

