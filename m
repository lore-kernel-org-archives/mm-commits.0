From: akpm@linux-foundation.org
Subject: [merged] pidns-make-create_pid_namespace-accept-parent-pidns.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:30 -0700
Message-ID: <200906182247.n5IMlUxD006650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755652AbZFRWsD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ebiederm@xmission.com, serue@us.ibm.com, sukadev@linux.vnet.ibm.com, xemul@openvz.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pidns: make create_pid_namespace() accept parent pidns
has been removed from the -mm tree.  Its filename was
     pidns-make-create_pid_namespace-accept-parent-pidns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: make create_pid_namespace() accept parent pidns
From: Alexey Dobriyan <adobriyan@gmail.com>

create_pid_namespace() creates everything, but caller has to assign parent
pidns by hand, which is unnatural.  At the moment of call new ->level has
to be taken from somewhere and parent pidns is already available.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-make-create_pid_namespace-accept-parent-pidns kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-create_pid_namespace-accept-parent-pidns
+++ a/kernel/pid_namespace.c
@@ -67,9 +67,10 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(unsigned int level)
+static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
+	unsigned int level = parent_pid_ns->level + 1;
 	int i;
 
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
@@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
@@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsign
 	if (flags & CLONE_THREAD)
 		goto out_put;
 
-	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (!IS_ERR(new_ns))
-		new_ns->parent = get_pid_ns(old_ns);
+	new_ns = create_pid_namespace(old_ns);
 
 out_put:
 	put_pid_ns(old_ns);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
procfs-provide-stack-information-for-threads-v08.patch

