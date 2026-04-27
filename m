Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0E43BAD89;
	Mon, 27 Apr 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294518; cv=none; b=sAmufvZrrqZwhvA27yRxwZ4s2fgmBQXqxe3LTR+lMgDmUyM531WYYLYYLZFB/171UF31NKpGewzoRrtRc2HrhRTMxZPIkvrn1kW+bEsbFo0mMkAQLbvEKjluHdlYFFa2pm5OIfSPqSmZHvtuHz98WFMyoGbW9+G7PLDFeAlI5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294518; c=relaxed/simple;
	bh=3n0DybhkH3Qj2l+bOmqurTXypgpNhSz77HdXoR7+YWw=;
	h=Date:To:From:Subject:Message-Id; b=W+1lbyATjmlSHUsuy3SbCyYmLEhvHsfNzmYroUxq4oj3+SsdOfk/K/WgbWl4dsok9x4E7jvIPLZKrTyP0xOhpevWBjkpUFe0nyq4iz5/1Ty+4UWrpo+KJW6OFP8I/mH5s1A5MbGItOsY9PNQkuY3SqA2EC6lQKVFpARn/u1/zqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L87djBdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L87djBdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95CAC19425;
	Mon, 27 Apr 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294517;
	bh=3n0DybhkH3Qj2l+bOmqurTXypgpNhSz77HdXoR7+YWw=;
	h=Date:To:From:Subject:From;
	b=L87djBdd9nol9VCPoiEBmTxYFgg0NzQJPpAcCBT/FVlX806jHiwxnOojNt3LwN1H/
	 WNjSdDruZ3Z/roz2HL6V7oF/8qC+xFaW07flxqPWWCcZouCTMB+natYxFkP0ab9C9v
	 0x1HKcRQwdb3oB2KDa2f9Ynn7I1tjCJtIzFMQXhA=
Date: Mon, 27 Apr 2026 05:55:17 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,qjx1298677004@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch removed from -mm tree
Message-Id: <20260427125517.A95CAC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
Date: Thu, 23 Apr 2026 08:02:52 -0700

damon_sysfs_quot_goal->path can be read and written by users, via DAMON
sysfs 'path' file.  It can also be indirectly read, for the parameters
{on,off}line committing to DAMON.  The reads for parameters committing are
protected by damon_sysfs_lock to avoid the sysfs files being destroyed
while any of the parameters are being read.  But the user-driven direct
reads and writes are not protected by any lock, while the write is
deallocating the path-pointing buffer.  As a result, the readers could
read the already freed buffer (user-after-free).  Note that the user-reads
don't race when the same open file is used by the writer, due to kernfs's
open file locking.  Nonetheless, doing the reads and writes with separate
open files would be common.  Fix it by protecting both the user-direct
reads and writes with damon_sysfs_lock.

Link: https://lore.kernel.org/20260423150253.111520-3-sj@kernel.org
Fixes: c41e253a411e ("mm/damon/sysfs-schemes: implement path file under quota goal directory")
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock
+++ a/mm/damon/sysfs-schemes.c
@@ -1197,8 +1197,13 @@ static ssize_t path_show(struct kobject
 {
 	struct damos_sysfs_quota_goal *goal = container_of(kobj,
 			struct damos_sysfs_quota_goal, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n", goal->path ? goal->path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t path_store(struct kobject *kobj,
@@ -1213,8 +1218,13 @@ static ssize_t path_store(struct kobject
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(goal->path);
 	goal->path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

