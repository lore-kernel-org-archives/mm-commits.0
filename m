Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FF33A1BC
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559012; cv=none; b=HXHybkJfeVd1WbAk/ZIz/ugesxLS3Xdv4nslvJn8NV2PFjx7HqO/tbYi9xvzNW/9trXfNC0hFLsAfbdsiA1qbfbVJEbgBhx/TgMfOzRQTTikgxltAuM025zcIUmB0/N2b1zKcFL1k6ZbVlijic+rVCG20ezqDKtixakcfOkTKZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559012; c=relaxed/simple;
	bh=swSoiX5EPgT/Z5wAOHI+J0qVy1HYqC1iFWz5OCc5tDI=;
	h=Date:To:From:Subject:Message-Id; b=mxf/c4dvovmAzo8YuwlagqMqziqilHwxa6rBezwkC/NAmgSVtdhOxiDTJiM++lbnSOOHuREGU9lQdUyOcPPmfZqjxSVmmuR6TBUiAVbFx7z61X5zUOdYJJ0iK/7RPFLyC+s+0R4fh7HaOgKll/+jhS8CM5iCP0rFVzCNrjvnazs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rpcVwPrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rpcVwPrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE547C433F1;
	Wed, 21 Feb 2024 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559012;
	bh=swSoiX5EPgT/Z5wAOHI+J0qVy1HYqC1iFWz5OCc5tDI=;
	h=Date:To:From:Subject:From;
	b=rpcVwPrhppDt6epqqn/w1dCbFhDwa4ZlVyZGsFl1aoLEM/Ou4SuOlEUxGlGw5iLkk
	 ZvUlEaqbNc4KTn5xyD+80MHby68v1os8wSbuW5QFu/5nn2fFo4ZlJB7Vw251H+3BQk
	 8JlRI3sDaTL38JGdhFwRT3nyruoFf64nIBKPgHZQ=
Date: Wed, 21 Feb 2024 15:43:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch removed from -mm tree
Message-Id: <20240221234331.EE547C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch

This patch was dropped because it was folded into mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
Date: Sat Feb  3 06:10:51 AM PST 2024

s/comnst/const/

Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix
+++ a/mm/damon/dbgfs.c
@@ -810,7 +810,7 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	static comnst char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
+	static const char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
 
 	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

