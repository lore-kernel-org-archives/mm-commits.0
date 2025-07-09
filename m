Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C1F9E8
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752028912; cv=none; b=Fu4I2UBJn7w+mCsbDH1f2lX2Q6Em7QS581PKv5WsCLwgJ3Y4g9YHKGO/wezvGLi8k58VQYCgluTWP539bAYe42yS3iyUIvehcNIUJ68vAKzzuqHfk1f3Fd4/BtzAGSWlGPINL9G1oDmXzbAG76JIvYfM0Wl3uuubD1MVe61yvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752028912; c=relaxed/simple;
	bh=e3VOcsjcC+2dHcYxvv+WalIazzzX8C/Mo6oi7ccfe34=;
	h=Date:To:From:Subject:Message-Id; b=WiLiAM+mXxV7zo2ybLrLdgG3WwJN5MZit7FCu1rwbWh8hfXc/jPbrzW2BSqSBCj//BPTI09F1wEcCKtVvoS4YjrMOw0t+uSkusnEMibe41EGJn23VQ8a6ZHgHb6CnQ5UYkMbNNRyl5L2i1dnC839mfM07Y3jTwWS1U44TeLdOm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lGjb51NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lGjb51NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B8CC4CEED;
	Wed,  9 Jul 2025 02:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752028912;
	bh=e3VOcsjcC+2dHcYxvv+WalIazzzX8C/Mo6oi7ccfe34=;
	h=Date:To:From:Subject:From;
	b=lGjb51NSkrxNWHJ2j7Fyza4lRVInNrQcwo8tCnryH1ELGzf1ysJNCB/ZkLrigoQR9
	 C/mXwbAHFXwR2LlYddE3NH5raYwR8Q+Igs0Dv9cLU3lp6XtEO0cZ0p93F6S8nH9cfh
	 m4rKiy1/CFb+eldtVBB+DseDQar+n/dSF6gyPru0=
Date: Tue, 08 Jul 2025 19:41:51 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250709024152.01B8CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: add __maybe_unused to sys_info_avail
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: panic: add __maybe_unused to sys_info_avail
Date: Tue, 08 Jul 2025 08:37:57 -0700

Clang warns (or errors with CONFIG_WERROR=y):

  lib/sys_info.c:52:19: error: variable 'sys_info_avail' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
     52 | static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
        |                   ^~~~~~~~~~~~~~

sys_info_avail is only used within sizeof(), meaning it is only used at
compile time, which clang warns about in case the developer intended to
use the variable elsewhere. This appears to be intentional in this case,
so mark sys_info_avail with __maybe_unused to silence the warning.

Link: https://lkml.kernel.org/r/20250708-fix-clang-sys_info_avail-warning-v1-1-60d239eacd64@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sys_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sys_info.c~panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix
+++ a/lib/sys_info.c
@@ -49,7 +49,7 @@ unsigned long sys_info_parse_param(char
 
 #ifdef CONFIG_SYSCTL
 
-static const char sys_info_avail[] = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
+static const char sys_info_avail[] __maybe_unused = "tasks,mem,timers,locks,ftrace,all_bt,blocked_tasks";
 
 int sysctl_sys_info_handler(const struct ctl_table *ro_table, int write,
 					  void *buffer, size_t *lenp,
_

Patches currently in -mm which might be from nathan@kernel.org are

panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

