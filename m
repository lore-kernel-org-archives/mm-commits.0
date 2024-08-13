Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047901A3BD9
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 18:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723575153; cv=none; b=IDwTtqc4rHTzdPBoO3CJ2AXog2ZdtIH59cSVqfaUQxdItTJADvqKiFyXlRIcDoYBjE2RkmfeanF+/Fyh0GUGUywfb2Lio/AGVH/8vi57uz3GYQujcYqJv4BYcB8G4TvVOriTFcbvG/HZfTp2ZM+7T6YifPtdD3+J027hP2XTFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723575153; c=relaxed/simple;
	bh=Ui6wxLMdqzRXVg0BVVH3iL1oQ2WF6tRFeVqsN4j4dtQ=;
	h=Date:To:From:Subject:Message-Id; b=BSP0nufV8oRZmMN8/qStwcpiwRscrsvMQCbwnNAn7sua/SlhTHZ7/hKqE+C/3QbypvAXKZHojtL06Pmi3P2taSJlIgPWRB+koBlWINPkblPVFKbHOesMH1S6ZLAN0pYYJtEikdtOc3hGKxUpglfzyrYHscErYsZNAhrRihu+6Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ukkhSMVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ukkhSMVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836ABC32782;
	Tue, 13 Aug 2024 18:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723575151;
	bh=Ui6wxLMdqzRXVg0BVVH3iL1oQ2WF6tRFeVqsN4j4dtQ=;
	h=Date:To:From:Subject:From;
	b=ukkhSMVISeP5ldtUwmH26daHUl4l02tYu0QI+1PUH0Wyxckb12T7d6V9bemofCaSU
	 dqh9yyDiesbpMQP5aaUTNNgPB3f2DiXfXepEtB4Hby6rVEmbuPwkvyOXk+uv5B4OC/
	 XnZ3xhGTjq3n+N4B76qMS7MlRlFsblTQnPeI/8m8=
Date: Tue, 13 Aug 2024 11:52:30 -0700
To: mm-commits@vger.kernel.org,thomas.hellstrom@linux.intel.com,rodrigo.vivi@intel.com,robdclark@gmail.com,quic_abhinavk@quicinc.com,lucas.demarchi@intel.com,himal.prasad.ghimiray@intel.com,dmitry.baryshkov@linaro.org,akinobu.mita@gmail.com,jani.nikula@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-inject-improve-build-for-config_fault_injection=n.patch added to mm-nonmm-unstable branch
Message-Id: <20240813185231.836ABC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fault-inject: improve build for CONFIG_FAULT_INJECTION=n
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-inject-improve-build-for-config_fault_injection=n.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-inject-improve-build-for-config_fault_injection=n.patch

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
From: Jani Nikula <jani.nikula@intel.com>
Subject: fault-inject: improve build for CONFIG_FAULT_INJECTION=n
Date: Tue, 13 Aug 2024 15:12:35 +0300

The fault-inject.h users across the kernel need to add a lot of #ifdef
CONFIG_FAULT_INJECTION to cater for shortcomings in the header.  Make
fault-inject.h self-contained for CONFIG_FAULT_INJECTION=n, and add stubs
for DECLARE_FAULT_ATTR(), setup_fault_attr(), should_fail_ex(), and
should_fail() to allow removal of conditional compilation.

Link: https://lkml.kernel.org/r/20240813121237.2382534-1-jani.nikula@intel.com
Fixes: 6ff1cb355e62 ("[PATCH] fault-injection capabilities infrastructure")
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |   36 ++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- a/include/linux/fault-inject.h~fault-inject-improve-build-for-config_fault_injection=n
+++ a/include/linux/fault-inject.h
@@ -2,13 +2,17 @@
 #ifndef _LINUX_FAULT_INJECT_H
 #define _LINUX_FAULT_INJECT_H
 
+#include <linux/err.h>
+#include <linux/types.h>
+
+struct dentry;
+struct kmem_cache;
+
 #ifdef CONFIG_FAULT_INJECTION
 
-#include <linux/types.h>
-#include <linux/debugfs.h>
+#include <linux/atomic.h>
 #include <linux/configfs.h>
 #include <linux/ratelimit.h>
-#include <linux/atomic.h>
 
 /*
  * For explanation of the elements of this struct, see
@@ -51,6 +55,28 @@ int setup_fault_attr(struct fault_attr *
 bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
 bool should_fail(struct fault_attr *attr, ssize_t size);
 
+#else /* CONFIG_FAULT_INJECTION */
+
+struct fault_attr {
+};
+
+#define DECLARE_FAULT_ATTR(name) struct fault_attr name = {}
+
+static inline int setup_fault_attr(struct fault_attr *attr, char *str)
+{
+	return 0; /* Note: 0 means error for __setup() handlers! */
+}
+static inline bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
+{
+	return false;
+}
+static inline bool should_fail(struct fault_attr *attr, ssize_t size)
+{
+	return false;
+}
+
+#endif /* CONFIG_FAULT_INJECTION */
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 
 struct dentry *fault_create_debugfs_attr(const char *name,
@@ -87,10 +113,6 @@ static inline void fault_config_init(str
 
 #endif /* CONFIG_FAULT_INJECTION_CONFIGFS */
 
-#endif /* CONFIG_FAULT_INJECTION */
-
-struct kmem_cache;
-
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order);
 #else
_

Patches currently in -mm which might be from jani.nikula@intel.com are

fault-inject-improve-build-for-config_fault_injection=n.patch
drm-msm-clean-up-fault-injection-usage.patch
drm-xe-clean-up-fault-injection-usage.patch

