From: akpm@osdl.org
Subject: + workstruct-use-bitops-safe-direct-assignment.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:03:50 -0800
Message-ID: <200612130103.kBD13oiu023358@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbWLMBD6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:03:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org


The patch titled
     workstruct: use bitops-safe direct assignment
has been added to the -mm tree.  Its filename is
     workstruct-use-bitops-safe-direct-assignment.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: workstruct: use bitops-safe direct assignment
From: David Howells <dhowells@redhat.com>

Replace the direct assignment in set_wq_data() with a bitops-proofed
wrapper (assign_bits()).  This defends against the test_and_set_bit() used
to mark a work item active.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workstruct-use-bitops-safe-direct-assignment kernel/workqueue.c
--- a/kernel/workqueue.c~workstruct-use-bitops-safe-direct-assignment
+++ a/kernel/workqueue.c
@@ -97,7 +97,7 @@ static inline void set_wq_data(struct wo
 
 	new = (unsigned long) wq | (1UL << WORK_STRUCT_PENDING);
 	new |= work->management & WORK_STRUCT_FLAG_MASK;
-	work->management = new;
+	assign_bits(new, &work->management);
 }
 
 static inline void *get_wq_data(struct work_struct *work)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch
fix-more-workqueue-build-breakage-tps65010.patch
log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument.patch
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

