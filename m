Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C62DAFAC
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619071; cv=none; b=OvGDVnhZVqauNUlYXVzi4HOxDqj1FqtwZKFjU5+csCQIWidB/UQ1lpcOQzMu0wlqAxb7w0orpGSi4zFOuiZWwO0KkgayYIRFCJxKCSDo0EGv8UigyX60ERvh2W//m0wLYyGp+sPfGWD8YJet6rWkW3mYfxAR7l2A4+IqhyvMuHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619071; c=relaxed/simple;
	bh=ualrIg5y0/qoRjruwEWVJt7mGJMovwGtH49z12TmxGA=;
	h=Date:To:From:Subject:Message-Id; b=AVjmyVndXw6CDIvlpzXwud1MwfN9mwXyH5s7jHy/tvBknz4LlVT+0+aQvUyYKfz5/Obiv6bQb6+1umJ5lv1BJYuvYPi331Zp5YeGTb88bx+WcTDMyT7Xmu3qHfP3ENhsY7Uay8vK6dLbm1YrILLCzNXqRZPMB8F08+xWQkTFs80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cmwjd3Eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cmwjd3Eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1288FC116C6;
	Sat, 17 Jan 2026 03:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619071;
	bh=ualrIg5y0/qoRjruwEWVJt7mGJMovwGtH49z12TmxGA=;
	h=Date:To:From:Subject:From;
	b=Cmwjd3EuiAohKqo5sDlbu5k1VnjNZehaMa5nD5ASc81btAOP6xmE853dxf8oWghcV
	 DnswZBKHLwtGI5ei0uteTH2hWR4VQDO5rZeHYuzPt9O7kJpJ3E8vEGB6yIWozv9DPD
	 RKwDi7hd8erecLlkTCiwcyWMDuu7ImWnLe/gsYng=
Date: Fri, 16 Jan 2026 19:04:30 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-include-linux-instruction_pointerh-explicitly.patch added to mm-nonmm-unstable branch
Message-Id: <20260117030431.1288FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: include linux/instruction_pointer.h explicitly
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-include-linux-instruction_pointerh-explicitly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-include-linux-instruction_pointerh-explicitly.patch

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
From: Yury Norov <ynorov@nvidia.com>
Subject: kernel.h: include linux/instruction_pointer.h explicitly
Date: Thu, 15 Jan 2026 23:25:07 -0500

In preparation for decoupling linux/instruction_pointer.h and
linux/kernel.h, include instruction_pointer.h explicitly where needed.

Link: https://lkml.kernel.org/r/20260116042510.241009-5-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/processor.h |    1 +
 include/linux/ww_mutex.h          |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/s390/include/asm/processor.h~kernelh-include-linux-instruction_pointerh-explicitly
+++ a/arch/s390/include/asm/processor.h
@@ -31,6 +31,7 @@
 #include <linux/cpumask.h>
 #include <linux/linkage.h>
 #include <linux/irqflags.h>
+#include <linux/instruction_pointer.h>
 #include <linux/bitops.h>
 #include <asm/fpu-types.h>
 #include <asm/cpu.h>
--- a/include/linux/ww_mutex.h~kernelh-include-linux-instruction_pointerh-explicitly
+++ a/include/linux/ww_mutex.h
@@ -17,6 +17,7 @@
 #ifndef __LINUX_WW_MUTEX_H
 #define __LINUX_WW_MUTEX_H
 
+#include <linux/instruction_pointer.h>
 #include <linux/mutex.h>
 #include <linux/rtmutex.h>
 
_

Patches currently in -mm which might be from ynorov@nvidia.com are

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch
kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

