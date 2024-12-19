Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184B1EA90;
	Thu, 19 Dec 2024 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577519; cv=none; b=g+R7xo1dRU69CN9hFj8J9FvK036FPJZ8Q1bv5MD0OAYHIkZpFYGGAz6yaVGkDoRrj3Sg0y+Z/Cw0Z51zDUx8jtUQHvZlpOOHEWyV5QWQLNtyOFf0lm2bI+CO7Hob3oaYXu0xzjT6aistqfqhKKc2rK9/Rj/mP0x7zOQGYwXs4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577519; c=relaxed/simple;
	bh=JOkHKAZmmDRTafDILYGZ0SLaPtLJIAgr1QfpbFSw1Po=;
	h=Date:To:From:Subject:Message-Id; b=PqteKYvS0oGQWzKEn7Ofy6OOAFdxe8Dx0v2vuPc6J4TDAnMHFrysBhQR3J4Vfj3/dfQ25lDp/D+gLfzkc6n0Nvbv1DJTR+vCacHD6uyw+jeGg822yvDyrul9wykLYT0jN6ysgmte6ccDPpZglzUo8bmBBgR9JqQNIFCFpdJu/vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sq+C8KAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sq+C8KAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0387CC4CECD;
	Thu, 19 Dec 2024 03:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577519;
	bh=JOkHKAZmmDRTafDILYGZ0SLaPtLJIAgr1QfpbFSw1Po=;
	h=Date:To:From:Subject:From;
	b=Sq+C8KAXLvuZDbszzz21u3vLx9mmK7laHqzEnNMszgNWIcyXhPAHap+YXW8QkoT/7
	 Qg/vU7Rxrw5aCTBVPX4Udjfx47ZJDoevq8qMiAYs5BMNv+F+xO0nclE2P87GsVSO1o
	 JelF9IwVQVdARTywnnqLqbKxlMnYdc8IH7oOlL1c=
Date: Wed, 18 Dec 2024 19:05:18 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch removed from -mm tree
Message-Id: <20241219030519.0387CC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix the space leak in LA when releasing LA
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-the-space-leak-in-la-when-releasing-la.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix the space leak in LA when releasing LA
Date: Thu, 5 Dec 2024 18:48:33 +0800

Commit 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
introduced an issue, the ocfs2_sync_local_to_main() ignores the last
contiguous free bits, which causes an OCFS2 volume to lose the last free
clusters of LA window during the release routine.

Please note, because commit dfe6c5692fb5 ("ocfs2: fix the la space leak
when unmounting an ocfs2 volume") was reverted, this commit is a
replacement fix for commit dfe6c5692fb5.

Link: https://lkml.kernel.org/r/20241205104835.18223-3-heming.zhao@suse.com
Fixes: 30dd3478c3cd ("ocfs2: correctly use ocfs2_find_next_zero_bit()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/localalloc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/localalloc.c~ocfs2-fix-the-space-leak-in-la-when-releasing-la
+++ a/fs/ocfs2/localalloc.c
@@ -971,9 +971,9 @@ static int ocfs2_sync_local_to_main(stru
 	start = count = 0;
 	left = le32_to_cpu(alloc->id1.bitmap1.i_total);
 
-	while ((bit_off = ocfs2_find_next_zero_bit(bitmap, left, start)) <
-	       left) {
-		if (bit_off == start) {
+	while (1) {
+		bit_off = ocfs2_find_next_zero_bit(bitmap, left, start);
+		if ((bit_off < left) && (bit_off == start)) {
 			count++;
 			start++;
 			continue;
@@ -998,6 +998,8 @@ static int ocfs2_sync_local_to_main(stru
 			}
 		}
 
+		if (bit_off >= left)
+			break;
 		count = 1;
 		start = bit_off + 1;
 	}
_

Patches currently in -mm which might be from heming.zhao@suse.com are


