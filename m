From: akpm@osdl.org
Subject: + log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument.patch added to -mm tree
Date: Mon, 11 Dec 2006 11:49:52 -0800
Message-ID: <200612111949.kBBJnq5g005038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58630 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763035AbWLKTuC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 14:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, paulus@samba.org


The patch titled
     LOG2: Make powerpc's __ilog2_u64() take a 64-bit argument
has been added to the -mm tree.  Its filename is
     log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: LOG2: Make powerpc's __ilog2_u64() take a 64-bit argument
From: David Howells <dhowells@redhat.com>

Make powerpc's __ilog2_u64() take a 64-bit argument.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-powerpc/bitops.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-powerpc/bitops.h~log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument include/asm-powerpc/bitops.h
--- a/include/asm-powerpc/bitops.h~log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument
+++ a/include/asm-powerpc/bitops.h
@@ -209,7 +209,7 @@ int __ilog2_u32(u32 n)
 
 #ifdef __powerpc64__
 static inline __attribute__((const))
-int __ilog2_u64(u32 n)
+int __ilog2_u64(u64 n)
 {
 	int bit;
 	asm ("cntlzd %0,%1" : "=r" (bit) : "r" (n));
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch
fix-more-workqueue-build-breakage-tps65010.patch
log2-make-powerpcs-__ilog2_u64-take-a-64-bit-argument.patch
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

