From: akpm@linux-foundation.org
Subject: + proc-use-kzalloc-instead-of-kmalloc-and-memset.patch added to -mm tree
Date: Wed, 05 Sep 2012 14:37:10 -0700
Message-ID: <20120905213712.882571E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:43807 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538Ab2IEVhP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Sep 2012 17:37:15 -0400
Received: by ghbz15 with SMTP id z15so114043ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Sep 2012 14:37:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com


The patch titled
     Subject: proc: use kzalloc instead of kmalloc and memset
has been added to the -mm tree.  Its filename is
     proc-use-kzalloc-instead-of-kmalloc-and-memset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yan <clouds.yan@gmail.com>
Subject: proc: use kzalloc instead of kmalloc and memset

Part of the memory will be written twice after this change, but that
should be negligible.

Signed-off-by: yan <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset fs/proc/generic.c
--- a/fs/proc/generic.c~proc-use-kzalloc-instead-of-kmalloc-and-memset
+++ a/fs/proc/generic.c
@@ -616,10 +616,9 @@ static struct proc_dir_entry *__proc_cre
 
 	len = strlen(fn);
 
-	ent = kmalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
+	ent = kzalloc(sizeof(struct proc_dir_entry) + len + 1, GFP_KERNEL);
 	if (!ent) goto out;
 
-	memset(ent, 0, sizeof(struct proc_dir_entry));
 	memcpy(ent->name, fn, len + 1);
 	ent->namelen = len;
 	ent->mode = mode;
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

proc-return-enomem-when-inode-allocation-failed.patch
proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

