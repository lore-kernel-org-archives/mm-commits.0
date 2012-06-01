From: akpm@linux-foundation.org
Subject: [merged] proc-use-mm_access-instead-of-ptrace_may_access.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:52 -0700
Message-ID: <20120601193352.5D1B0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40431 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063Ab2FATdx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:53 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so138654bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, hughd@google.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: use mm_access() instead of ptrace_may_access()
has been removed from the -mm tree.  Its filename was
     proc-use-mm_access-instead-of-ptrace_may_access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -2022,11 +2022,8 @@ static int map_files_d_revalidate(struct
 	if (!task)
 		goto out_notask;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto out;
