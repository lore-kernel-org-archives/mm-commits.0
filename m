From: akpm@linux-foundation.org
Subject: [merged]
 forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:58:11 -0800
Message-ID: <20180207195811.b1T9EXk3L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754337AbeBGT6N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, marcos.souza.org@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: add comment about usage of CLONE_FS flags and namespaces
has been removed from the -mm tree.  Its filename was
     forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: kernel/fork.c: add comment about usage of CLONE_FS flags and namespaces

All other places that deals with namespaces have an explanation of why the
restriction is there.  The description added in this commit was based on
e66eded8309eb ("userns: Don't allow CLONE_NEWUSER | CLONE_FS").

Link: http://lkml.kernel.org/r/20171112151637.13258-1-marcos.souza.org@gmail.com
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/fork.c~forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces kernel/fork.c
--- a/kernel/fork.c~forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces
+++ a/kernel/fork.c
@@ -1587,6 +1587,10 @@ static __latent_entropy struct task_stru
 	int retval;
 	struct task_struct *p;
 
+	/*
+	 * Don't allow sharing the root directory with processes in a different
+	 * namespace
+	 */
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
_

Patches currently in -mm which might be from marcos.souza.org@gmail.com are


