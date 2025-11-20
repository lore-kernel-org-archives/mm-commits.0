Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A6A2FB96A
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676254; cv=none; b=LrmJ9GhgiKOuRzKT33qIv5t6joPnsiZRiXYMf91/cu2m+buGkN3wHRHi1zYmcD7GIzh3PzmsfVv/QoXezSipg8AlH/ViCvMFK3nj5vRnvugU1927t0mbbM7+v7gt2WJmPGkOFqHq+tfYaNSdisGo9QdbS8ZZ9/yAE8UVQEBOcuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676254; c=relaxed/simple;
	bh=VmPFxj5EUMpdKYzrgF0rraL40e6d/aRKcqRWU4CBdfo=;
	h=Date:To:From:Subject:Message-Id; b=CrPaExMZ/8PGiX0C7R2dWeSQYbH2jPTxCaHTxTvh8BPGAat/aMnm7GO9KqwwoXfQlxcnstcc1YMHTFtSONj8Q6rSCmEg5rJ2TalTfJj32G61ozd45osfdYcqslvjQx2DjLAWYTQV43lsXCRr8SISBfuNO/QEvZFhjebPdnYFZ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2KzZOGOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2KzZOGOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3554EC4CEF1;
	Thu, 20 Nov 2025 22:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676254;
	bh=VmPFxj5EUMpdKYzrgF0rraL40e6d/aRKcqRWU4CBdfo=;
	h=Date:To:From:Subject:From;
	b=2KzZOGOATnheeM0Gp4OuOtUR/PWN3E0gvQLt8Blbf5SouP00Xif5zgwl72lDcKKuc
	 ZzWHAfEGwxOZXlcLOVhO0Nlo2rf0GqEOGmCKsuoFU5WffjLKYGvCv8UYNUJviRDY5z
	 0llcNyKjzpkbOuT7tU54PLWxLZhYt8/Ju8SYhCCY=
Date: Thu, 20 Nov 2025 14:04:13 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,feng.tang@linux.alibaba.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] panic-sys_info-deduplicate-local-variable-table-assignments.patch removed from -mm tree
Message-Id: <20251120220414.3554EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: sys_info: deduplicate local variable 'table; assignments
has been removed from the -mm tree.  Its filename was
     panic-sys_info-deduplicate-local-variable-table-assignments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: panic: sys_info: deduplicate local variable 'table; assignments
Date: Thu, 30 Oct 2025 12:44:21 +0100

The both handlers use the local 'table' variable and assign the same data
to it, deduplicate that.

Link: https://lkml.kernel.org/r/20251030132007.3742368-6-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/lib/sys_info.c~panic-sys_info-deduplicate-local-variable-table-assignments
+++ a/lib/sys_info.c
@@ -63,12 +63,13 @@ int sysctl_sys_info_handler(const struct
 	if (!names)
 		return -ENOMEM;
 
+	table = *ro_table;
+	table.data = names;
+	table.maxlen = maxlen;
+
 	if (write) {
 		int ret;
 
-		table = *ro_table;
-		table.data = names;
-		table.maxlen = maxlen;
 		ret = proc_dostring(&table, write, buffer, lenp, ppos);
 		if (ret)
 			return ret;
@@ -93,9 +94,6 @@ int sysctl_sys_info_handler(const struct
 			}
 		}
 
-		table = *ro_table;
-		table.data = names;
-		table.maxlen = maxlen;
 		return proc_dostring(&table, write, buffer, lenp, ppos);
 	}
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


