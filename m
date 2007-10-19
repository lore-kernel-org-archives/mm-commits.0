From: akpm@linux-foundation.org
Subject: - cpuset-zero-malloc-revert-the-old-cpuset-fix.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:49:55 -0700
Message-ID: <200710192249.l9JMntl3024025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbXJSXMk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:12:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, balbir@in.ibm.com, clameter@sgi.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     cpuset: zero malloc - revert the old cpuset fix
has been removed from the -mm tree.  Its filename was
     cpuset-zero-malloc-revert-the-old-cpuset-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset: zero malloc - revert the old cpuset fix
From: Paul Jackson <pj@sgi.com>

The cpuset code to present a list of tasks using a cpuset to user space could
write to an array that it had kmalloc'd, after a kmalloc request of zero size.

The problem was that the code didn't check for writes past the allocated end
of the array until -after- the first write.

This is a race condition that is likely rare -- it would only show up if a
cpuset went from being empty to having a task in it, during the brief time
between the allocation and the first write.

Prior to roughly 2.6.22 kernels, this was also a benign problem, because a
zero kmalloc returned a few usable bytes anyway, and no harm was done with the
bogus write.

With the 2.6.22 kernel changes to make issue a warning if code tries to write
to the location returned from a zero size allocation, this problem is no
longer benign.  This cpuset code would occassionally trigger that warning.

The fix is trivial -- check before storing into the array, not after, whether
the array is big enough to hold the store.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-zero-malloc-revert-the-old-cpuset-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-zero-malloc-revert-the-old-cpuset-fix
+++ a/kernel/cpuset.c
@@ -1638,9 +1638,9 @@ static int pid_array_load(pid_t *pidarra
 
 	do_each_thread(g, p) {
 		if (p->cpuset == cs) {
+			pidarray[n++] = p->pid;
 			if (unlikely(n == npids))
 				goto array_full;
-			pidarray[n++] = p->pid;
 		}
 	} while_each_thread(g, p);
 
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-scsi-misc.patch
