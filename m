Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878A4145B0D
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706887243; cv=none; b=MCu68FIiuBlZYrTxwx95lECmxwoIv1/bN7758QpmydddLItWHcfkzZo4hPOc7txGBtYbqo0FgT1Oahd+PF4jMHfWk2Y76//L8Tlcxira/L70irm1+unB7r5b3/3kioeUX2xLHntQzhhlGi5aaZbcjF5jfJBzSF9bB1ETQPIx35I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706887243; c=relaxed/simple;
	bh=nAwAAKEAKodSewkwj8SwnfSCqLfvC/hcDeqIvlFDACc=;
	h=Date:To:From:Subject:Message-Id; b=AarakATeNQtwchRC9v1mfdWnmxMGYCB2te5mPiFomBlV+8dm9m+1aNwSjQz46Bxw7SRwY3DfTTPyNbCe0dwCfrDmhfB1zo16BX/MgYBdF98cNbArCQ4gyR3PfcmuLn1/vDO7z9TgfPZ6nj6NHuclFFoOdS/bmxOvRm2AN5vqqEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jD8H+PET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jD8H+PET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2C1C433F1;
	Fri,  2 Feb 2024 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706887243;
	bh=nAwAAKEAKodSewkwj8SwnfSCqLfvC/hcDeqIvlFDACc=;
	h=Date:To:From:Subject:From;
	b=jD8H+PETRi9LNHUmwmdsjI7HVJq2kGLK9nL6gNk4sg6wx032Uc9IPdYJF8GnxffIY
	 ug+Mue0N/YiiuDaw/mIcuY7puhGaklSD9pD8E+GxVWrNApZ/CCrZTly3CIUn/6VJKo
	 1eNJyZKuBUceWtMzqJqh7D9p15Gp2E8BG4v5Umlw=
Date: Fri, 02 Feb 2024 07:20:40 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch added to mm-unstable branch
Message-Id: <20240202152042.7B2C1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/dbgfs: fix bogus string length
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/dbgfs: fix bogus string length
Date: Fri, 2 Feb 2024 13:43:26 +0100

gcc correctly points out that using strnlen() on a fixed size array
is nonsense with an overlong limit:

mm/damon/dbgfs.c: In function 'damon_dbgfs_deprecated_read':
mm/damon/dbgfs.c:814:19: error: 'strnlen' specified bound 1024 exceeds source size 512 [-Werror=stringop-overread]
  814 |         int len = strnlen(kbuf, 1024);
      |                   ^~~~~~~~~~~~~~~~~~~
mm/damon/dbgfs.c:813:14: note: source object allocated here
  813 |         char kbuf[512] = DAMON_DBGFS_DEPRECATION_NOTICE;
      |              ^~~~

In fact, neither of the arbitrary limits are needed here: The first
one can just be a static const string and avoid wasting any more
space then necessary, and the strnlen() can be either strlen() or
sizeof(kbuf)-1, both of which the compiler turns into the same
constant here.

Link: https://lkml.kernel.org/r/20240202124339.892862-1-arnd@kernel.org
Fixes: adf9047adfff ("mm/damon/dbgfs: implement deprecation notice file")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-implement-deprecation-notice-file-fix
+++ a/mm/damon/dbgfs.c
@@ -808,13 +808,12 @@ static void dbgfs_destroy_ctx(struct dam
 static ssize_t damon_dbgfs_deprecated_read(struct file *file,
 		char __user *buf, size_t count, loff_t *ppos)
 {
-	char kbuf[512] = "DAMON debugfs interface is deprecated, "
+	static const char kbuf[512] = "DAMON debugfs interface is deprecated, "
 		     "so users should move to DAMON_SYSFS. If you cannot, "
 		     "please report your usecase to damon@lists.linux.dev and "
 		     "linux-mm@kvack.org.\n";
-	int len = strnlen(kbuf, 1024);
 
-	return simple_read_from_buffer(buf, count, ppos, kbuf, len);
+	return simple_read_from_buffer(buf, count, ppos, kbuf, strlen(kbuf));
 }
 
 /*
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-dbgfs-implement-deprecation-notice-file-fix.patch

