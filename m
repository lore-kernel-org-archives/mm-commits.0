Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31BE82497
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104500; cv=none; b=qfX9Y+zgcyF4jeW+oqUn3St8pzKhAH8DNDyS4knXqIq8Ty/sPP8xy20tUsbXsT2P86EX4XRjIVDVBcl1BpXrsrFrQgjrAS9h2Ew9LZl1oTSQiJMRREW6nSjokozs3ZNpXMdJPkitniIj8PiYm2VDmi8jFOJyF/Buc969HP63o28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104500; c=relaxed/simple;
	bh=PzAcfk1nL6XP1RiFNnEV+j7tvxSnbkEpfMxs8gx00p4=;
	h=Date:To:From:Subject:Message-Id; b=Rc5zyH0+kzW7LML1o9MzNhLAcsEHcd/2wdmn/zOrZtTp48G0hSCKxJu9zdpRP7HvOUf4kg03fwMK37/fXsb/qIx5DBmb3zHpijF0PbC58zo315IUPaK2SwpIFGtWmxvX3Jsr1GBkzlrPne0SjCEeuQl/u2/Fkj1ZK/L0ldVTjnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZI1TEHmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZI1TEHmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72784C113CD;
	Fri, 26 Apr 2024 04:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104500;
	bh=PzAcfk1nL6XP1RiFNnEV+j7tvxSnbkEpfMxs8gx00p4=;
	h=Date:To:From:Subject:From;
	b=ZI1TEHmFu0nBA7wrrNL1tNRSoYOIpBLb+bmXSkv0Bf48xDjsxWF6Rxsf00rkncHVH
	 CLkycybD8TS/8wogM5+Zz8ggPMqHU/eLEztVFpaHkHV8kFmHvsKdEWUi+uhAKrm71A
	 d2veMICDDmPwqByPFfM1ybTvxTn1rPELmS8YtRRQ=
Date: Thu, 25 Apr 2024 21:08:19 -0700
To: mm-commits@vger.kernel.org,jirislaby@kernel.org,dyoung@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash-add-prefix-for-crash-dumping-messages.patch removed from -mm tree
Message-Id: <20240426040820.72784C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: add prefix for crash dumping messages
has been removed from the -mm tree.  Its filename was
     crash-add-prefix-for-crash-dumping-messages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash: add prefix for crash dumping messages
Date: Thu, 18 Apr 2024 11:58:43 +0800

Add pr_fmt() to kernel/crash_core.c to add the module name to debugging
message printed as prefix.

And also add prefix 'crashkernel:' to two lines of message printing code
in kernel/crash_reserve.c. In kernel/crash_reserve.c, almost all
debugging messages have 'crashkernel:' prefix or there's keyword
crashkernel at the beginning or in the middle, adding pr_fmt() makes it
redundant.

Link: https://lkml.kernel.org/r/20240418035843.1562887-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c    |    2 ++
 kernel/crash_reserve.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~crash-add-prefix-for-crash-dumping-messages
+++ a/kernel/crash_core.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/buildid.h>
 #include <linux/init.h>
 #include <linux/utsname.h>
--- a/kernel/crash_reserve.c~crash-add-prefix-for-crash-dumping-messages
+++ a/kernel/crash_reserve.c
@@ -109,7 +109,7 @@ static int __init parse_crashkernel_mem(
 
 		size = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warn("Memory value expected\n");
+			pr_warn("crashkernel: Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
@@ -132,7 +132,7 @@ static int __init parse_crashkernel_mem(
 			cur++;
 			*crash_base = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warn("Memory value expected after '@'\n");
+				pr_warn("crahskernel: Memory value expected after '@'\n");
 				return -EINVAL;
 			}
 		}
_

Patches currently in -mm which might be from bhe@redhat.com are

kexec-fix-the-unexpected-kexec_dprintk-macro.patch

