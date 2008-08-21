From: akpm@linux-foundation.org
Subject: - netfilter-conntrack_helper-needs-to-include-rculisth.patch removed from -mm tree
Date: Thu, 21 Aug 2008 08:59:26 -0700
Message-ID: <200808211559.m7LFxQYf012828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708AbYHUQA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 12:00:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     netfilter: conntrack_helper needs to include rculist.h
has been removed from the -mm tree.  Its filename was
     netfilter-conntrack_helper-needs-to-include-rculisth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: netfilter: conntrack_helper needs to include rculist.h
From: Randy Dunlap <randy.dunlap@oracle.com>

nf_conntrack_helper users rcu hlist functions so it needs to #include
rculist.h.

linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: implicit declaration of function 'hlist_for_each_entry_rcu'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: 'hnode' undeclared (first use in this function)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: (Each undeclared identifier is reported only once
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: for each function it appears in.)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:58: error: expected ';' before '{' token
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:50: warning: unused variable 'mask'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:74: error: 'hnode' undeclared (first use in this function)
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:74: error: expected ';' before '{' token
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:117: error: implicit declaration of function 'hlist_add_head_rcu'
linux-next-20080521/net/netfilter/nf_conntrack_helper.c:133: error: implicit declaration of function 'hlist_del_rcu'
filter/nf_conntrack_helper.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/netfilter/nf_conntrack_helper.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/netfilter/nf_conntrack_helper.c~netfilter-conntrack_helper-needs-to-include-rculisth net/netfilter/nf_conntrack_helper.c
--- a/net/netfilter/nf_conntrack_helper.c~netfilter-conntrack_helper-needs-to-include-rculisth
+++ a/net/netfilter/nf_conntrack_helper.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/rculist.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
arch-x86-kernel-io_apic_64c-fix-printk-warnings.patch
drm-sis-depends-on-fb_sis.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
ftrace-printk-formatting-infrastructure.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
w1-documentation-w1-masters-ds2490-update.patch
profile-likely-unlikely-macros.patch

