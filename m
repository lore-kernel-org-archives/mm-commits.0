From: akpm@linux-foundation.org
Subject: + binary_sysctl-fix-memory-leak.patch added to -mm tree
Date: Thu, 15 Dec 2011 15:25:35 -0800
Message-ID: <20111215232535.AD27210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:34326 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759754Ab1LOXZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 18:25:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, eparis@redhat.com, hch@infradead.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: binary_sysctl(): fix memory leak
has been added to the -mm tree.  Its filename is
     binary_sysctl-fix-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: binary_sysctl(): fix memory leak

Patches currently in -mm which might be from walken@google.com are

binary_sysctl-fix-memory-leak.patch
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

