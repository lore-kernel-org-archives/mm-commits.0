Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79853BA239;
	Mon, 27 Apr 2026 12:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294517; cv=none; b=GsgC1tMY5zu4kp3tTEXJoJp98LU1ZyoOU4ZiNCqhZZdcz6Mhmx8Kcp0rKrVmMLJKy95ypga9U9lKjxTB8k2ryzYKIGchv28/T8Kqp2OpzUup4EnJrvIE3hhFB0eR3icxllpHZvUXOABq/B1HnpgkTuFBjYcNcff/BVhkeMKe5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294517; c=relaxed/simple;
	bh=jfm1vylwLQKdCt6oL4txjLvqFkOb0ycHxkGCvgPC8Pc=;
	h=Date:To:From:Subject:Message-Id; b=KAHtzWxPYfiKzWPtWIgs0l0p+qhEg1o5igY9XENgEBm5F7H5jai6Q1Y8IJcHkx8bA0DlhjLqCwnwJGZ4udHV3gtBUf1nyR6IYvdSr6GeEfEyUvUMbQKGCC9z+6ensZ61nl97rRymFJfcZrOS0ESw1r63B3XEwXcpk0L4ydcYTVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMJvlxav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMJvlxav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B022C19425;
	Mon, 27 Apr 2026 12:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294516;
	bh=jfm1vylwLQKdCt6oL4txjLvqFkOb0ycHxkGCvgPC8Pc=;
	h=Date:To:From:Subject:From;
	b=IMJvlxavfLS1QyY9fupuohyRBjSbHZxr/LzN0D3JlgUYwEQjFtetNTESA03ObEvPb
	 Ui2rEoH87U4xYyylUMAupST93A1NWrVk0J3oT/7R6ksuAPhJJd2EUNV4dQZMLrEsz4
	 8KuRPhWhMh1j+utdavC+BD3M8XXIcQdoeBR7dVCM=
Date: Mon, 27 Apr 2026 05:55:15 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,qjx1298677004@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch removed from -mm tree
Message-Id: <20260427125516.7B022C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: protect memcg_path kfree() with damon_sysfs_lock
Date: Thu, 23 Apr 2026 08:02:51 -0700

Patch series "mm/damon/sysfs-schemes: fix use-after-free for [memcg_]path".

Reads of 'memcg_path' and 'path' files in DAMON sysfs interface could race
with their writes, results in use-after-free.  Fix those.


This patch (of 2):

damon_sysfs_scheme_filter->mmecg_path can be read and written by users,
via DAMON sysfs memcg_path file.  It can also be indirectly read, for the
parameters {on,off}line committing to DAMON.  The reads for parameters
committing are protected by damon_sysfs_lock to avoid the sysfs files
being destroyed while any of the parameters are being read.  But the
user-driven direct reads and writes are not protected by any lock, while
the write is deallocating the memcg_path-pointing buffer.  As a result,
the readers could read the already freed buffer (user-after-free).  Note
that the user-reads don't race when the same open file is used by the
writer, due to kernfs's open file locking.  Nonetheless, doing the reads
and writes with separate open files would be common.  Fix it by protecting
both the user-direct reads and writes with damon_sysfs_lock.

Link: https://lore.kernel.org/20260423150253.111520-1-sj@kernel.org
Link: https://lore.kernel.org/20260423150253.111520-2-sj@kernel.org
Fixes: 4f489fe6afb3 ("mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write")
Co-developed-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: Junxi Qian <qjx1298677004@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock
+++ a/mm/damon/sysfs-schemes.c
@@ -533,9 +533,14 @@ static ssize_t memcg_path_show(struct ko
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
+	int len;
 
-	return sysfs_emit(buf, "%s\n",
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	len = sysfs_emit(buf, "%s\n",
 			filter->memcg_path ? filter->memcg_path : "");
+	mutex_unlock(&damon_sysfs_lock);
+	return len;
 }
 
 static ssize_t memcg_path_store(struct kobject *kobj,
@@ -550,8 +555,13 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	if (!mutex_trylock(&damon_sysfs_lock)) {
+		kfree(path);
+		return -EBUSY;
+	}
 	kfree(filter->memcg_path);
 	filter->memcg_path = path;
+	mutex_unlock(&damon_sysfs_lock);
 	return count;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

