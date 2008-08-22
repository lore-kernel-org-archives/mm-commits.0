From: akpm@linux-foundation.org
Subject: - rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:56:06 -0700
Message-ID: <200808222256.m7MMu6Rc020888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754325AbYHVXEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 19:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     rcu: fix synchronize_rcu() so that kernel-doc works
has been removed from the -mm tree.  Its filename was
     rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: fix synchronize_rcu() so that kernel-doc works
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix RCU's synchronize_rcu() so that it looks like a C function, enabling
it to be recognized as a function with kernel-doc annotation.

Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'synchronize_rcu'
Warning(linux-2.6.26-git11//kernel/rcupdate.c:81): No description found for parameter 'call_rcu'

[akpm@linux-foundation.org: fix comment]
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
+void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
 synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
ftrace-printk-formatting-infrastructure.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

