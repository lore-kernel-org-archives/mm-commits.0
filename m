Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B6317F2
	for <mm-commits@vger.kernel.org>; Sat,  9 Dec 2023 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R/iyfWTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEDFC433C7;
	Sat,  9 Dec 2023 22:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702161320;
	bh=Fw3G6PT2ycDdNfti40MCyOfY4Oi+O07T2rg1AUUdokw=;
	h=Date:To:From:Subject:From;
	b=R/iyfWTMBWen+Lqzr+nFrQLP0uyXU0kGyzHlCdJnNRwbCdr8l4VerbtopZISSQ+MU
	 8UOao2agwhBs90YXXLBmb38/6PmZr99jD1pPSBkDbXhUk9nopIceZGPPAPYUMddaIN
	 uIQudI6iXSc2t6h49b6HOaYX4ysZQyx5sXB3o2e8=
Date: Sat, 09 Dec 2023 14:35:19 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,thunder.leizhen@huawei.com,ebiederm@xmission.com,dyoung@redhat.com,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch added to mm-nonmm-unstable branch
Message-Id: <20231209223520.0CEDFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_core: Fix the check for whether crashkernel is from high memory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch

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
From: Yuntao Wang <ytcoode@gmail.com>
Subject: crash_core: Fix the check for whether crashkernel is from high memory
Date: Sat, 9 Dec 2023 22:14:38 +0800

If crash_base is equal to CRASH_ADDR_LOW_MAX, it also indicates that
the crashkernel memory is allocated from high memory. However, the
current check only considers the case where crash_base is greater than
CRASH_ADDR_LOW_MAX. Fix it.

This patch also includes some minor cleanups.

Link: https://lkml.kernel.org/r/20231209141438.77233-1-ytcoode@gmail.com
Fixes: 0ab97169aa05 ("crash_core: add generic function to do reservation")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/crash_core.c~crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory
+++ a/kernel/crash_core.c
@@ -199,7 +199,7 @@ static __initdata char *suffix_tbl[] = {
  * It returns 0 on success and -EINVAL on failure.
  */
 static int __init parse_crashkernel_suffix(char *cmdline,
-					   unsigned long long	*crash_size,
+					   unsigned long long *crash_size,
 					   const char *suffix)
 {
 	char *cur = cmdline;
@@ -268,9 +268,9 @@ static int __init __parse_crashkernel(ch
 			     unsigned long long *crash_base,
 			     const char *suffix)
 {
-	char	*first_colon, *first_space;
-	char	*ck_cmdline;
-	char	*name = "crashkernel=";
+	char *first_colon, *first_space;
+	char *ck_cmdline;
+	char *name = "crashkernel=";
 
 	BUG_ON(!crash_size || !crash_base);
 	*crash_size = 0;
@@ -440,7 +440,7 @@ retry:
 		return;
 	}
 
-	if ((crash_base > CRASH_ADDR_LOW_MAX) &&
+	if ((crash_base >= CRASH_ADDR_LOW_MAX) &&
 	     crash_low_size && reserve_crashkernel_low(crash_low_size)) {
 		memblock_phys_free(crash_base, crash_size);
 		return;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

crash_core-fix-the-check-for-whether-crashkernel-is-from-high-memory.patch

