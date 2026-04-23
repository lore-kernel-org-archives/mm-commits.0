Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C5B36E49B;
	Thu, 23 Apr 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776960418; cv=none; b=ttlgGtH5FYrYPBsFBYSuzRmZSwOE5CqKv1BmbEtJToybi5IOtUKaawdF19OWUNKGdCAuu4S6Ze8vO4pBFlcVU+oF5wx2JwSccJfg1Ytj6k305YWhwBb65pl5wYUatDtVJKd3xJetpcZ/yQ6YffD+6ZuJxZIemVVlaATxS5ZrZhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776960418; c=relaxed/simple;
	bh=stz2NLjldn8SqYoLXEIcu77xRa/wpe+JC1JHj1VKKYQ=;
	h=Date:To:From:Subject:Message-Id; b=NmsLq7asWj7zexCp9LdsoByZXpaNsGtCf46qWxH0iazsTECspn0WdBTtpGC1M85YhEdkKtLTJQLB+oUfCcwHSqeupmVx5ghxF50edLzXHikcxgQuuyNbqiITlTVd9gv22VWRrQ6DH0yVujSM7+fLPUnsq4uv9N6J3TWvHNafnNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZsxv81z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZsxv81z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B73DC2BCAF;
	Thu, 23 Apr 2026 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776960418;
	bh=stz2NLjldn8SqYoLXEIcu77xRa/wpe+JC1JHj1VKKYQ=;
	h=Date:To:From:Subject:From;
	b=HZsxv81z/x9AUrsWlu+YGWv/K978djcKHHW1sb3tLd2OLwmX15K0Z4qdcnZ77Ad4Y
	 JgfYrXNB9WeTAbQ8uXCPmhERA4hFv6PJk9YsiVP9Eq6WE86xiTOXzljds8zY+A2f0R
	 8/p1/YSu5MXeZ2Q+DxWVQYDrdhJSSbFuPeshVu9k=
Date: Thu, 23 Apr 2026 09:06:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,qjx1298677004@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423160658.8B73DC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch
mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch

