From: akpm@linux-foundation.org
Subject: + sysctl-fix-memset-parameters-in-setup_sysctl_set.patch added to -mm tree
Date: Mon, 30 Jan 2012 15:37:36 -0800
Message-ID: <20120130233736.ED034A03DB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64190 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2A3Xhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 18:37:39 -0500
Received: by eaaf1 with SMTP id f1so221179eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 15:37:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, ebiederm@xmission.com


The patch titled
     Subject: sysctl: fix memset parameters in setup_sysctl_set()
has been added to the -mm tree.  Its filename is
     sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

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
Subject: sysctl: fix memset parameters in setup_sysctl_set()

The current code is a nop.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_sysctl.c~sysctl-fix-memset-parameters-in-setup_sysctl_set fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-fix-memset-parameters-in-setup_sysctl_set
+++ a/fs/proc/proc_sysctl.c
@@ -1547,7 +1547,7 @@ void setup_sysctl_set(struct ctl_table_s
 	struct ctl_table_root *root,
 	int (*is_seen)(struct ctl_table_set *))
 {
-	memset(set, sizeof(*set), 0);
+	memset(set, 0, sizeof(*set));
 	set->is_seen = is_seen;
 	init_header(&set->dir.header, root, set, NULL, root_table);
 }
_
Subject: Subject: sysctl: fix memset parameters in setup_sysctl_set()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
sysctl-remove-an-unused-variable.patch
sysctl-fix-memset-parameters-in-setup_sysctl_set.patch

