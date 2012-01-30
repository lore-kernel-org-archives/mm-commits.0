From: akpm@linux-foundation.org
Subject: + sysctl-remove-an-unused-variable.patch added to -mm tree
Date: Mon, 30 Jan 2012 15:37:34 -0800
Message-ID: <20120130233735.5A752A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33914 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2A3Xhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 18:37:37 -0500
Received: by eekb15 with SMTP id b15so239880eek.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 15:37:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, ebiederm@xmission.com


The patch titled
     Subject: sysctl: remove an unused variable
has been added to the -mm tree.  Its filename is
     sysctl-remove-an-unused-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: sysctl: remove an unused variable

"links" is never used, so we can remove it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-remove-an-unused-variable fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-remove-an-unused-variable
+++ a/fs/proc/proc_sysctl.c
@@ -1165,7 +1165,6 @@ struct ctl_table_header *__register_sysc
 	const char *path, struct ctl_table *table)
 {
 	struct ctl_table_root *root = set->dir.header.root;
-	struct ctl_table_header *links = NULL;
 	struct ctl_table_header *header;
 	const char *name, *nextname;
 	struct ctl_dir *dir;
@@ -1222,7 +1221,6 @@ fail_put_dir_locked:
 	drop_sysctl_table(&dir->header);
 	spin_unlock(&sysctl_lock);
 fail:
-	kfree(links);
 	kfree(header);
 	dump_stack();
 	return NULL;
_
Subject: Subject: sysctl: remove an unused variable

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
sysctl-remove-an-unused-variable.patch
sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

