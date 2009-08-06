From: akpm@linux-foundation.org
Subject: [merged] include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch removed from -mm tree
Date: Thu, 06 Aug 2009 13:31:51 -0700
Message-ID: <200908062031.n76KVpDT005490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727AbZHFUdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 16:33:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, dhowells@redhat.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/cred.h: work around gcc-4.2.4 warning in get_cred()
has been removed from the -mm tree.  Its filename was
     include-linux-credh-work-around-gcc-424-warning-in-get_cred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/cred.h: work around gcc-4.2.4 warning in get_cred()
From: Paul Menage <menage@google.com>

With gcc 4.2.4 (building UML) I get the warning

include/linux/cred.h: In function 'get_cred':
include/linux/cred.h:189: warning: passing argument 1 of
'get_new_cred' discards qualifiers from pointer target type

Inserting an additional local variable appears to keep the compiler happy,
although it's not clear to me why this should be needed.

Signed-off-by: Paul Menage <menage@google.com>
Cc: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/cred.h~include-linux-credh-work-around-gcc-424-warning-in-get_cred include/linux/cred.h
--- a/include/linux/cred.h~include-linux-credh-work-around-gcc-424-warning-in-get_cred
+++ a/include/linux/cred.h
@@ -186,7 +186,8 @@ static inline struct cred *get_new_cred(
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	struct cred *nonconst_cred = (struct cred *) cred;
+	return get_new_cred(nonconst_cred);
 }
 
 /**
_

Patches currently in -mm which might be from menage@google.com are

linux-next.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware.patch
mm-make-set_mempolicympol_interleav-n_high_memory-aware-fix.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
oom-move-oom_adj-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
oom-fix-oom_adjust_write-input-sanity-check-fix.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
add-a-refcount-check-in-dput.patch

