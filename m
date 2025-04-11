Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4E61C8639
	for <mm-commits@vger.kernel.org>; Fri, 11 Apr 2025 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744410622; cv=none; b=XalK+DVboohN1V2Oh+u4EowJhF4YnkKLtJavtyhdr8f66hTx824O3dFyZEGVtLyYQAhieVRceJfXXv+4Jfi3qyZ6js4M5IeZY0CKZs50Ce/xaTTD7bVzix+w01yDIzxZkcHJCUo18cQT5KSPYo0FIlWJUpB48aFSfxynHd3OIyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744410622; c=relaxed/simple;
	bh=3UVcAmXsBAdAk08QGdkQefUiGHKSJKtkiyEsHjH/Z0s=;
	h=Date:To:From:Subject:Message-Id; b=b46szPEncY9qeJ8LIweH106Rs5y0xaIIVctWs2SXKXRXYrKtfnaDbCQWTzUiQDNRCvpMBby7XD30HcHd3XmhRqv4NGbTUFO0PiN7kDLnnPmob1JzWBF7Vq0ipJei20S+3O9Bm3nmUeGYA3cdDGxwX7zI5ohiZwdqMGdUJTsEbF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9ppJVf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9ppJVf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73435C4CEE2;
	Fri, 11 Apr 2025 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744410621;
	bh=3UVcAmXsBAdAk08QGdkQefUiGHKSJKtkiyEsHjH/Z0s=;
	h=Date:To:From:Subject:From;
	b=E9ppJVf9MMiFoMdQDO0deKp7OqiGyahdmQtO5S1NyUlXmomnIBRENQn3o0B8twsbX
	 PSIX9K5p24nf+KiWZXOs1qz9Fa2H8h2EG73FMNMAFKIJEceoKbWPGUvJ2vqbMvP60A
	 9rHkgJ7H1NsgumHicFTfrxmdluU5dIQt6TpfhzHM=
Date: Fri, 11 Apr 2025 15:30:20 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch added to mm-nonmm-unstable branch
Message-Id: <20250411223021.73435C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
Date: Fri, 11 Apr 2025 18:26:10 +0800

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer_sync to timer_delete_sync, but did not modify the
comment for o2net_idle_timer().  Now fix it.

Link: https://lkml.kernel.org/r/BDDB1E4E2876C36C+20250411102610.165946-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/tcp.c~ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1483,7 +1483,7 @@ static void o2net_sc_send_keep_req(struc
 	sc_put(sc);
 }
 
-/* socket shutdown does a del_timer_sync against this as it tears down.
+/* socket shutdown does a timer_delete_sync against this as it tears down.
  * we can't start this timer until we've got to the point in sc buildup
  * where shutdown is going to be involved */
 static void o2net_idle_timer(struct timer_list *t)
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

