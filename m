Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774E67081C
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620120; cv=none; b=MLM1K05ous/dew6lZFa9qbkQJPxKkyfrgLjHIsX5u+ITaVEA1pAiXOjX0Svl3kENBMAz7jqKHMhKZXAbwq/Zn/lljXWOlMSfqXEzxEG/S7oxbdgipx0rP/Z49bvODIlf05DupK2NuBgajUovPUB2xhKZ4JpgaYojsHx9Qj+o0m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620120; c=relaxed/simple;
	bh=KAce/0zxpFlAi3KBND1ubiclKZplwPtzmM6j6C6Y6ho=;
	h=Date:To:From:Subject:Message-Id; b=b4APTySznuhqE7JO8WlLbv29i6HRd5RlJLvvqrWx3hHykgueTLGlLb00zXLjFnqjTOnshn4kYF9xJG5kjIvLU1bN8XNInpY2MTCUDyLczZlSia3/vcajaOSxpNLpEOUGlaRR/NF9AHFqdxGcwSwFAzRkVaPnAQwpDIZSoeZhBlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YW3tSciO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YW3tSciO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43086C4CEDD;
	Sat, 22 Mar 2025 05:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620120;
	bh=KAce/0zxpFlAi3KBND1ubiclKZplwPtzmM6j6C6Y6ho=;
	h=Date:To:From:Subject:From;
	b=YW3tSciOhWRQ2MwFM+3niaMTmeRRdtPo+fhtwxPSDfmHB6jXFBT6JFbg32PNSCkWg
	 U/t9F8XK3IgFGw0Q7IRmIHQ3Yd3N5CEDwBmKLPLyBUy0vhm0U/xLb0vLV2Flmu7xFO
	 sxZJLrEWHDtuaXOlnfL87MdXfPBJiV81Z3T2wkac=
Date: Fri, 21 Mar 2025 22:08:39 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,lkp@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] samples-add-hung_task-detector-mutex-blocking-sample-fix.patch removed from -mm tree
Message-Id: <20250322050840.43086C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
has been removed from the -mm tree.  Its filename was
     samples-add-hung_task-detector-mutex-blocking-sample-fix.patch

This patch was dropped because it was folded into samples-add-hung_task-detector-mutex-blocking-sample.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: samples-add-hung_task-detector-mutex-blocking-sample-fix
Date: Mon Mar 17 07:53:34 PM PDT 2025

make `hung_task_dir' static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202503180827.4StpuFrD-lkp@intel.com/
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/hung_task/Makefile          |    2 +-
 samples/hung_task/hung_task_mutex.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/samples/hung_task/hung_task_mutex.c~samples-add-hung_task-detector-mutex-blocking-sample-fix
+++ a/samples/hung_task/hung_task_mutex.c
@@ -22,7 +22,7 @@
 
 static const char dummy_string[] = "This is a dummy string.";
 static DEFINE_MUTEX(dummy_mutex);
-struct dentry *hung_task_dir;
+static struct dentry *hung_task_dir;
 
 static ssize_t read_dummy(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
--- a/samples/hung_task/Makefile~samples-add-hung_task-detector-mutex-blocking-sample-fix
+++ a/samples/hung_task/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
\ No newline at end of file
+obj-$(CONFIG_SAMPLE_HUNG_TASK) += hung_task_mutex.o
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
samples-add-hung_task-detector-mutex-blocking-sample.patch

