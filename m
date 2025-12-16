Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A79225A2A2
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 20:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765918629; cv=none; b=lv47fj5xdB7/g9+4HQ8dsflLlxJ17qa6P/nM/EtRWpxpOkUPQwL7w9+a9ORQ/iO9inmswcBX373rsZGOrdxuIcVByQXJ/RKsJlfb88dEBpqc7GmVPpDx+z23YAMoE9XoWxYArTo7vsa9puu5qW2N5Wguzk97tP8vkwom65E6fPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765918629; c=relaxed/simple;
	bh=5oGityljGkBI4NSDe9oWyhkB/GQDlLQa5T5/ww+Va3Y=;
	h=Date:To:From:Subject:Message-Id; b=TzPpBVXT2oYvOJgvf3njtavs6KsXoZq/V4C7bYf0a0BfE9mTFTeBIFfwVs/cSID+J41H5MG+VPwCgRvTg3x11mBcLtm3iLlS1XGMRiSO5E7ECOKdYhrRFE/AL9Fh3dds4RyJH30vYVzLtJ7++K8xQTC9HCenGolq5ek667G/kGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ADu3bqVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ADu3bqVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A14CC4CEF1;
	Tue, 16 Dec 2025 20:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765918629;
	bh=5oGityljGkBI4NSDe9oWyhkB/GQDlLQa5T5/ww+Va3Y=;
	h=Date:To:From:Subject:From;
	b=ADu3bqVlYWquSGXL76FLGaTgwMHDpQOCmC5a2iU19rFb7r1UndzfebCfnXHo8CJYT
	 mZN6+H2/PizZaZyYttafPHpSe6fREFJA+3qzvYeN9xKvggksfjW6gMmS6S4FOXic2d
	 qLcYeUfUp252S+PRgwxpQb2gAmIpXSyyq0rgvS30=
Date: Tue, 16 Dec 2025 12:57:08 -0800
To: mm-commits@vger.kernel.org,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,rdunlap@infradead.org,petr.pavlu@suse.com,mingo@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,joonas.lahtinen@linux.intel.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,dakr@kernel.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,yury.norov@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-move-verify_octal_permissions-to-sysfsh.patch added to mm-nonmm-unstable branch
Message-Id: <20251216205709.0A14CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: move VERIFY_OCTAL_PERMISSIONS() to sysfs.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-move-verify_octal_permissions-to-sysfsh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-move-verify_octal_permissions-to-sysfsh.patch

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
Subject: kernel.h: move VERIFY_OCTAL_PERMISSIONS() to sysfs.h
Date: Fri, 5 Dec 2025 12:52:34 -0500

The macro is related to sysfs, but is defined in kernel.h.  Move it to the
proper header, and unload the generic kernel.h.

Now that the macro is removed from kernel.h, linux/moduleparam.h is
decoupled, and kernel.h inclusion can be removed.

Link: https://lkml.kernel.org/r/20251205175237.242022-4-yury.norov@gmail.com
Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
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
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/sysfs.rst |    2 +-
 include/linux/kernel.h              |   12 ------------
 include/linux/moduleparam.h         |    2 +-
 include/linux/sysfs.h               |   13 +++++++++++++
 4 files changed, 15 insertions(+), 14 deletions(-)

--- a/Documentation/filesystems/sysfs.rst~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/Documentation/filesystems/sysfs.rst
@@ -120,7 +120,7 @@ is equivalent to doing::
 	    .store = store_foo,
     };
 
-Note as stated in include/linux/kernel.h "OTHER_WRITABLE?  Generally
+Note as stated in include/linux/sysfs.h "OTHER_WRITABLE?  Generally
 considered a bad idea." so trying to set a sysfs file writable for
 everyone will fail reverting to RO mode for "Others".
 
--- a/include/linux/kernel.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/kernel.h
@@ -388,16 +388,4 @@ static inline void ftrace_dump(enum ftra
 # define REBUILD_DUE_TO_DYNAMIC_FTRACE
 #endif
 
-/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
-#define VERIFY_OCTAL_PERMISSIONS(perms)						\
-	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
-	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
-	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
-	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
-	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
-	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
-	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
-	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
-	 (perms))
 #endif
--- a/include/linux/moduleparam.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/moduleparam.h
@@ -8,7 +8,7 @@
 #include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/stringify.h>
-#include <linux/kernel.h>
+#include <linux/sysfs.h>
 #include <linux/types.h>
 
 /*
--- a/include/linux/sysfs.h~kernelh-move-verify_octal_permissions-to-sysfsh
+++ a/include/linux/sysfs.h
@@ -808,4 +808,17 @@ static inline void sysfs_put(struct kern
 	kernfs_put(kn);
 }
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)						\
+	(BUILD_BUG_ON_ZERO((perms) < 0) +					\
+	 BUILD_BUG_ON_ZERO((perms) > 0777) +					\
+	 /* USER_READABLE >= GROUP_READABLE >= OTHER_READABLE */		\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 4) < (((perms) >> 3) & 4)) +	\
+	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 4) < ((perms) & 4)) +		\
+	 /* USER_WRITABLE >= GROUP_WRITABLE */					\
+	 BUILD_BUG_ON_ZERO((((perms) >> 6) & 2) < (((perms) >> 3) & 2)) +	\
+	 /* OTHER_WRITABLE?  Generally considered a bad idea. */		\
+	 BUILD_BUG_ON_ZERO((perms) & 2) +					\
+	 (perms))
+
 #endif /* _SYSFS_H_ */
_

Patches currently in -mm which might be from yury.norov@gmail.com are

kernelh-drop-stack_magic-macro.patch
moduleparam-include-required-headers-explicitly.patch
kernelh-move-verify_octal_permissions-to-sysfsh.patch
tracing-move-tracing-declarations-from-kernelh-to-a-dedicated-header.patch

