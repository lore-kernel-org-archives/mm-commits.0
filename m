Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA78C38FBA
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597150; cv=none; b=DtD/rUcc/IFo1frnY7VSEK9OSzbkUQklxGcVdvUGei2L9RBu63RC5Pd6g1DLES1ow0S2XCnxxBIhrHzyJR+rSyST7YDeuLbWLPnOS0zf2tOeM7aflihkm0J10O2Uaup9liitvJ/a/zY+RC2fEYsuGxrC9SkF1EM7YNz3B5EDhDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597150; c=relaxed/simple;
	bh=ooR2BKhdpHZP2bJCrET1Bvx1h+d5xQ1KkqW3NU8wVSg=;
	h=Date:To:From:Subject:Message-Id; b=L7eBN1liQxyxEzF4uX1ZQzLzmppCp5G2iEidPQJxKqiJAxkmcXUOIIecM6lQJeofFUTUiqXH3emX0CNAHIkZN7B3FSZkjUCXsM0VDJvnoSs7p4d09QmftRGkQ/HRaAC+igRwebtz/iF2mNEIuwEV4ckIb8fRkYOEU4xxKc4MCvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YIROTwTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YIROTwTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E51FC433F1;
	Tue, 30 Jan 2024 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597150;
	bh=ooR2BKhdpHZP2bJCrET1Bvx1h+d5xQ1KkqW3NU8wVSg=;
	h=Date:To:From:Subject:From;
	b=YIROTwTF2+Uhb2CMieYRb1gw7p3eMFEjFNrDcRNTFOHLbY+y4DBg4brrtH37GR732
	 nSzXZRPoChGndSWbFMI2mb3ASenhilcfF7wJwiDomcRGfokhJdfRfihGDQfwIpcEAh
	 0VKqkCNJF3LaRKSTRQRt8TYvU7XxUeRAGHlT0BB4=
Date: Mon, 29 Jan 2024 22:45:35 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch added to mm-unstable branch
Message-Id: <20240130064549.0E51FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/dbgfs: rename monitor_on file to monitor_on_DEPRECATED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch

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
Subject: mm/damon/dbgfs: rename monitor_on file to monitor_on_DEPRECATED
Date: Mon, 29 Jan 2024 17:35:46 -0800

Kernel builders could silently enable CONFIG_DAMON_DBGFS_DEPRECATED. 
Users who manually check the files under the DAMON debugfs directory could
notice the deprecation owing to the 'DEPRECATED' DAMON debugfs file, but
there could be users who doesn't manually check the files.

Make the deprecation cannot be ignored in the case by renaming
'monitor_on' file, which is essential for real use of DAMON on runtime, to
'monitor_on_DEPRECATED'.  Still users who control DAMON via only
user-space tool could ignore the deprecation, but that's what the tool
developers should take care of.  DAMON user-space tool, damo, has also
made a change[1] for the purpose.

[1] commit 935dae76f2aee ("_damon_args: Rename --damon_interface to
    --damon_interface_DEPRECATED") of https://github.com/awslabs/damo

Link: https://lkml.kernel.org/r/20240130013549.89538-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated
+++ a/mm/damon/dbgfs.c
@@ -1091,7 +1091,7 @@ static int __init __damon_dbgfs_init(voi
 {
 	struct dentry *dbgfs_root;
 	const char * const file_names[] = {"mk_contexts", "rm_contexts",
-		"monitor_on", "DEPRECATED"};
+		"monitor_on_DEPRECATED", "DEPRECATED"};
 	const struct file_operations *fops[] = {&mk_contexts_fops,
 		&rm_contexts_fops, &monitor_on_fops, &deprecated_fops};
 	int i;
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

