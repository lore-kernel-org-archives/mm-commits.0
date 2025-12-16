Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7424425A2A2
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 20:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765918627; cv=none; b=gb+1GR52xFskuMEhBsQzIVw8EnNlq55obTAylCmqXjHeFXILfx4ayJjG8+5ZtVoU/85PYNSt0Rwo34prxIyQ/wVoNnrR0Apu1qQBmutQtAxs/JI3G2A5m25N1LJojsNzjhOGAR5DKCNwQbL32ANnENfi26qUkTrZ7EWXV4I2FLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765918627; c=relaxed/simple;
	bh=aPEa0zEktHLjFNiQxEfdKAoID9PWqR16Cm14L4LI2qE=;
	h=Date:To:From:Subject:Message-Id; b=ZXB6OGvs3UIWxzDTZsCTPYqGAkoiQCikWWAqq2B9hXlIkRrpQyyFtzMeI47Ew9p1rTXojs133P6JD4c56Gr8+djUSYa/f5sBhs3/6R2wt2uTUwMAKZ4IZTCInjHJas+rF15ZM1Df0/AhGOr+etpdRivMl/Ot3ahNE/CyIGHFz6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Fhcs+Ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Fhcs+Ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB330C4CEFB;
	Tue, 16 Dec 2025 20:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765918626;
	bh=aPEa0zEktHLjFNiQxEfdKAoID9PWqR16Cm14L4LI2qE=;
	h=Date:To:From:Subject:From;
	b=0Fhcs+Ow3Lvu9n63CuPA/xlfYC2WhcHGGB0749lqZ8uVGLdE6S63B+B+UcwdzDfKU
	 BX4A1GDqsaQUuKMXRtXNegTX6OdNnkbQfgw9BqdDN5g897QwCWQMSMnQVd4MjiEvT4
	 VDRYY6Sksj79uYJqxzkeyNz9IRP9OEfryrTRShf0=
Date: Tue, 16 Dec 2025 12:57:06 -0800
To: mm-commits@vger.kernel.org,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,rdunlap@infradead.org,petr.pavlu@suse.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,joonas.lahtinen@linux.intel.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,dakr@kernel.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + moduleparam-include-required-headers-explicitly.patch added to mm-nonmm-unstable branch
Message-Id: <20251216205706.CB330C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: moduleparam: include required headers explicitly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     moduleparam-include-required-headers-explicitly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/moduleparam-include-required-headers-explicitly.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Subject: moduleparam: include required headers explicitly
Date: Fri, 5 Dec 2025 12:52:33 -0500

The following patch drops moduleparam.h dependency on kernel.h.  In
preparation to it, list all the required headers explicitly.

Link: https://lkml.kernel.org/r/20251205175237.242022-3-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/moduleparam.h~moduleparam-include-required-headers-explicitly
+++ a/include/linux/moduleparam.h
@@ -2,9 +2,14 @@
 #ifndef _LINUX_MODULE_PARAMS_H
 #define _LINUX_MODULE_PARAMS_H
 /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
+
+#include <linux/array_size.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/kernel.h>
+#include <linux/types.h>
 
 /*
  * The maximum module name length, including the NUL byte.
_

Patches currently in -mm which might be from yury.norov@gmail.com are

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

