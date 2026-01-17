Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7F27A103
	for <mm-commits@vger.kernel.org>; Sat, 17 Jan 2026 03:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768619066; cv=none; b=l+zeIghbc9BKnWT+OQ6rQnqKpk76fRwBvEcRRTm7/uGq4cGDStvVvBlocP8GLVGOoUcfblEYAGxZqHqghvFjBP9OcyqbBqfCr5un8NVqu5lsIcxXInCNRHqzi+qE2oWmDnSo9G+ObIUYlT3e2LfHlCJI7R+Dtx9LxqsuOlUg16w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768619066; c=relaxed/simple;
	bh=tAtf+4U1HKLGuFOzYIdGKVD0iveBToiM48tMuxaZkmA=;
	h=Date:To:From:Subject:Message-Id; b=UkPDfvcsWlM3mdRegxsfGyqksi+xLSvUVdMpkYhyr2jwR12gJgPZI2ZSZNSFSV1iJ8bYqJDSbnlegKQWVd3eR3q3f79XEEp+ELAUcfuzIlTuvbxWhgFA9cALki+92J9L91PTWCvCZqKejTzKeUj+tnJt5VnxSV+i5fE30vHSvIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nfu2vY5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nfu2vY5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863BEC116C6;
	Sat, 17 Jan 2026 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768619065;
	bh=tAtf+4U1HKLGuFOzYIdGKVD0iveBToiM48tMuxaZkmA=;
	h=Date:To:From:Subject:From;
	b=Nfu2vY5Gq5jruEir2uTlUGUFFysWazxEXjKWGbu077fGIWIEWor+IBx22Th3kXN64
	 G+DBGYEt/5UX9yuCfx5Wv1Z9swLbuei+dxS8JiSIg/gpfA0fos5ZFXBjMBsNkVGxwx
	 AAveU0/88WYPmkxXwe47D1djLX6B5pD6Uf5pv+PI=
Date: Fri, 16 Jan 2026 19:04:24 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + moduleparam-include-required-headers-explicitly.patch added to mm-nonmm-unstable branch
Message-Id: <20260117030425.863BEC116C6@smtp.kernel.org>
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
From: Yury Norov <ynorov@nvidia.com>
Subject: moduleparam: include required headers explicitly
Date: Thu, 15 Jan 2026 23:25:05 -0500

The following patch drops moduleparam.h dependency on kernel.h.  In
preparation to it, list all the required headers explicitly.

Link: https://lkml.kernel.org/r/20260116042510.241009-3-ynorov@nvidia.com
Signed-off-by: Yury Norov <ynorov@nvidia.com>
Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
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

Patches currently in -mm which might be from ynorov@nvidia.com are

nodemask-propagate-boolean-for-nodes_andnot.patch
mm-use-nodes_and-return-value-to-simplify-client-code.patch
cgroup-use-nodes_and-output-where-appropriate.patch
kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
kernelh-include-linux-instruction_pointerh-explicitly.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

