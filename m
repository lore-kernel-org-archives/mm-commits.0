From: akpm@linux-foundation.org
Subject: [merged] pidns-rewrite-copy_pid_ns.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:32 -0700
Message-ID: <200906182247.n5IMlW1h006655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756499AbZFRWst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pidns: rewrite copy_pid_ns()
has been removed from the -mm tree.  Its filename was
     pidns-rewrite-copy_pid_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: rewrite copy_pid_ns()
From: Alexey Dobriyan <adobriyan@gmail.com>

copy_pid_ns() is a perfect example of a case where unwinding leads to more
code and makes it less clear.  Watch the diffstat.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-rewrite-copy_pid_ns kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-rewrite-copy_pid_ns
+++ a/kernel/pid_namespace.c
@@ -116,23 +116,11 @@ static void destroy_pid_namespace(struct
 
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
 {
-	struct pid_namespace *new_ns;
-
-	BUG_ON(!old_ns);
-	new_ns = get_pid_ns(old_ns);
 	if (!(flags & CLONE_NEWPID))
-		goto out;
-
-	new_ns = ERR_PTR(-EINVAL);
+		return get_pid_ns(old_ns);
 	if (flags & CLONE_THREAD)
-		goto out_put;
-
-	new_ns = create_pid_namespace(old_ns);
