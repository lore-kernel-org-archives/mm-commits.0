Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D39938DEF
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597091; cv=none; b=DK4TLhuwDtWNxQl6AMmlZiyJ7E6tZsbkqA62etcMzZxQ35/OQgw0Qx/fjibmY+VqWnI5FLX7Yva97/eyf/PY4+iytHlKHyhIqB9EvXBQEI9i3uGr2zTooPMmxL6W92Mfu/Ushx180W2Q2bJWodQkxtYbByDT42IjTE2VymRD0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597091; c=relaxed/simple;
	bh=OXPnK0HyMzVVkENXbuLF+q1Uitv8sxhevVX1Mb9cLqk=;
	h=Date:To:From:Subject:Message-Id; b=Z8aG96AStZhHtSyi1gu7hhA0Cnq1YHe7k7Yx8UkXXqmwwaBG7FgKVpEvtg+GRgFDTNqnRqjf+ku5jxMDiFjZW5q99zH0o0XAkFeMWmJ5CfqWZKHYS2xyDFS64oxx1H25eUewu0td6x9uhKEOCOBLvRI9mAQJIkePquMg8yzSpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JHj+wBKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JHj+wBKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A155CC433F1;
	Tue, 30 Jan 2024 06:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597091;
	bh=OXPnK0HyMzVVkENXbuLF+q1Uitv8sxhevVX1Mb9cLqk=;
	h=Date:To:From:Subject:From;
	b=JHj+wBKA+WqkaoB3Pa6UUgPIaMLcn/pZK8tssNdDAW/rBF86I5ZjZgSbrQ/nofmIg
	 9VMIkXT1UPvjB6DqzuqEhIXPACEh1Bs/v3PgHJ422RaAi6PTgYqttgKg/dx8496m9N
	 yOryNwlno115KBm4ErM5DHkwZ8JXWZ++OpPNZtcY=
Date: Mon, 29 Jan 2024 22:44:36 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-implement-deprecation-notice-file.patch added to mm-unstable branch
Message-Id: <20240130064448.A155CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/dbgfs: implement deprecation notice file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-implement-deprecation-notice-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-implement-deprecation-notice-file.patch

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
Subject: mm/damon/dbgfs: implement deprecation notice file
Date: Mon, 29 Jan 2024 17:35:42 -0800

Implement a read-only file for DAMON debugfs interface deprecation notice,
to let users who manually read/write the DAMON debugfs files from their
shell command line easily notice the fact.

Link: https://lkml.kernel.org/r/20240130013549.89538-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-implement-deprecation-notice-file
+++ a/mm/damon/dbgfs.c
@@ -805,6 +805,18 @@ static void dbgfs_destroy_ctx(struct dam
 	damon_destroy_ctx(ctx);
 }
 
+static ssize_t damon_dbgfs_deprecated_read(struct file *file,
+		char __user *buf, size_t count, loff_t *ppos)
+{
+	char kbuf[512] = "DAMON debugfs interface is deprecated, "
+		     "so users should move to DAMON_SYSFS. If you cannot, "
+		     "please report your usecase to damon@lists.linux.dev and "
+		     "linux-mm@kvack.org.\n";
+	int len = strnlen(kbuf, 1024);
+
+	return simple_read_from_buffer(buf, count, ppos, kbuf, len);
+}
+
 /*
  * Make a context of @name and create a debugfs directory for it.
  *
@@ -1056,6 +1068,10 @@ static int damon_dbgfs_static_file_open(
 	return nonseekable_open(inode, file);
 }
 
+static const struct file_operations deprecated_fops = {
+	.read = damon_dbgfs_deprecated_read,
+};
+
 static const struct file_operations mk_contexts_fops = {
 	.open = damon_dbgfs_static_file_open,
 	.write = dbgfs_mk_context_write,
@@ -1076,9 +1092,9 @@ static int __init __damon_dbgfs_init(voi
 {
 	struct dentry *dbgfs_root;
 	const char * const file_names[] = {"mk_contexts", "rm_contexts",
-		"monitor_on"};
+		"monitor_on", "DEPRECATED"};
 	const struct file_operations *fops[] = {&mk_contexts_fops,
-		&rm_contexts_fops, &monitor_on_fops};
+		&rm_contexts_fops, &monitor_on_fops, &deprecated_fops};
 	int i;
 
 	dbgfs_root = debugfs_create_dir("damon", NULL);
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

