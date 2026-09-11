Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11859D63F;
	Fri, 11 Sep 2026 20:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789157578; cv=none; b=pxN4FuWfrLdjLtnZ/dzHGrwLc7SP2TC3Unj7ECW5fSwehb9ot04/NffKLJnei/+DDBgBsSzTVnalq68MLnPD9YFZwitrQEEqgD01kY5873Y7jdn4Tc7yMqe/ppOqx1xAysACbcLEcgo1H/y1riWJcXMMnzEEnTagKmxxAWQc5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789157578; c=relaxed/simple;
	bh=ykt6hZfTHxY+R1+uLcW3Kl81d3VNWtpGFOo0VN88olg=;
	h=Date:To:From:Subject:Message-Id; b=sM+0zl6CGDvW4V18JYg2Fr3j2jmvygykyk5641G/uoDFwH7jLCWHcDvn/b+qT2zdkmR8bhLi+VK6Huav3JJb2t1mQuD0TvhIeoiAy1CSJhWOQ6f89ShQMyVB2Fd8VXW7XQkU4uIQlYlzF6aLDhal+xeFKz+ZbQNtavQ3HqDe9oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iqavFDAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iqavFDAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C9E1F000FF;
	Fri, 11 Sep 2026 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789157561;
	bh=oPY5g7TXw11krhDOoI8XikJQD2KOiYEIXjgjqw3uk/g=;
	h=Date:To:From:Subject;
	b=iqavFDAd0Z7UMb3Wjg9nRqezZJME5OPeArBqDF85sWzmq/tZeXR4TAVug+OlHLn/I
	 Kt8lARK092/Tfskg6zadTyn0+Ea0DNHY829O9OxvaEyHgQyPk3AGEA+H0BSwlrVXzh
	 SEiVO4Zk1cEouT+9uRgkibIoWF9qZAZz9VHyNkX8=
Date: Fri, 11 Sep 2026 13:12:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,tj@kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,jack@suse.cz,dennis@kernel.org,brauner@kernel.org,perf.patrick.lu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-bound-cleanup_offline_cgwb-rescans-by-rotating-scanned-inodes.patch added to mm-new branch
Message-Id: <20260911201240.E1C9E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes
has been added to the -mm mm-new branch.  Its filename is
     writeback-bound-cleanup_offline_cgwb-rescans-by-rotating-scanned-inodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-bound-cleanup_offline_cgwb-rescans-by-rotating-scanned-inodes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>
Subject: writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes
Date: Fri, 11 Sep 2026 18:49:49 +0000

cleanup_offline_cgwb() prepares at most WB_MAX_INODES_PER_ISW inodes per
call and is called again until the dying wb is drained, but every call
walks wb->b_attached and then wb->b_dirty_time from the same end.  Inodes
already prepared (they stay on the list with I_WB_SWITCH set until the
switch worker runs) and inodes that cannot be switched (I_FREEING,
I_WILL_FREE, !SB_ACTIVE, DAX, already on the target wb) stay where they
are, so each pass rescans a growing run of them under wb->list_lock and a
full drain is quadratic in the number of inodes on the list.  With ~17M
inodes attached to one dying cgwb we saw this end in soft lockups, with
CPUs reported stuck for 21-48s.

Walk both lists from the oldest end and move every scanned inode to the
newest end, so the next pass starts where the previous one stopped and the
drain becomes linear.  b_attached is unordered, so nobody sees the reorder
there.  b_dirty_time is ordered by dirtied_when, but the oldest unscanned
inode stays at the end move_expired_inodes() picks from, sync takes the
whole list regardless of order, and prepared inodes leave the list as soon
as the switch work runs and get a new dirtied_time_when on the new wb
anyway, so the only inodes left out of order are the ones that can never
switch (DAX), and only on the dying wb.

Seen in production on a 6.18-based kernel: with ~17M inodes attached to
one dying cgwb, a node spent 36 minutes in back-to-back wb->list_lock
holds by the cleanup scanner (~6ms each, ~46% of wall time, starving
writeback on that wb); with v1 of this patch the same workload drains in
~30 seconds.  Also seen on stock Amazon Linux 2023 6.12.68 as isw workers
spinning on the list_lock in inode_switch_wbs_work_fn() while
cleanup_offline_cgwbs_workfn() runs.

Link: https://lore.kernel.org/20260911-wb-cgwb-rotate-v2-1-a9ab253a1295@gmail.com
Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
Signed-off-by: Patrick Lu (Anthropic) <perf.patrick.lu@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Assisted-by: LLM
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/fs/fs-writeback.c~writeback-bound-cleanup_offline_cgwb-rescans-by-rotating-scanned-inodes
+++ a/fs/fs-writeback.c
@@ -727,19 +727,34 @@ static bool isw_prepare_wbs_switch(struc
 				   struct inode_switch_wbs_context *isw,
 				   struct list_head *list, int *nr)
 {
-	struct inode *inode;
+	struct inode *inode, *tmp;
+	LIST_HEAD(scanned);
+	bool full = false;
+
+	/*
+	 * Walk from the oldest end and move scanned inodes to the newest
+	 * end, so the next scan resumes at unscanned inodes instead of
+	 * re-walking an ever-growing run of prepared and skipped ones.
+	 * For b_dirty_time this keeps the oldest unscanned inode at the
+	 * end move_expired_inodes() picks from; b_attached is unordered.
+	 */
+	list_for_each_entry_safe_reverse(inode, tmp, list, i_io_list) {
+		list_move(&inode->i_io_list, &scanned);
 
-	list_for_each_entry(inode, list, i_io_list) {
 		if (!inode_prepare_wbs_switch(inode, new_wb))
 			continue;
 
 		isw->inodes[*nr] = inode;
 		(*nr)++;
 
-		if (*nr >= WB_MAX_INODES_PER_ISW - 1)
-			return true;
+		if (*nr >= WB_MAX_INODES_PER_ISW - 1) {
+			full = true;
+			break;
+		}
 	}
-	return false;
+	list_splice(&scanned, list);
+
+	return full;
 }
 
 /**
_

Patches currently in -mm which might be from perf.patrick.lu@gmail.com are

writeback-bound-cleanup_offline_cgwb-rescans-by-rotating-scanned-inodes.patch

