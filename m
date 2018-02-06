From: akpm@linux-foundation.org
Subject: [patch 061/114] kernel/fork.c: add comment about usage of
 CLONE_FS flags and namespaces
Date: Tue, 06 Feb 2018 15:39:34 -0800
Message-ID: <20180206233934.9tEr8bin6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, marcos.souza.org@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
