Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D2EEBD
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757809026; cv=none; b=szuEwDjth2ASPN3Ac4RTNecWAgFkfJgtjNncE3kiDgV8EE353TK6a5DqggajmevPji6CKY/SwuhJGfCGz95U8rLtiKufYFhuGHjHb70LHviWoFtpsCi5qHaEQYP9KF1qxLDfUCYce/Fyo6Nam7bMgHthOInkiM2NSfVC37gQ4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757809026; c=relaxed/simple;
	bh=3b1KJhTlWfdl95mltY2ARSsGvzjkFOJGo8eFga4fi6U=;
	h=Date:To:From:Subject:Message-Id; b=Cyh1aim0mVWUIYodakVMXXzOReSFUtV12+MVnZH6wG/8dqgREZqpfFimarlSBKUnJ39OVQ0FehtTdGKssmey4SRqlImGCHeVMrA2MidamXsrKwX/PEXyJii8OWd4g/aR+qZdFRFAJ/Ksg5Mca5nW12+HHE/mb741cTDmM2sYaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mQhm45Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mQhm45Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E82FC4CEEB;
	Sun, 14 Sep 2025 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757809026;
	bh=3b1KJhTlWfdl95mltY2ARSsGvzjkFOJGo8eFga4fi6U=;
	h=Date:To:From:Subject:From;
	b=mQhm45TrooicoGesv5/Jjuj00rgmghEm93zv3zKXprw1XE65oGRHsdqtXv2A8Pb10
	 XabYKRBtJ7nFfZf8H5p7MHlwdLAV+fGK8ZwxE9Gyx2pcJ3Fi2RGS9dAFXLB0qrmVcc
	 eSq8OKzv1cUGywYon0Xa2BZLIxZlZtIFSSsRExtA=
Date: Sat, 13 Sep 2025 17:17:05 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,pmladek@suse.com,lkp@intel.com,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] panic-remove-redundant-panic-cpu-backtrace-fix.patch removed from -mm tree
Message-Id: <20250914001706.1E82FC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic-remove-redundant-panic-cpu-backtrace-fix
has been removed from the -mm tree.  Its filename was
     panic-remove-redundant-panic-cpu-backtrace-fix.patch

This patch was dropped because it was folded into panic-remove-redundant-panic-cpu-backtrace.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-remove-redundant-panic-cpu-backtrace-fix
Date: Thu Sep  4 03:46:17 PM PDT 2025

make panic_this_cpu_backtrace_printed static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509050048.FMpVvh1u-lkp@intel.com/
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/panic.c~panic-remove-redundant-panic-cpu-backtrace-fix
+++ a/kernel/panic.c
@@ -67,7 +67,7 @@ static unsigned int warn_limit __read_mo
 static bool panic_console_replay;
 
 bool panic_triggering_all_cpu_backtrace;
-bool panic_this_cpu_backtrace_printed;
+static bool panic_this_cpu_backtrace_printed;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
panic-remove-redundant-panic-cpu-backtrace.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

