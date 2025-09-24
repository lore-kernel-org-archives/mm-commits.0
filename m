Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B7E14658D
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758751272; cv=none; b=PYr8AhWccsVZ/25MeYu6YmjN9zfuuNlQth9WwZhZaYycyfZIsh7314HXkH2yH3h/V1pfHVO/CIXjKx174Xol7f+SKYMmV99042pu2xAOjA5uWzSrODxYLGt/zA0uOBdC2DJVAvgxlRKBZYSIut3/MZ+pxhSXdUIdzT+hH4U0mfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758751272; c=relaxed/simple;
	bh=CsOVMQMB/uHB7AC/KGzuvtkfprMgHT8Mwn6jfcEEBzM=;
	h=Date:To:From:Subject:Message-Id; b=NGmHlEOQ/s/XNz3NG/c/jAioDJ6XQ+I+mlgqUkVXgoNRHPWwnPRETHSlPb6kj5rdWAWhhZWr5wTp92zEXpzjTj0Dh+Ld6DCm67khMaqUMN+uhI8QbqtYq2cwJKF6ugYfpYbi4qEUEIRhXzZH/X2vVf4sXeSP5PVm2rHypIbAt4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yymoeVLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yymoeVLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F11C4CEE7;
	Wed, 24 Sep 2025 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758751271;
	bh=CsOVMQMB/uHB7AC/KGzuvtkfprMgHT8Mwn6jfcEEBzM=;
	h=Date:To:From:Subject:From;
	b=yymoeVLyp1z3BZNpvwIjgp9TVYQGQoCnblWfhxTYWlRXhyhbB1qGZJGRMgLiRTISu
	 o46c9D9WbDP8AG9JvSRRbRMMdvIjiZs9cWdfoXeOJTu63S9XF0CMdQsqRQYh6KS/MC
	 6Dqqkoqxy5Cv576DiCXh6rTk1U3GuNIGXaW7ph/Y=
Date: Wed, 24 Sep 2025 15:01:11 -0700
To: mm-commits@vger.kernel.org,johannes.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-remove-config_panic_on_oops_value.patch added to mm-nonmm-unstable branch
Message-Id: <20250924220111.D5F11C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: remove CONFIG_PANIC_ON_OOPS_VALUE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-remove-config_panic_on_oops_value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-remove-config_panic_on_oops_value.patch

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
From: Johannes Berg <johannes.berg@intel.com>
Subject: panic: remove CONFIG_PANIC_ON_OOPS_VALUE
Date: Wed, 24 Sep 2025 11:43:04 +0200

There's really no need for this since it's 0 or 1 when
CONFIG_PANIC_ON_OOPS is disabled/enabled, so just use IS_ENABLED()
instead.  The extra symbol goes back to the original code adding it in
commit 2a01bb3885c9 ("panic: Make panic_on_oops configurable").

Link: https://lkml.kernel.org/r/20250924094303.18521-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c    |    2 +-
 lib/Kconfig.debug |    6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/kernel/panic.c~panic-remove-config_panic_on_oops_value
+++ a/kernel/panic.c
@@ -53,7 +53,7 @@ static unsigned int __read_mostly sysctl
 #define sysctl_oops_all_cpu_backtrace 0
 #endif /* CONFIG_SMP */
 
-int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
+int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
 static int pause_on_oops;
--- a/lib/Kconfig.debug~panic-remove-config_panic_on_oops_value
+++ a/lib/Kconfig.debug
@@ -1067,12 +1067,6 @@ config PANIC_ON_OOPS
 
 	  Say N if unsure.
 
-config PANIC_ON_OOPS_VALUE
-	int
-	range 0 1
-	default 0 if !PANIC_ON_OOPS
-	default 1 if PANIC_ON_OOPS
-
 config PANIC_TIMEOUT
 	int "panic timeout"
 	default 0
_

Patches currently in -mm which might be from johannes.berg@intel.com are

panic-remove-config_panic_on_oops_value.patch

