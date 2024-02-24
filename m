Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4715E625
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738847; cv=none; b=Rs+30tL6JAmARJYl7YcGI5nZjSFMzwGED3nyfw2ILjMYQZvG0nNMj+ZWzhOpYH3sYErljtNqgwWK6/37bUqOkFFvb2oidJbU2HLbAOBNXc/sMR9prwHTP5pDmVStc1gIxw08jFu0tyrF8QeLpehn5vwq0eSj+2dDWj4EoLj7JJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738847; c=relaxed/simple;
	bh=8OmXC8WPn8M7JL0oW6I06a2Z5TZZI8hRBYVBk5sIWpw=;
	h=Date:To:From:Subject:Message-Id; b=OstC+odW6OPu7K8i1geCIrH3kr/iB6kiDr8Be0WSBuYBdNA4kdt7Tg8S4BUyvzlZCyA2H3OT+ZOXSiUMBIswlb9MwstibHmNi0XtMws1P+8mZXgsl3KN3TI+nc04wzrfMGksaiw/lMhYPtsV7KoCR8qmPMunvpOc3QAoFkMG7x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y/4WlUi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y/4WlUi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6194C433C7;
	Sat, 24 Feb 2024 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738846;
	bh=8OmXC8WPn8M7JL0oW6I06a2Z5TZZI8hRBYVBk5sIWpw=;
	h=Date:To:From:Subject:From;
	b=Y/4WlUi514jE3KAKyypEZvCJGXxt6qU5lCksRnCqfmxBlr9tkudwhjquMPQrMNYuW
	 9uqg8Ms4sHRnGzah2pFn0/xKHt2oCeKup3wFHHOJIX8QjrdOGSwOBpO64J6pFwlvC5
	 Qq5CR1JH1YDRJut2VwPkQQ+uGWIGhh1W1nFVQbgA=
Date: Fri, 23 Feb 2024 17:40:46 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch removed from -mm tree
Message-Id: <20240224014046.C6194C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: remove duplicated include in vmcore_info.c
has been removed from the -mm tree.  Its filename was
     crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix.patch

This patch was dropped because it was folded into crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: crash: remove duplicated include in vmcore_info.c
Date: Fri, 26 Jan 2024 08:57:44 +0800

The header files kexec.h is included twice in vmcore_info.c,
so one inclusion can be removed.

Link: https://lkml.kernel.org/r/20240126005744.16561-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/vmcore_info.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/vmcore_info.c~crash-split-vmcoreinfo-exporting-code-out-from-crash_corec-fix
+++ a/kernel/vmcore_info.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch

