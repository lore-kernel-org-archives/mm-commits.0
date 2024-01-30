Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3FE524B1
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597134; cv=none; b=GA69k1Tf8s/WUU4IRm1Wp0NZu1z22RrknTrYbao4trFyjwzw+YSxV+476CuHdxSruG/1FvLpjdE7UWqQORaRsmCdmEYNSamHjbKRN5g5Pg2Z8ecr7oO4ARE2PRU6m4oocDdEJA+jgFtV/4/t8t7PAu388W5EjAoQFiQhziDOAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597134; c=relaxed/simple;
	bh=Ht+y05I+LRnGUSUlka3H4EOz5bBjPKL0/wjM9ZSoh3o=;
	h=Date:To:From:Subject:Message-Id; b=m6KxYQ5iaPohP+AXDaVfLbrbvkpfdrAYqonNPKB+g7vM7VzweyKjekIoCRMRcX5hAe0wJ/KhIJk28kjU7SlwLsNYy8YSeP477JJ/b09Ktbv5cujwY9/eWlpQkNyPuVpw7Kkyh/5uQScXkVMimClywrBmxDlZtdbRCjKkC59v8X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jq7ciAXl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jq7ciAXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F532C43390;
	Tue, 30 Jan 2024 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597134;
	bh=Ht+y05I+LRnGUSUlka3H4EOz5bBjPKL0/wjM9ZSoh3o=;
	h=Date:To:From:Subject:From;
	b=jq7ciAXltJXL+yLafanrmW4DcG74PhVcpX/iB1HEjxGucLKiZziDBzNvyquESxw/1
	 RgsopTAqgWOBlzO4aOil8MkffIMk4tb55vdIWNBGtJE9NwHPBry+mEyqjW3i/hQy8L
	 rd79gSqvzABsfoIjVAeKuhP5jY+6abCVrH17wECY=
Date: Mon, 29 Jan 2024 22:45:20 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch added to mm-unstable branch
Message-Id: <20240130064533.0F532C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/dbgfs: make debugfs interface deprecation message a macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: make debugfs interface deprecation message a macro
Date: Mon, 29 Jan 2024 17:35:43 -0800

DAMON debugfs interface deprecation message is written twice, once for the
warning, and again for DEPRECATED file's read output.  De-duplicate those
by defining the message as a macro and reuse.

Link: https://lkml.kernel.org/r/20240130013549.89538-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro
+++ a/mm/damon/dbgfs.c
@@ -15,6 +15,11 @@
 #include <linux/page_idle.h>
 #include <linux/slab.h>
 
+#define DAMON_DBGFS_DEPRECATION_NOTICE					\
+	"DAMON debugfs interface is deprecated, so users should move "	\
+	"to DAMON_SYSFS. If you cannot, please report your usecase to "	\
+	"damon@lists.linux.dev and linux-mm@kvack.org.\n"
+
 static struct damon_ctx **dbgfs_ctxs;
 static int dbgfs_nr_ctxs;
 static struct dentry **dbgfs_dirs;
@@ -22,10 +27,7 @@ static DEFINE_MUTEX(damon_dbgfs_lock);
 
 static void damon_dbgfs_warn_deprecation(void)
 {
-	pr_warn_once("DAMON debugfs interface is deprecated, "
-		     "so users should move to DAMON_SYSFS. If you cannot, "
-		     "please report your usecase to damon@lists.linux.dev and "
-		     "linux-mm@kvack.org.\n");
+	pr_warn_once(DAMON_DBGFS_DEPRECATION_NOTICE);
 }
 
 /*
@@ -808,10 +810,7 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	char kbuf[512] = "DAMON debugfs interface is deprecated, "
-		     "so users should move to DAMON_SYSFS. If you cannot, "
-		     "please report your usecase to damon@lists.linux.dev and "
-		     "linux-mm@kvack.org.\n";
+	char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
 	int len = strnlen(kbuf, 1024);
 
 	return simple_read_from_buffer(buf, count, ppos, kbuf, len);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch

