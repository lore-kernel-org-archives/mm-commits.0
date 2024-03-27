Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF01C32189
	for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2024 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711564829; cv=none; b=ChGImymrQ9nrEP/5fihwEmruBDuSMNvL8v7tdW7kYTSdnW+hyRBkViE3sPkjdGxc0ohT/qLINPGODMYpbgf15Fpmf0d2rJQl67jHxnUPo2EMSQezLKwh8soUpSuMPoVw87MmV9Ob7p5QFF0Ea/0W5A7BnVUeCDRJL6rqmTrd27w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711564829; c=relaxed/simple;
	bh=aGQ92dSiWurzWoRPBim9AbC2cqkK8bzzJbHzRIufpwQ=;
	h=Date:To:From:Subject:Message-Id; b=Lu6G8VN96QVNicR9KmJRiczyicZ2pV+Ja8EX3F6Di5XqgozVlsgZx9sSD8pKsVik7e/Wvp6r/FddYTB4zJ4nqFQ2wnsAG5ANOXC5NoU3DamWSyuJAKa2qsJ4619xzdaQqVTgf6hADOw2uYC7qWxdc6dvFJBCgNiFj2kSGCGWzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MheLjxOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MheLjxOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C23C433C7;
	Wed, 27 Mar 2024 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711564829;
	bh=aGQ92dSiWurzWoRPBim9AbC2cqkK8bzzJbHzRIufpwQ=;
	h=Date:To:From:Subject:From;
	b=MheLjxODHuqyl3EUJlemnDn53oIZAWGd2ZL8S4ImxHocwAHxiutPhYI03XJwdlKNf
	 xZyHy0rdVupi8Ti17XhTJUXODDRguxpQq0s0fBjpTj/QnbCFJUke+gbwid3kQ74l/h
	 uWeyptflHGxmiwyobVnw3qwwWxyo/vlos4Ijc2DY=
Date: Wed, 27 Mar 2024 11:40:29 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-protect-race-between-bdi-release-and-bdi_debug_stats_show.patch added to mm-unstable branch
Message-Id: <20240327184029.81C23C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback: protect race between bdi release and bdi_debug_stats_show
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-protect-race-between-bdi-release-and-bdi_debug_stats_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-protect-race-between-bdi-release-and-bdi_debug_stats_show.patch

This patch will later appear in the mm-unstable branch at
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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: writeback: protect race between bdi release and bdi_debug_stats_show
Date: Wed, 27 Mar 2024 23:57:46 +0800

There is a race between bdi release and bdi_debug_stats_show:
/* get debug info */		/* bdi release */
bdi_debug_stats_show
  bdi = m->private;
  wb = &bdi->wb;
				bdi_unregister
				bdi_put
				  release_bdi
				    kfree(bdi)
  /* use after free */
  spin_lock(&wb->list_lock);

Search bdi on bdi_list under rcu lock in bdi_debug_stats_show to ensure
the bdi is not freed to fix the issue.

Link: https://lkml.kernel.org/r/20240327155751.3536-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/mm/backing-dev.c~writeback-protect-race-between-bdi-release-and-bdi_debug_stats_show
+++ a/mm/backing-dev.c
@@ -46,16 +46,44 @@ static void bdi_debug_init(void)
 	bdi_debug_root = debugfs_create_dir("bdi", NULL);
 }
 
-static int bdi_debug_stats_show(struct seq_file *m, void *v)
+static struct backing_dev_info *lookup_bdi(struct seq_file *m)
 {
+	const struct file *file = m->file;
 	struct backing_dev_info *bdi = m->private;
-	struct bdi_writeback *wb = &bdi->wb;
+	struct backing_dev_info *exist;
+
+	list_for_each_entry_rcu(exist, &bdi_list, bdi_list) {
+		if (exist != bdi)
+			continue;
+
+		if (exist->debug_dir == file->f_path.dentry->d_parent)
+			return bdi;
+		else
+			return NULL;
+	}
+
+	return NULL;
+}
+
+
+static int bdi_debug_stats_show(struct seq_file *m, void *v)
+{
+	struct backing_dev_info *bdi;
+	struct bdi_writeback *wb;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long wb_thresh;
 	unsigned long nr_dirty, nr_io, nr_more_io, nr_dirty_time;
 	struct inode *inode;
 
+	rcu_read_lock();
+	bdi = lookup_bdi(m);
+	if (!bdi) {
+		rcu_read_unlock();
+		return -EEXIST;
+	}
+
+	wb = &bdi->wb;
 	nr_dirty = nr_io = nr_more_io = nr_dirty_time = 0;
 	spin_lock(&wb->list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_io_list)
@@ -101,6 +129,7 @@ static int bdi_debug_stats_show(struct s
 		   nr_dirty_time,
 		   !list_empty(&bdi->bdi_list), bdi->wb.state);
 
+	rcu_read_unlock();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(bdi_debug_stats);
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

writeback-protect-race-between-bdi-release-and-bdi_debug_stats_show.patch
writeback-collect-stats-of-all-wb-of-bdi-in-bdi_debug_stats_show.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi.patch
writeback-add-wb_monitorpy-script-to-monitor-writeback-info-on-bdi.patch
writeback-rename-nr_reclaimable-to-nr_dirty-in-balance_dirty_pages.patch
writeback-define-gdtc_init_no_wb-to-null.patch

