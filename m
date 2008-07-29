From: akpm@linux-foundation.org
Subject: + rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:16:26 -0700
Message-ID: <200807290716.m6T7GQmt020544@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbYG2H1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, paulmck@us.ibm.com


The patch titled
     rcu: fix synchronize_rcu() so that kernel-doc works
has been added to the -mm tree.  Its filename is
     rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch

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
Subject: rcu: fix synchronize_rcu() so that kernel-doc works
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix RCU's synchronize_rcu() so that it looks like a C function, enabling
it to be recognized as a function with kernel-doc annotation.

Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'synchronize_rcu'
Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'call_rcu'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupdate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/rcupdate.c~rcu-fix-synchronize_rcu-so-that-kernel-doc-works kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-fix-synchronize_rcu-so-that-kernel-doc-works
+++ a/kernel/rcupdate.c
@@ -77,6 +77,7 @@ void wakeme_after_rcu(struct rcu_head  *
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
+void synchronize_rcu(void);
 synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kmemcheck-include-moduleh-to-prevent-warnings.patch
documentation-build-source-files-in-documentation-sub-dir.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
profile-likely-unlikely-macros.patch

