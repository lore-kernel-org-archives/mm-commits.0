Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B642EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011356; cv=none; b=k4qtCO4RcLuoGIaxezKTtKhBkiw8xsJ6e5++4hoCNT19dU+KrUhbHc/fEAmv7aeLEdVXqVDeiuKakkNHkl/nMi6TZlnJJCoICZ+oH4THX3CHtOyyoNzpg5uOQA3gllqXF5h/rPaNmYtyTcBnkB6Vak7cdnM0Ibw2w9oIAjhWqgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011356; c=relaxed/simple;
	bh=18dPeogXWbC7fG9kScUfaur/JANkYstSOddjFU6ZvJA=;
	h=Date:To:From:Subject:Message-Id; b=umZwNH/2AVo/ACOyTs/ZiCQ9ON7CDI2eR1jTzlfPTb530Gw5zVlWO6pdltEZN0tqeNdK5LguqwdROVrNrlttQ+GsGJ9TYg28D6dL/9/N7oVsVAFp7m99LEqMX6SmGfbBF8qp6Z27Q/K2uSfLzLoH41/+Mq5uj0Kup1UzLM96rSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oVLGDaWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oVLGDaWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266C2C4CEE4;
	Mon, 12 May 2025 00:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011356;
	bh=18dPeogXWbC7fG9kScUfaur/JANkYstSOddjFU6ZvJA=;
	h=Date:To:From:Subject:From;
	b=oVLGDaWy7/AFH8/B5BJSYjbJfq+gFEsXH0LeKCJb0tJ0QroX517ndxqpv1ZfzGDF8
	 FYAtWh3SeooZNsIoW7wjVrSLwG0o423pCJtfzxgm46n8kgCU6nyv5ZqCkVQGiJRpex
	 zFNwtEZu0ywwyL7OGzb2q3SRcSWQnvJMB4ynM1sg=
Date: Sun, 11 May 2025 17:55:55 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch removed from -mm tree
Message-Id: <20250512005556.266C2C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
has been removed from the -mm tree.  Its filename was
     ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: ocfs2: o2net_idle_timer: Rename del_timer_sync in comment
Date: Fri, 11 Apr 2025 18:26:10 +0800

Commit 8fa7292fee5c ("treewide: Switch/rename to timer_delete[_sync]()")
switched del_timer_sync to timer_delete_sync, but did not modify the
comment for o2net_idle_timer().  Now fix it.

Link: https://lkml.kernel.org/r/BDDB1E4E2876C36C+20250411102610.165946-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Acked-by: Joseph Qi <jiangqi903@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
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


