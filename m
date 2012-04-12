From: akpm@linux-foundation.org
Subject: + proc-use-mm_access-instead-of-ptrace_may_access.patch added to -mm tree
Date: Wed, 11 Apr 2012 17:48:03 -0700
Message-ID: <20120412004803.DC1B2A03A5@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49888 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2DLAsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Apr 2012 20:48:06 -0400
Received: by eaaq10 with SMTP id q10so63007eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Apr 2012 17:48:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com


The patch titled
     Subject: proc: use mm_access() instead of ptrace_may_access()
has been added to the -mm tree.  Its filename is
     proc-use-mm_access-instead-of-ptrace_may_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: proc: use mm_access() instead of ptrace_may_access()

mm_access() handles this much better, and avoids some race conditions.

Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN fs/proc/base.c~proc-use-mm_access-instead-of-ptrace_may_access fs/proc/base.c
--- a/fs/proc/base.c~proc-use-mm_access-instead-of-ptrace_may_access
+++ a/fs/proc/base.c
@@ -2035,11 +2035,8 @@ static int map_files_d_revalidate(struct
 	if (!task)
 		goto out_notask;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto out;
