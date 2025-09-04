Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CBB2EBDF9
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 22:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757026031; cv=none; b=TS9SKYlxKlFQZs2M8/GRG6syKv6uEQbD04G/4RNI+MitbhAmUPifTNGg+0NGm61OlhSLnz+jTwd2+pLIJyGuXHV+13WAgfQxbf0To9sun9JyyY6140n8a59TrtR43fLvb2CcpHV7lIBWRGp3I8jWcb9DLne5jhQz7kglx1CXPmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757026031; c=relaxed/simple;
	bh=ki2uIgPtIz3d+WmTbUz1744YV5DnEi2VMokLdw6SwlM=;
	h=Date:To:From:Subject:Message-Id; b=OyJtKzpvx8FUF62CwK7gc9OgesZjdfxAHnC/tRuTfp9cmnsCNM5n0KJbgQCi+41PPBZSuJJXKSejFcEM0tyfBW63XCQLdehTXxK1CJAJ3ADN5REVsMMb3Gjx9KswbyymVSCfDEggxsZNNBp5n1TnnBvuEnXCpio3jyzfaFgnDvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qBVMMvHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qBVMMvHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF6AC4CEF0;
	Thu,  4 Sep 2025 22:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757026031;
	bh=ki2uIgPtIz3d+WmTbUz1744YV5DnEi2VMokLdw6SwlM=;
	h=Date:To:From:Subject:From;
	b=qBVMMvHMqUQSc2y7V6sv/UM8fY8x9jJqelxu3cc5QE7FOtvlAN61rwJGkVVdNDnO8
	 xErDgwEG2WwB1N3HETjOcn+uL7xW4iGrrsCHpFZ2mkDOuTzQ5uNBgPY8t6r0Vi32DM
	 hJ8ekg8ERVgw+OpGrhR4sz2oeT5Axqk4R2pnrvLA=
Date: Thu, 04 Sep 2025 15:47:10 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,pmladek@suse.com,lkp@intel.com,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-remove-redundant-panic-cpu-backtrace-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250904224711.6FF6AC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic-remove-redundant-panic-cpu-backtrace-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-remove-redundant-panic-cpu-backtrace-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-remove-redundant-panic-cpu-backtrace-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch

