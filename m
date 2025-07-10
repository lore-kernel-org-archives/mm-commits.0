Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285682206B5
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752184789; cv=none; b=PC5Bkg7HEXFDgzT70rUqkNH4pHfyVH51AQ/n+yQxhpXbxLZoHxDGB92qqrzJQUrthuHsuoFGYKHcV/jaGZ2yF/agO5xA0zvfCg8m84V4AVWdIGICmyPMC2r9G82IbwhjJjJpDuM3+otz65fV/3TUcji8+oIC7l8YX34BQEFr0Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752184789; c=relaxed/simple;
	bh=fnVEERoXi399gr3cyHbBK5CY/YcPbWw4rbdi5za9Ss0=;
	h=Date:To:From:Subject:Message-Id; b=IIav8gddLKd33eG+vD/pMMKy3BVo2XPQH3oPDj9qZBfmjqv0RkjR17yRfkzjwyPp+702jf4MdDFvwT6UUaYOcV8edYAgIA73m3FMEqXuFs1UvQBTJMKBNYJeGKuiU1kFr3Q5KICQCgftl35CFup/Plrc0EUtSrOuXv1vNaxFFTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKJOFWd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKJOFWd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5346C4CEE3;
	Thu, 10 Jul 2025 21:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752184788;
	bh=fnVEERoXi399gr3cyHbBK5CY/YcPbWw4rbdi5za9Ss0=;
	h=Date:To:From:Subject:From;
	b=tKJOFWd4BcwJdwgcowIZAI/seM8uyHLX9Tt/K9LcYezgCZaeDyfymdA00bYk/1gJG
	 jek0nIDRbbaaVJjpo1jLa60XP9R2uyAVfsw7vJfyHF9cRRMWjPPSeTmcnyEzmsZRRO
	 00nQzYvr8yQwzRgNmD9Chw+YGiEqtoUO8bpQ9ViA=
Date: Thu, 10 Jul 2025 14:59:48 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,lance.yang@linux.dev,john.ogness@linutronix.de,feng.tang@linux.alibaba.com,corbet@lwn.net,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch removed from -mm tree
Message-Id: <20250710215948.A5346C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: panic: add __maybe_unused to sys_info_avail
has been removed from the -mm tree.  Its filename was
     panic-add-panic_sys_info-sysctl-to-take-human-readable-string-parameter-fix.patch

This patch was dropped because an alternative patch was or shall be merged

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


