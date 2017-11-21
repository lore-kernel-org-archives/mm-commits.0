From: akpm@linux-foundation.org
Subject: +
 forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch added to
 -mm tree
Date: Tue, 21 Nov 2017 15:19:31 -0800
Message-ID: <5a14b483.HKRD4AYw4un4ULeZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39656 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdKUXTc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:19:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcos.souza.org@gmail.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork.c: add comment about usage of CLONE_FS flags and namespaces
has been added to the -mm tree.  Its filename is
     forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1570,6 +1570,10 @@ static __latent_entropy struct task_stru
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

forkc-check-error-and-return-early.patch
forkc-add-doc-about-usage-of-clone_fs-flags-and-namespaces.patch

