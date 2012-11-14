From: akpm@linux-foundation.org
Subject: + swapfile-fix-name-leak-in-swapoff.patch added to -mm tree
Date: Wed, 14 Nov 2012 12:00:16 -0800
Message-ID: <20121114200017.CACDA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62667 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161099Ab2KNUAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 15:00:20 -0500
Received: by mail-wi0-f202.google.com with SMTP id hm14so62712wib.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 12:00:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xtfeng@gmail.com, dannyfeng@tencent.com, jlayton@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: swapfile: fix name leak in swapoff
has been added to the -mm tree.  Its filename is
     swapfile-fix-name-leak-in-swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: swapfile: fix name leak in swapoff

There's a name leak introduced by 91a27b2 ("vfs: define struct filename
and have getname() return it").  Add the missing putname.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/swapfile.c~swapfile-fix-name-leak-in-swapoff mm/swapfile.c
--- a/mm/swapfile.c~swapfile-fix-name-leak-in-swapoff
+++ a/mm/swapfile.c
@@ -1608,6 +1608,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 out_dput:
 	filp_close(victim, NULL);
 out:
+	if (pathname && !IS_ERR(pathname))
+		putname(pathname);
 	return err;
 }
 
_

Patches currently in -mm which might be from xtfeng@gmail.com are

linux-next.patch
swapfile-fix-name-leak-in-swapoff.patch
swapfile-fix-name-leak-in-swapoff-fix.patch
tasklet-ignore-disabled-tasklet-in-tasklet_action.patch

