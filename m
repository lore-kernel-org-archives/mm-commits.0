From: akpm@linux-foundation.org
Subject: + ncpfs-dont-allow-negative-timeouts-fix.patch added to -mm tree
Date: Wed, 11 Nov 2015 14:58:36 -0800
Message-ID: <5643c81c.wJPTQ3zwC9cC9oOD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKW6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 17:58:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, dhowells@redhat.com, jack@suse.com, jack@suse.cz, petr@vandrovec.name, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ncpfs-dont-allow-negative-timeouts-fix
has been added to the -mm tree.  Its filename is
     ncpfs-dont-allow-negative-timeouts-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-dont-allow-negative-timeouts-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-dont-allow-negative-timeouts-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

