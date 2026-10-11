Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F4513B5B3;
	Sun, 11 Oct 2026 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757190; cv=none; b=be00HSjH7GKFo7Hb7QCOIW2K+xbCw9hEkLt/4dQSgvmHhjiXGWXaI1xZf9W5zpUCC9obJXyJ0hWitJYWR+HQWeAUhQ/LG/zkrA9sguL9TOregPzjIb+DQN37v60WvbYWgZfBUzccX2TLRYqFEzJupFe2BT9MmCO6PQV6cZuJmVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757190; c=relaxed/simple;
	bh=Lk6m2NMnTL4aRugo6B27NBXyOdel1PoILGkGRwMV16I=;
	h=Date:To:From:Subject:Message-Id; b=mDjiPV8Bwds6jDzvJqYbsjyzU3T9iMOfWRj+peEY6QZ4HLZY1jfeLEdcz8oKobspi1V6l1rHNYxrqLHEBR6aeTWWxZPmrlC17J82hWaNBJm9UnEQOt8vN72wJXTpININT2oQwG99+uPaOqzwgMIIU32jaOHpiIPf0gahjxxQqFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F67+7AHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F67+7AHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBCD1F0089C;
	Sun, 11 Oct 2026 22:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757188;
	bh=t6Se+3ZSPFBFzfStVUQZbNlryyS44gYL9ELc8fNSp14=;
	h=Date:To:From:Subject;
	b=F67+7AHK/JdSLJFIhT5Pz/6DdJpO3Amy9r+SVdHqia/U4PSPDwBv+EDlx7UrqVzfh
	 47QgHQX+gpOeoKqOdcgeYfrFit5ZgRMFaK4Znl6hQx2tjLi3b/F0VG6uvHyhE8jAj0
	 ZnVQsApBBHOyXoj5xN0ZNBQHc49Yj+o+S0fzcCiM=
Date: Sun, 11 Oct 2026 15:19:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,glass.su@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-update-xattr-count-before-moving-bucket-entries.patch removed from -mm tree
Message-Id: <20261011221948.BDBCD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: update xattr count before moving bucket entries
has been removed from the -mm tree.  Its filename was
     ocfs2-update-xattr-count-before-moving-bucket-entries.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2146,12 +2146,17 @@ static void ocfs2_xa_bucket_add_entry(st
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


