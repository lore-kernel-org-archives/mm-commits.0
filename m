From: akpm@linux-foundation.org
Subject: [folded-merged] ncpfs-dont-allow-negative-timeouts-fix.patch
 removed from -mm tree
Date: Fri, 20 Nov 2015 15:49:12 -0800
Message-ID: <564fb178.AQbbd9bl/swJFFcB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162984AbbKTXtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Nov 2015 18:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, dhowells@redhat.com, jack@suse.com, jack@suse.cz, petr@vandrovec.name, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs-dont-allow-negative-timeouts-fix
has been removed from the -mm tree.  Its filename was
     ncpfs-dont-allow-negative-timeouts-fix.patch

This patch was dropped because it was folded into ncpfs-dont-allow-negative-timeouts.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ncpfs-dont-allow-negative-timeouts-fix

remove unneeded `else'

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts-fix fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-dont-allow-negative-timeouts-fix
+++ a/fs/ncpfs/ioctl.c
@@ -527,7 +527,7 @@ static long __ncp_ioctl(struct inode *in
 				case NCP_LOCK_SH:
 						if (rqdata.timeout < 0)
 							return -EINVAL;
-						else if (rqdata.timeout == 0)
+						if (rqdata.timeout == 0)
 							rqdata.timeout = NCP_LOCK_DEFAULT_TIMEOUT;
 						else if (rqdata.timeout > NCP_LOCK_MAX_TIMEOUT)
 							rqdata.timeout = NCP_LOCK_MAX_TIMEOUT;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts.patch
writeback-initialize-m_dirty-to-avoid-compile-warning-fix.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
a.patch
b.patch

