Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2937260A
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 20:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758918364; cv=none; b=Aq9rfrVu1lx/ZtZDo9QKMvjOhzir90vT+MEQG3SFqTgPKxK1yYDJdvVajfNrtqypi7GhSvJ8Tkvy+sFfoXua9Nd/0PCCKpx5NQp7r3mCMVEp1iUfEAxZEaeG5+4bzCD6F47zt/MbZUjhZ8DDpkWnxXrEbfY4EU2a9VxxH1WKBlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758918364; c=relaxed/simple;
	bh=6AAYsA2dgwiyNNid0pam2+n3WUdnV885foKfWdxqAfQ=;
	h=Date:To:From:Subject:Message-Id; b=fBLRDT/e7Wrd/s6iy7K/KPghw/X7Dwhq19bzsEprB/OZwiMbzH8UW+nWl+SFBeLBO8k1nikDFPPWmQa32mkL2CMPzYP0bwKrPkXlDBn2cv5ctW2HRmZQ+4vtgKuYezRW1XfqbUUG400olVmicKK5hJ4FruXC4mTXhFqO32WJv9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d0RZu2ah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d0RZu2ah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07346C4CEF4;
	Fri, 26 Sep 2025 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758918363;
	bh=6AAYsA2dgwiyNNid0pam2+n3WUdnV885foKfWdxqAfQ=;
	h=Date:To:From:Subject:From;
	b=d0RZu2ahZ73QnwucxDppwHfvM+hQpe1sEW1nJwdPl2cE/M30tU2c3fVbAF/JrUMI/
	 nCk0aE++yUTzZG2UXaEoGickKXKBjsMssLBThufd14z1Ic0klVgei1NkPbugOfJw0W
	 7nbbVcB/3jJs3VFzrNaKHzHvqQuRN+jkXYGnyPFI=
Date: Fri, 26 Sep 2025 13:26:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david.hunter.linux@gmail.com,chandna.linuxkernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kallsyms-use-kmalloc_array-instead-of-kmalloc.patch added to mm-nonmm-unstable branch
Message-Id: <20250926202603.07346C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kallsyms: use kmalloc_array() instead of kmalloc()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kallsyms-use-kmalloc_array-instead-of-kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kallsyms-use-kmalloc_array-instead-of-kmalloc.patch

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
From: Sahil Chandna <chandna.linuxkernel@gmail.com>
Subject: kallsyms: use kmalloc_array() instead of kmalloc()
Date: Fri, 26 Sep 2025 13:20:53 +0530

Replace kmalloc(sizeof(*stat) * 2, GFP_KERNEL) with kmalloc_array(2,
sizeof(*stat), GFP_KERNEL) to prevent potential overflow, as recommended
in Documentation/process/deprecated.rst.

Link: https://lkml.kernel.org/r/20250926075053.25615-1-chandna.linuxkernel@gmail.com
Signed-off-by: Sahil Chandna <chandna.linuxkernel@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms_selftest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kallsyms_selftest.c~kallsyms-use-kmalloc_array-instead-of-kmalloc
+++ a/kernel/kallsyms_selftest.c
@@ -264,7 +264,7 @@ static int test_kallsyms_basic_function(
 	char namebuf[KSYM_NAME_LEN];
 	struct test_stat *stat, *stat2;
 
-	stat = kmalloc(sizeof(*stat) * 2, GFP_KERNEL);
+	stat = kmalloc_array(2, sizeof(*stat), GFP_KERNEL);
 	if (!stat)
 		return -ENOMEM;
 	stat2 = stat + 1;
_

Patches currently in -mm which might be from chandna.linuxkernel@gmail.com are

kallsyms-use-kmalloc_array-instead-of-kmalloc.patch

