Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3122D7D47
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074113; cv=none; b=DjA4MbkC0xkAYZTCLwyQIdUcSDxqCpJwf9DRgpNNgro4/Mq0ZJ11vchPh0Zucy/paNkEofr0i9ehxzATRTLuCXi2YhzvwCEFD40rejgFNs3anpUARMUJNbptBon7fuGMxaMaYo59Uh/hLdnvNVk0EzP4noZFqAjxQIZ4iV28C1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074113; c=relaxed/simple;
	bh=YhliZoiubxoOYESSmmK2Z6greaqsOAU7KmKOoOlInCI=;
	h=Date:To:From:Subject:Message-Id; b=GaEtnBeguVeaTvnb0XJfk+Zra9fB66QXdUOUNHeFpaRNplAqqofa8K8e/kImiFOFpoy1u/nC/F8jKGuF+v3e4o0QdHc2uaW1d+cMnVfW2eZPiKJKrfQNLK/aoTHGuAbenn0/N2B2F0Zk8JgeAGaKiJ4FtShQyJMOzOmLKo6L2O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fC5I3xGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fC5I3xGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885C1C4CEF7;
	Thu, 13 Nov 2025 22:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763074112;
	bh=YhliZoiubxoOYESSmmK2Z6greaqsOAU7KmKOoOlInCI=;
	h=Date:To:From:Subject:From;
	b=fC5I3xGx/QoT0/m+tCf7CmGC4RG+VqAE8+an0lJ1M0GzJ1iNS137gvojtwkXk0O7c
	 mhfTOTOCha78JfK7UdNdlolqgHALkV1ncpBQuphJ+S/kr3JSbLu87bAv7NFnb28Uox
	 2JA6d2313R9Eku4eoAhrShO0eCLDOnNoDquZMBKU=
Date: Thu, 13 Nov 2025 14:48:31 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,pmladek@suse.com,paulmck@kernel.org,ioworker0@gmail.com,corbet@lwn.net,feng.tang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch added to mm-nonmm-unstable branch
Message-Id: <20251113224832.885C1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: panic: correct some sys_ifo names in sysctl doc
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch

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
From: Feng Tang <feng.tang@linux.alibaba.com>
Subject: docs: panic: correct some sys_ifo names in sysctl doc
Date: Thu, 13 Nov 2025 19:10:36 +0800

Patch series "Enable hung_task and lockup cases to dump system info on
demand", v2.

When working on kernel stability issues: panic, task-hung and soft/hard
lockup are frequently met.  And to debug them, user may need lots of
system information at that time, like task call stacks, lock info, memory
info, ftrace dump, etc.

panic case already uses sys_info() for this purpose, and has a
'panic_sys_info' sysctl(also support cmdline setup) interface to take
human readable string like "tasks,mem,timers,locks,ftrace,..." to control
what kinds of information is needed.  Which is also helpful to debug
task-hung and lockup cases.

So this patchset introduces the similar sys_info sysctl interface for
task-hung and lockup cases.

his is mainly for debugging and the info dumping could be intrusive, like
dumping call stack for all tasks when system has huge number of tasks,
similarly for ftrace dump (we may add tracing_stop() and tracing_start()
around it)

Locally these have been used in our bug chasing for stability issues and
were helpful.

As Andrew suggested, add a configurable global 'kernel_sys_info' knob. 
When error scenarios like panic/hung-task/lockup etc doesn't setup their
own sys_info knob and calls sys_info() with parameter "0", this global
knob will take effect.  It could be used for other kernel cases like OOM,
which may not need one dedicated sys_info knob.


This patch (of 4):

Some sys_info names wered forgotten to change in patch iterations, while
the right names are defined in kernel/sys_info.c.

Link: https://lkml.kernel.org/r/20251113111039.22701-1-feng.tang@linux.alibaba.com
Link: https://lkml.kernel.org/r/20251113111039.22701-2-feng.tang@linux.alibaba.com
Fixes: d747755917bf ("panic: add 'panic_sys_info' sysctl to take human readable string parameter")
Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-panic-correct-some-sys_ifo-names-in-sysctl-doc
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -911,8 +911,8 @@ to 'panic_print'. Possible values are:
 =============   ===================================================
 tasks           print all tasks info
 mem             print system memory info
-timer           print timers info
-lock            print locks info if CONFIG_LOCKDEP is on
+timers          print timers info
+locks           print locks info if CONFIG_LOCKDEP is on
 ftrace          print ftrace buffer
 all_bt          print all CPUs backtrace (if available in the arch)
 blocked_tasks   print only tasks in uninterruptible (blocked) state
_

Patches currently in -mm which might be from feng.tang@linux.alibaba.com are

docs-panic-correct-some-sys_ifo-names-in-sysctl-doc.patch
hung_task-add-hung_task_sys_info-sysctl-to-dump-sys-info-on-task-hung.patch
watchdog-add-sys_info-sysctls-to-dump-sys-info-on-system-lockup.patch
sys_info-add-a-default-kernel-sys_info-mask.patch

