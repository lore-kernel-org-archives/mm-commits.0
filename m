Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3C942C0B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 06:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742192740; cv=none; b=S3H9YrqYVJExelMUQz41nZeT0dwoLLHXlNW4jK10ugCZ8ppQu6hynQbRcvqz5lkVCGSndVmyyJmALSylC7kollSQwbJnJInmybzfB6a6IxCbe5/kvGOxH2IPiH59LG6a8PYrdgbXkiDKY03BrdnhHHhmKl1rUVNbGSDB6LIw+x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742192740; c=relaxed/simple;
	bh=2kuFL3GzNNaQf73+McCa7x7WVRpi0rVa4F4FArQR+rg=;
	h=Date:To:From:Subject:Message-Id; b=bOPyJaX19+JeJsYY8TIuMRhC2UL9BNTKk7sKX2pLsOFyhKM7M0hQiCSrxE/zonATL0gdOYVmTWTYstBascPA6DdVnHda30USvJ+PPMKliqdXbhvLXF5PuPT4401ZS/kkq4sfCtXy2O1BiyooSr9wlRZrlNsAsKRF92J+Ra7o2Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DmTiRiAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DmTiRiAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550E9C4CEEC;
	Mon, 17 Mar 2025 06:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742192739;
	bh=2kuFL3GzNNaQf73+McCa7x7WVRpi0rVa4F4FArQR+rg=;
	h=Date:To:From:Subject:From;
	b=DmTiRiAQ/csKt9OT8VT/NwyJ+LWWkvsP4uSPgbTJlbYAcFwiJZiiB/vCC5g7AyLS9
	 CimcivEriFe5M8+BtrpCD+EmC2/agn5jEg9837TohZmSJAIc1N2FOeUWvvyZR4U5/h
	 /FCTAbNXes3eENiU7oy0O/NT6CRDC7TaE8qicpVE=
Date: Sun, 16 Mar 2025 23:25:38 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jirislaby@kernel.org,jiangqi903@gmail.com,gechangwei@live.cn,xie.ludan@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] ocfs2-use-sysfs_emit-instead-of-scnprintf.patch removed from -mm tree
Message-Id: <20250317062539.550E9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: use sysfs_emit() instead of scnprintf()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-sysfs_emit-instead-of-scnprintf.patch

This patch was dropped because it was nacked

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
Cc: Jiri Slaby <jirislaby@kernel.org>
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


