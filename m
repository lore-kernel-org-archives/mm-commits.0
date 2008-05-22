From: akpm@linux-foundation.org
Subject: + netfilter-conntrack_helper-needs-to-include-rculisth.patch added to -mm tree
Date: Wed, 21 May 2008 22:44:34 -0700
Message-ID: <200805220544.m4M5iYWB019576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645AbYEVFpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 01:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     netfilter: conntrack_helper needs to include rculist.h
has been added to the -mm tree.  Its filename is
     netfilter-conntrack_helper-needs-to-include-rculisth.patch

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

origin.patch
linux-next.patch
documentation-build-source-files-in-documentation-sub-dir.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
3c515-fix-using-pnp_get_resource-when-config_isapnp=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
git-unionfs.patch
uwb-fix-kconfig-causing-undefined-references.patch
whci-allow-modular-fix-busted-build.patch
audit-fix-kernel-doc-parameter-notation.patch
scsi-do-not-automatically-select-scsi_dh-for-dm-multipath.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd-fix.patch
bsdacct-stir-up-comments-around-acct_process.patch
profile-likely-unlikely-macros.patch

