Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E45E3A3E97;
	Thu, 17 Sep 2026 04:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789619526; cv=none; b=rOCOmM488KY3XK9o7BGcr7tj306VkjI9CVia3S7JMJVUtd6gFx1Ja/WL/frTfxVzg6XOhBISY2rW9IqCOOQPE/XnAQaC+OLn9tYV1AXTSZSxRKtr+5DMAer4AROKmyD4fCGRF5LDaty/wy27bKfTbyPS7onMpF9hFkeWd1XnfDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789619526; c=relaxed/simple;
	bh=SqUW9aXFBvmGCJq4VuHk8C79kMNR+fOJUJEASGV+D2w=;
	h=Date:To:From:Subject:Message-Id; b=KjEg6wOfvchBmpy26MzqvqLqLLR2+OViqaMtPr1sXAMtQHk6spw4WdGaUk93rxXqNDYQ3gSIkud3ohIxDZStfTvd3QDbtrsn/WI+rg5sXsFndipzD+JT32rlnyviNq4lvvkrx5BGQN+evmXOgi7LneVs6vX+jOVAjcr8kYHDed8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H6rRrdU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H6rRrdU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86C31F0089A;
	Thu, 17 Sep 2026 04:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789619525;
	bh=SwWKR2IU/udx3ogpOMYEM5Mnd8XUfetdO263vMW3iAU=;
	h=Date:To:From:Subject;
	b=H6rRrdU6YAUZx55/KFquuaJzLKxbjKfkDE/qJkAKRs7IlEcBbsMQ7wgKyTOMh6zNx
	 pY5vYybfsTrhD25nnqlNykgT07FnW/0FS7cAGrfh9lKuPyKXzze0nUgTDCY/OH/5Vo
	 SqO74jSD44Fiw2ESwzcdBXlZ3pJudrdfeEBpZvJI=
Date: Wed, 16 Sep 2026 21:32:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-update-xattr-count-before-moving-bucket-entries.patch added to mm-nonmm-unstable branch
Message-Id: <20260917043204.D86C31F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: update xattr count before moving bucket entries
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-update-xattr-count-before-moving-bucket-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-update-xattr-count-before-moving-bucket-entries.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Su Yue <glass.su@suse.com>
Subject: ocfs2: update xattr count before moving bucket entries
Date: Wed, 16 Sep 2026 10:47:50 +0800

Since commit 2f26f58df041 ("ocfs2: annotate flexible array members with
__counted_by_le()"), the xh_entries array is annotated with
__counted_by_le(xh_count), so FORTIFY uses xh_count to determine its
bounds.  When inserting an entry into a bucket,
ocfs2_xa_bucket_add_entry() shifts existing entries before incrementing
xh_count.  The destination therefore extends one entry past the bounds
described by the old count.

With CONFIG_CC_HAS_COUNTED_BY and CONFIG_FORTIFY_SOURCE enabled,
ocfs2-test: single_run-WIP.sh -t reflink triggers the following failure
while adding an extended attribute:

[  150.156484] memmove: detected buffer overflow: 352 byte write of buffer size 336
[  150.156487] WARNING: lib/string_helpers.c:1036 at __fortify_report+0x3d/0x50, CPU#15: reflink_test/2336
[  150.160496] RIP: 0010:__fortify_report+0x40/0x50
[  150.164031] Call Trace:
[  150.164141]  <TASK>
[  150.164232]  __fortify_panic+0x9/0xb
[  150.164383]  ocfs2_xa_bucket_add_entry.cold+0x17/0x28 [ocfs2]
[  150.164661]  ocfs2_xa_set+0x8fb/0xf40 [ocfs2]

Increment xh_count before memmove() so the destination bounds include the
new entry.  Keep the local count unchanged to calculate the insertion
position and move length from the original number of entries.  The caller
has already checked that there is enough space for the new entry.

Link: https://lore.kernel.org/20260916024750.9450-1-glass.su@suse.com
Fixes: 2f26f58df041 ("ocfs2: annotate flexible array members with __counted_by_le()")
Signed-off-by: Su Yue <glass.su@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/xattr.c~ocfs2-update-xattr-count-before-moving-bucket-entries
+++ a/fs/ocfs2/xattr.c
@@ -2159,12 +2159,17 @@ static void ocfs2_xa_bucket_add_entry(st
 		}
 	}
 
+	/*
+	 * Increment xh_count before memmove() so __counted_by_le(xh_count)
+	 * includes the new entry in the destination bounds.
+	 */
+	le16_add_cpu(&xh->xh_count, 1);
+
 	if (low != count)
 		memmove(&xh->xh_entries[low + 1],
 			&xh->xh_entries[low],
 			((count - low) * sizeof(struct ocfs2_xattr_entry)));
 
-	le16_add_cpu(&xh->xh_count, 1);
 	loc->xl_entry = &xh->xh_entries[low];
 	memset(loc->xl_entry, 0, sizeof(struct ocfs2_xattr_entry));
 }
_

Patches currently in -mm which might be from glass.su@suse.com are

ocfs2-update-xattr-count-before-moving-bucket-entries.patch

