Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAFF3EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905008; cv=none; b=kXX7sxf0flQCGmM1g0YmqGGD46DSF1SULej9jLdl6Twyrk0ZBF/Ft40wpJbshaHTRmABrOlgp1wBqVIpLYvuuscHgy6sHFp1gmzyFiFHFo6zR2F5HqUyQgUSwZiHOsm0oDoaL1e7j5lMIFyB0eWsGmDOf8TIGH/gWnhNImBzuNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905008; c=relaxed/simple;
	bh=KRkud1MZ1NxTQgmCNYPBRVzmXtHABSKPGgJVyw6Ee60=;
	h=Date:To:From:Subject:Message-Id; b=VIbGbVrmGkA/UCl+O/Op3TAA5XSsNR4u9B6g9msVWN7soLdAgFAHIIdrRx3fQ8hC+QXP87uXT6xxnnfGKSczrHyq/SXuRVKU1iEl5PC7P93i2/Atr+da0f/8I2duasegNKLUvsFQ2TiAumjNh5ciABczzfYwpnq8aDi6IpLYBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dyWIu2AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dyWIu2AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863BAC4CEF1;
	Sun,  1 Feb 2026 00:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905008;
	bh=KRkud1MZ1NxTQgmCNYPBRVzmXtHABSKPGgJVyw6Ee60=;
	h=Date:To:From:Subject:From;
	b=dyWIu2AYMnXIah0R26NyK7orDFOUHA1MluWgXanrIsuEAKFrHE6wT20kaqhqC5eOj
	 lnpzx7i8iapAxWK4xDp2w6FvYbDRIW1HLj1OjAicesgFwIfYd+JJ6cBl4sAz0r2nUv
	 h7lFgwrdQJFrjtMMD6CgLyHo59930qT7g7gPDFdY=
Date: Sat, 31 Jan 2026 16:16:48 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rdunlap@infradead.org,petr.pavlu@suse.com,joelagnelf@nvidia.com,jani.nikula@intel.com,gregkh@linuxfoundation.org,chleroy@kernel.org,atomlin@atomlin.com,andriy.shevchenko@linux.intel.com,andi.shyti@linux.intel.com,ynorov@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] moduleparam-include-required-headers-explicitly.patch removed from -mm tree
Message-Id: <20260201001648.863BAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: moduleparam: include required headers explicitly
has been removed from the -mm tree.  Its filename was
     moduleparam-include-required-headers-explicitly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


