Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEB91514E4
	for <mm-commits@vger.kernel.org>; Sun, 16 Mar 2025 04:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742098233; cv=none; b=SRk28h+KwoQ5xXNaGs3V41mCD2y9eBOtmZBQZBwhKKJhrlf541RIyPI9SydE2MF4uGODzAjMxqKQ8FhAL13NplBFn8vuqEWNUGk7I7pMm2eA/SoK/xAoZnMMPOe4OCOej1VGF1wn+A+mq2QtxedOCiDnNTsON/RljG7gWO6XZgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742098233; c=relaxed/simple;
	bh=XP/wUgLqSpTPQisrd9MsPgi1W2rWXz2UdMcKiri+crs=;
	h=Date:To:From:Subject:Message-Id; b=jtDuy/qA/L6WizTuGFFVQ7xgd7Zv6ySWM7vx57Eh0f1Mla0QxUsDzBQwMMWw0RHv6K2LUSUEHi1ITt8kOxaSNbc4vuZ+gLj7DZ84KXueDhhfgxH/p9ziapyVUBzXPe6HuZ1RKwG9VgPlbs/QPlO8/BUfwjpn5RR2eBBw+a7fPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQwC1/z/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQwC1/z/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA81C4CEDD;
	Sun, 16 Mar 2025 04:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742098232;
	bh=XP/wUgLqSpTPQisrd9MsPgi1W2rWXz2UdMcKiri+crs=;
	h=Date:To:From:Subject:From;
	b=cQwC1/z/5imB+zIOcyY3uVIUmdzzYbO133C+CzzktC1Mpi3kuotolP/8bYOYddsQe
	 qxnQ1qdK7dYSEJK+loFmc2/8KGwpUOyGa3DXNX8QgmtZYCM1i3XfYxcyWVRLcMNlTl
	 DhVDWifFwwiDEpO7mgse53mb1rr6+3nU+N57L5Ys=
Date: Sat, 15 Mar 2025 21:10:31 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,gechangwei@live.cn,xie.ludan@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-use-sysfs_emit-instead-of-scnprintf.patch added to mm-nonmm-unstable branch
Message-Id: <20250316041032.4AA81C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: use sysfs_emit() instead of scnprintf()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-use-sysfs_emit-instead-of-scnprintf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-use-sysfs_emit-instead-of-scnprintf.patch

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
From: XieLudan <xie.ludan@zte.com.cn>
Subject: ocfs2: use sysfs_emit() instead of scnprintf()
Date: Sat, 15 Mar 2025 14:16:40 +0800 (CST)

Follow the advice in Documentation/filesystems/sysfs.rst: show() should
only use sysfs_emit() or sysfs_emit_at() when formatting the value to be
returned to user space.

Link: https://lkml.kernel.org/r/20250315141640564lv7R0CwIRPsmittXXjLbB@zte.com.cn
Signed-off-by: XieLudan <xie.ludan@zte.com.cn>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-sysfs_emit-instead-of-scnprintf
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -1308,7 +1308,7 @@ static int o2hb_debug_open(struct inode
 
 	case O2HB_DB_TYPE_REGION_NUMBER:
 		reg = (struct o2hb_region *)db->db_data;
-		out += scnprintf(buf + out, PAGE_SIZE - out, "%d\n",
+		out += sysfs_emit(buf + out, "%d\n",
 				reg->hr_region_num);
 		goto done;
 
@@ -1318,12 +1318,12 @@ static int o2hb_debug_open(struct inode
 		/* If 0, it has never been set before */
 		if (lts)
 			lts = jiffies_to_msecs(jiffies - lts);
-		out += scnprintf(buf + out, PAGE_SIZE - out, "%lu\n", lts);
+		out += sysfs_emit(buf + out, "%lu\n", lts);
 		goto done;
 
 	case O2HB_DB_TYPE_REGION_PINNED:
 		reg = (struct o2hb_region *)db->db_data;
-		out += scnprintf(buf + out, PAGE_SIZE - out, "%u\n",
+		out += sysfs_emit(buf + out, "%u\n",
 				!!reg->hr_item_pinned);
 		goto done;
 
@@ -1332,8 +1332,8 @@ static int o2hb_debug_open(struct inode
 	}
 
 	while ((i = find_next_bit(map, db->db_len, i + 1)) < db->db_len)
-		out += scnprintf(buf + out, PAGE_SIZE - out, "%d ", i);
-	out += scnprintf(buf + out, PAGE_SIZE - out, "\n");
+		out += sysfs_emit(buf + out, "%d ", i);
+	out += sysfs_emit(buf + out, "\n");
 
 done:
 	i_size_write(inode, out);
_

Patches currently in -mm which might be from xie.ludan@zte.com.cn are

ocfs2-use-sysfs_emit-instead-of-scnprintf.patch

