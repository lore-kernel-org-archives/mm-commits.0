Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783C318BBBB
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745883630; cv=none; b=Fsp6veJQo4kWV2RzN2vDJXTAa373MskDEMcN9NxiBYxfrWzpV3iiTQSOKhXurVK3w3wC/WohMXf33q8+TwkgMEoQDygkInAelaYtxbLFW+RhmyJuwKiTzFMKLOiQpF+hyHbkSANba3wg4EVZJNXwMOsH52RNpnMqbkqy0+ujw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745883630; c=relaxed/simple;
	bh=VjxyPKadV3U0t13VshRCCzaGOR7HH6eBN3XNeYRr2X0=;
	h=Date:To:From:Subject:Message-Id; b=BOMjYlU6ojYLF/00Q64iMIJl1OGJd9XpBASoJ90FxME7tlM1ZRWliYuIrK+76w06QIKurTPa9WUgAAVj0Zdc6947OM5fxW+Fw42iXUZDuuaJ38j52eDzB8HTj+Ixmi1rhO+0eyT7yhLZAQ3LRIupgFozhEBVc/Optuzod+NYjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wy44dg38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wy44dg38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA63C4CEE4;
	Mon, 28 Apr 2025 23:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745883630;
	bh=VjxyPKadV3U0t13VshRCCzaGOR7HH6eBN3XNeYRr2X0=;
	h=Date:To:From:Subject:From;
	b=Wy44dg38KXNdjBJVa2ru5QMIhqtP+Y8AJvvNmAgJl4/PxKOhGjsLC+LVylBlGLGsJ
	 FnKyVvpDh6rBT1RQXX0LY0DLwIzmKs2zYkfpLC6VgYAKnQXVMjEUBI7DrPQsCug/58
	 4iS9kL5yhMQ2if+u2be+c34FsI8OLGpuBCKJqVdA=
Date: Mon, 28 Apr 2025 16:40:29 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + util_macrosh-make-the-header-more-resilient.patch added to mm-unstable branch
Message-Id: <20250428234029.DDA63C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: util_macros.h: make the header more resilient
has been added to the -mm mm-unstable branch.  Its filename is
     util_macrosh-make-the-header-more-resilient.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/util_macrosh-make-the-header-more-resilient.patch

This patch will later appear in the mm-unstable branch at
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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: util_macros.h: make the header more resilient
Date: Mon, 28 Apr 2025 10:27:54 +0300

Add missing header inclusions.

Link: https://lkml.kernel.org/r/20250428072754.3265274-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/util_macros.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/util_macros.h~util_macrosh-make-the-header-more-resilient
+++ a/include/linux/util_macros.h
@@ -2,7 +2,10 @@
 #ifndef _LINUX_HELPER_MACROS_H_
 #define _LINUX_HELPER_MACROS_H_
 
+#include <linux/compiler_attributes.h>
 #include <linux/math.h>
+#include <linux/typecheck.h>
+#include <linux/stddef.h>
 
 /**
  * for_each_if - helper for handling conditionals in various for_each macros
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

util_macrosh-make-the-header-more-resilient.patch
kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh.patch
util_macrosh-fix-the-reference-in-kernel-doc.patch

