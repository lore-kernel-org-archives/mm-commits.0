Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9943EDE59;
	Tue,  4 Aug 2026 04:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816353; cv=none; b=FCpUzxuo36fMT7f2HXTSpCfhw4Clvy+ziVn6qq4XkzbNOTnp5RHdOQXN9hSsaDU4MgB20wJXXn1yrgVaE1aGLQjjcKpOXwBlg87PxPLlps+N/lqC4SBgcB6tznNIAjn6bxJY3y73cZk9XYJH/Ny8HecMypO/4Anber3ve/l8kjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816353; c=relaxed/simple;
	bh=+1DSZlIiG2/wyojfSA+l+pilcDzbV/JVepNef0J8Q1k=;
	h=Date:To:From:Subject:Message-Id; b=N51oMFOkge9eNy/Tt3VtkuCZrjsfx90tMFN/d+OZ3L3knRko8WCtFfHS+5IzuqcfKem3+axBBbldOSwASaJb6rDuCHH6GdxcxWm26dTgBIQ8lMSQI5UxgXlwhBg3G+nkxHXfVIUUO2NADp5m2LXVUTgZo9zRXOucEmXvPMsMA54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h6BlWive; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h6BlWive"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E1B1F00A3A;
	Tue,  4 Aug 2026 04:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816352;
	bh=08VQs79wF93qEB7k1xMoliMKwn01pnvIwZ+o5sjVUg4=;
	h=Date:To:From:Subject;
	b=h6BlWiveCWk0ehu5BdGF/4SVt22Cm364hmpKOjqXKLVQ+hT++kICq/Ap0bK38ZaD0
	 6hzEKiJG3l2tqJtiaCe3LJ1qzH5BCEEX14v+8PYMAGcJSN8Qyaxn7O18+fr4t0LP8q
	 D1RZMMFoL6z0oRh0O0XGIcaTdFh2ZabKJohuF2xI=
Date: Mon, 03 Aug 2026 21:05:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch removed from -mm tree
Message-Id: <20260804040552.81E1B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cluster: fix o2hb_dependent_users leak on pin failure
Date: Wed, 22 Jul 2026 20:49:33 +0800

In o2hb_region_inc_user(), o2hb_dependent_users is incremented
unconditionally before calling o2hb_region_pin().  If the pin fails, the
counter is never decremented and any partially-pinned regions are never
unpinned, since the caller does not call o2hb_region_dec_user() on error.

The leaked counter causes subsequent o2hb_region_inc_user() calls to skip
pinning entirely (the > 1 check), leaving heartbeat regions unprotected.

Fix by rolling back on failure: call o2hb_region_unpin(NULL) to release
any partially-pinned regions and decrement o2hb_dependent_users to restore
the pre-increment state.

Link: https://lore.kernel.org/20260722124933.430554-4-joseph.qi@linux.alibaba.com
Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -2499,8 +2499,13 @@ static int o2hb_region_inc_user(const ch
 		goto unlock;
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
-			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
+			  O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF) {
 		ret = o2hb_region_pin(NULL, false);
+		if (ret) {
+			o2hb_region_unpin(NULL);
+			o2hb_dependent_users--;
+		}
+	}
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


