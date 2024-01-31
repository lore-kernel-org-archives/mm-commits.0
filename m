Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D212E5B
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682845; cv=none; b=PbEWoEzBeTU2ymYtwKEf7+40z3iJ8AuVz2uCKwDaV60KhdQG4LGujEWe95+DUcCtLJ8+buXbhN9Et8zBaundwoiIViy5FJ1tYQmVA+JmJWAxRmHkw8uSC7LrCeRr8zGOz3e4rlBzRE1mwryw6Tyqn+Zpx2qljl6vKVITzeY4ycI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682845; c=relaxed/simple;
	bh=fhaEPDjg+VZIX2H7hLKnA5NwGluTV9HtiydMA/SIx6g=;
	h=Date:To:From:Subject:Message-Id; b=UVHtAtKcu9YMLOHMIbXbj6y7Gaw92mxk5D85GUpwPDPtsqLyTsxp6O5KAs3E4juGzWx6W+ZsP0QsP1DAQtNWpZWrLd3cSsqNvQxtRBHmvYQNBpuVYHCjluHN09nrNuSW4m6Jva2WwDchwV8tz94SeH4x3tMsUeR0HvFxo3nhQOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxvEChbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxvEChbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C70C433C7;
	Wed, 31 Jan 2024 06:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706682844;
	bh=fhaEPDjg+VZIX2H7hLKnA5NwGluTV9HtiydMA/SIx6g=;
	h=Date:To:From:Subject:From;
	b=ZxvEChblpIW3ZHKntDweR67Zxv4eCSjA+HYY2alBcomLajclp3ilDmRG29DsUisqu
	 oIlFWd0lubuwQLvQUeP+3JHrvc5yu8aFCJ8QJ8WIT+Sgp1Z+qO1vLzv3FLaudvDGRl
	 CnW7DGDLKdSEajPabNHIVNlQGcJIYnRhaPfbxqwA=
Date: Tue, 30 Jan 2024 22:33:51 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-use-sz_8k-128k-helper-macro.patch added to mm-unstable branch
Message-Id: <20240131063403.82C70C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: use SZ_{8K, 128K} helper macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-use-sz_8k-128k-helper-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-use-sz_8k-128k-helper-macro.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: use SZ_{8K, 128K} helper macro
Date: Wed, 31 Jan 2024 11:19:13 +0800

Use SZ_{8K, 128K} helper macro instead of the number in init_user_reserve
and reserve_mem_notifier. This is more readable.

Link: https://lkml.kernel.org/r/20240131031913.2058597-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/mmap.c~mm-mmap-use-sz_8k-128k-helper-macro
+++ a/mm/mmap.c
@@ -3845,7 +3845,7 @@ static int init_user_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_user_reserve_kbytes = min(free_kbytes / 32, 1UL << 17);
+	sysctl_user_reserve_kbytes = min(free_kbytes / 32, SZ_128K);
 	return 0;
 }
 subsys_initcall(init_user_reserve);
@@ -3866,7 +3866,7 @@ static int init_admin_reserve(void)
 
 	free_kbytes = K(global_zone_page_state(NR_FREE_PAGES));
 
-	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, 1UL << 13);
+	sysctl_admin_reserve_kbytes = min(free_kbytes / 32, SZ_8K);
 	return 0;
 }
 subsys_initcall(init_admin_reserve);
@@ -3898,12 +3898,12 @@ static int reserve_mem_notifier(struct n
 	case MEM_ONLINE:
 		/* Default max is 128MB. Leave alone if modified by operator. */
 		tmp = sysctl_user_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 17))
+		if (tmp > 0 && tmp < SZ_128K)
 			init_user_reserve();
 
 		/* Default max is 8MB.  Leave alone if modified by operator. */
 		tmp = sysctl_admin_reserve_kbytes;
-		if (0 < tmp && tmp < (1UL << 13))
+		if (tmp > 0 && tmp < SZ_8K)
 			init_admin_reserve();
 
 		break;
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_set_range.patch
mm-mmap-use-sz_8k-128k-helper-macro.patch

