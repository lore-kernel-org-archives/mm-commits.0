Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7884184
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 00:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754092831; cv=none; b=Ld59YbPmkxas8Nk3L+4xzgNbG1dj9DJN6gGEBHfvUOahDYOUC4GowpBWcaH9m6gI7HLcOhRTKcN3GxDvqJiqPihI1l7v2+1bHg/o27aIM0my72xD0imWT9yqljcg2crjLoQiXS1RJs4Cl1WaESN8DvxGrBxhAlZXpPkcw+WgrXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754092831; c=relaxed/simple;
	bh=bNX5AE8YnLgVpHYzAlN41pDxBuu41YSG2FaTPPs5E7E=;
	h=Date:To:From:Subject:Message-Id; b=r0d957uJ8ccAHh17SuDUt7dGJ270pfox3c9z+jGHLKzF2lHgP4YPv4DUWCmA26+bacL52dYy3Oe5anD/Nb4eFkmVQzLhffIuiwEGgEgTrLYF0JDArxt9moFtlYsH9ftuwHyeYoH7EAJ1Xqo2ZbSnwdQoFVcM1EF1X6lQry7ij9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DdVbHwxZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DdVbHwxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9599CC4CEE7;
	Sat,  2 Aug 2025 00:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754092830;
	bh=bNX5AE8YnLgVpHYzAlN41pDxBuu41YSG2FaTPPs5E7E=;
	h=Date:To:From:Subject:From;
	b=DdVbHwxZtGGJXIgQHveipiltLxKRED0PEvmiT6tqptvr+ujgwd2lIU5ZYf5uxNq80
	 rb9aQ89BMWU7x3pR5dpjc3wKXT2nyPMU/fu693eIR7H+SDIllabPeDR2YUZAc8n8Xu
	 Rm+1pWzbLMGb/d/9Mc1KOg2Hsl0l5hQcQB1e+9dU=
Date: Fri, 01 Aug 2025 17:00:30 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,lujialin4@huawei.com,longman@redhat.com,leitao@debian.org,john.ogness@linutronix.de,gubowen5@huawei.com,catalin.marinas@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-possible-deadlock-in-console_trylock_spinning-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250802000030.9599CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kmemleak.c needs kernel/printk/internal.h
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-possible-deadlock-in-console_trylock_spinning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-possible-deadlock-in-console_trylock_spinning-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: kmemleak.c needs kernel/printk/internal.h
Date: Fri Aug  1 04:45:45 PM PDT 2025

seems wrong

Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Gu Bowen <gubowen5@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kmemleak.c~mm-fix-possible-deadlock-in-console_trylock_spinning-fix
+++ a/mm/kmemleak.c
@@ -103,6 +103,8 @@
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
 
+#include "../kernel/printk/internal.h"		/* __printk_safe_enter */
+
 /*
  * Kmemleak configuration and common defines.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-possible-deadlock-in-console_trylock_spinning-fix.patch
selftests-cachestat-add-tests-for-mmap-refactor-and-enhance-mmap-test-for-cachestat-validation-checkpatch-fixes.patch
mm-remove-mm-io-mappingc-fix.patch
init-kconfig-restore-config_broken-help-text.patch

