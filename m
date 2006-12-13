From: akpm@osdl.org
Subject: - workstruct-fix-ieee80211-softmac-compile-problem.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:20 -0800
Message-ID: <200612130651.kBD6pK1Q030341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964959AbWLMGvr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     workstruct: fix ieee80211-softmac compile problem
has been removed from the -mm tree.  Its filename was
     workstruct-fix-ieee80211-softmac-compile-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workstruct: fix ieee80211-softmac compile problem
From: David Howells <dhowells@redhat.com>

Fix ieee80211-softmac compile problem where it's using schedule_work() on a
delayed_work struct.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ieee80211/softmac/ieee80211softmac_assoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_assoc.c~workstruct-fix-ieee80211-softmac-compile-problem net/ieee80211/softmac/ieee80211softmac_assoc.c
--- a/net/ieee80211/softmac/ieee80211softmac_assoc.c~workstruct-fix-ieee80211-softmac-compile-problem
+++ a/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -438,7 +438,7 @@ ieee80211softmac_try_reassoc(struct ieee
 
 	spin_lock_irqsave(&mac->lock, flags);
 	mac->associnfo.associating = 1;
-	schedule_work(&mac->associnfo.work);
+	schedule_delayed_work(&mac->associnfo.work, 0);
 	spin_unlock_irqrestore(&mac->lock, flags);
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fix-more-workqueue-build-breakage-tps65010.patch
infiniband-work-around-gcc-bug-on-sparc64.patch
workstruct-add-assign_bits-to-give-an-atomic-bitops-safe-assignment.patch
workstruct-use-bitops-safe-direct-assignment.patch
alsa-workqueue-fixes.patch
nfs-represent-64-bit-fileids-as-64-bit-inode-numbers-on-32-bit-systems.patch
pm-fix-smp-races-in-the-freezer.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
ecryptfs-public-key-transport-mechanism.patch
ecryptfs-public-key-packet-management.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch

