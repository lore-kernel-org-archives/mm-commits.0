Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38AD2EE5F6
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753392006; cv=none; b=LuoUyMBtDGJrwU3/6HnSNAuvu1APorezCe2/KFLQnXBQGJO1WUn2JnNZyOJGekqs9bFsQ7YDYWvrQM51dBP2wDU+l/VN7Wpc8hNbKNKjpSviDQZadTdzJD3JATHYBJc169c1K0Bg+eNT1IStjvQvgVrlNO6W6w2PNA+0eX2t1M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753392006; c=relaxed/simple;
	bh=GBcrudwAZ4fMLCZulAVGVg672wjO8hrNLxa6UU4Uhyw=;
	h=Date:To:From:Subject:Message-Id; b=rzoJ1PH8EsODGoTY2aB+18ka07on7L1N6QoOLRJ2Q2KGh6uOGK/40s/iZokl7aVC0A4VR/eGdROrM0kxwVhtbHeEwj1Jf+Tte9Vdp3DXnoGDIpmp4CB1JgoAN0LNY3sZDyxQiskWwtjof0dglFsedzajnJ76Xz5XQMY59fVO2rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t6RAqjTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t6RAqjTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B87C4CEED;
	Thu, 24 Jul 2025 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753392005;
	bh=GBcrudwAZ4fMLCZulAVGVg672wjO8hrNLxa6UU4Uhyw=;
	h=Date:To:From:Subject:From;
	b=t6RAqjTJcSjjGDN/r92V9TVC8GQ0sMvYiLzsQqpJrMlL55ijbsUC++o3S24Mn/Kz9
	 2DjZudlD2bKEF2rNDimqhIPAAmKezGS+VzJ0wg7afHugwHGPFnv03TjlSysj0t4OhX
	 zH3VpZx4XZ1d0Fh4ce8ZBYuyPiC/09diT7usCFEE=
Date: Thu, 24 Jul 2025 14:20:04 -0700
To: mm-commits@vger.kernel.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-kconfig-fix-spelling-mistake-instancess-instances.patch added to mm-nonmm-unstable branch
Message-Id: <20250724212005.69B87C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples: Kconfig: fix spelling mistake "instancess" -> "instances"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     samples-kconfig-fix-spelling-mistake-instancess-instances.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-kconfig-fix-spelling-mistake-instancess-instances.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: samples: Kconfig: fix spelling mistake "instancess" -> "instances"
Date: Thu, 24 Jul 2025 12:17:15 +0100

There is a spelling mistake in the SAMPLE_TRACE_ARRAY config. Fix it.

Link: https://lkml.kernel.org/r/20250724111715.141826-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/samples/Kconfig~samples-kconfig-fix-spelling-mistake-instancess-instances
+++ a/samples/Kconfig
@@ -54,7 +54,7 @@ config SAMPLE_FTRACE_OPS
 	  measures the time taken to invoke one function a number of times.
 
 config SAMPLE_TRACE_ARRAY
-        tristate "Build sample module for kernel access to Ftrace instancess"
+        tristate "Build sample module for kernel access to Ftrace instances"
 	depends on EVENT_TRACING && m
 	help
 	 This builds a module that demonstrates the use of various APIs to
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

samples-kconfig-fix-spelling-mistake-instancess-instances.patch

