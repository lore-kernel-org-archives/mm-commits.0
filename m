From: akpm@linux-foundation.org
Subject: [merged] binary_sysctl-fix-memory-leak.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:53 -0800
Message-ID: <20111228220454.20A335C0076@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:56781 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, eparis@redhat.com, hch@infradead.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: binary_sysctl(): fix memory leak
has been removed from the -mm tree.  Its filename was
     binary_sysctl-fix-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: binary_sysctl(): fix memory leak

binary_sysctl() calls sysctl_getname() which allocates from names_cache
slab usin __getname()

The matching function to free the name is __putname(), and not putname()
which should be used only to match getname() allocations.

This is because when auditing is enabled, putname() calls audit_putname
*instead* (not in addition) to __putname().  Then, if a syscall is in
progress, audit_putname does not release the name - instead, it expects
the name to get released when the syscall completes, but that will happen
only if audit_getname() was called previously, i.e.  if the name was
allocated with getname() rather than the naked __getname().  So,
__getname() followed by putname() ends up leaking memory.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_binary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl_binary.c~binary_sysctl-fix-memory-leak kernel/sysctl_binary.c
--- a/kernel/sysctl_binary.c~binary_sysctl-fix-memory-leak
+++ a/kernel/sysctl_binary.c
@@ -1354,7 +1354,7 @@ static ssize_t binary_sysctl(const int *
 
 	fput(file);
 out_putname:
-	putname(pathname);
+	__putname(pathname);
 out:
 	return result;
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

