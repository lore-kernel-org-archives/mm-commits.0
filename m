From: akpm@linux-foundation.org
Subject: [merged]
 fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch removed from -mm tree
Date: Tue, 31 May 2016 10:50:52 -0700
Message-ID: <574dcefc.ihNp5Szg21Eimnx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbcEaRux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, neilb@suse.com, trondmy@primarydata.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/nfs4state.c: work around gcc-4.4 anon union initialization bug
has been removed from the -mm tree.  Its filename was
     fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/nfs/nfs4state.c: work around gcc-4.4 anon union initialization bug

fs/nfs/nfs4state.c:69: error: unknown field 'data' specified in initializer
fs/nfs/nfs4state.c:69: warning: missing braces around initializer
fs/nfs/nfs4state.c:69: warning: (near initialization for 'zero_stateid.<anonymous>.data')

Old gcc is stupid but the fix is easy enough.

Cc: Trond Myklebust <trondmy@primarydata.com>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug
+++ a/fs/nfs/nfs4state.c
@@ -66,7 +66,9 @@
 #define OPENOWNER_POOL_SIZE	8
 
 const nfs4_stateid zero_stateid = {
-	.data = { 0 },
+	{
+		.data = { 0 },
+	},
 	.type = NFS4_SPECIAL_STATEID_TYPE,
 };
 static DEFINE_MUTEX(nfs_clid_init_mutex);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-fix-overflow-in-vm_map_ram-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

