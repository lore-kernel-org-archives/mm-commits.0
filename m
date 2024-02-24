Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DAD79F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739407; cv=none; b=FKndFVnojC/X6e/8HG0RQcr9I6EALCWj/b+qpKF9UdYbEWSGtijgLnEpPHwX7bCY/laFwb5frseTgHMVsrJLpx5LOeMjYTpqne80aCt5RgzEXIC1BJN82KegC2NrOngfVrikOhljXU6LkccY65qp645WGUPrxM6i5P9knounj3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739407; c=relaxed/simple;
	bh=OkcBHTWffQsA+G+ct8fMZfZCt/y8FqR348MLgcKpvY0=;
	h=Date:To:From:Subject:Message-Id; b=goiXXS4E74BZrH1DI/dum2/+LZ3Ztfj/PgIRxCroTK4pFi1h/bIrkuPix10XtVcOtsZxSgJkyGvmUhSqVc2HRs9raB0ildG3BvbIAbF1Yb5W6D+nk1ayXjGS2kYYIirmyWWDjQVXtZEm72nafSnKpC9ZeeW/xteLfHFjEEwuj4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJRVrBDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJRVrBDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A1C433C7;
	Sat, 24 Feb 2024 01:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739406;
	bh=OkcBHTWffQsA+G+ct8fMZfZCt/y8FqR348MLgcKpvY0=;
	h=Date:To:From:Subject:From;
	b=DJRVrBDaLlpd1U8e6LbjPcYqYjbPqWsKjOEUW5779rChNWu5ZO2QoxR+bvmPW73C9
	 uqzv8ii5enTd3wNO5DoQCs9VmF1QnD1gKxgLGewbhAXbRLJn5tsA4973QSLBC513sD
	 Ji4lMZqfaIcM7UE3f9jeYTO5+zLfVIC/odN6Tecw=
Date: Fri, 23 Feb 2024 17:50:06 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch removed from -mm tree
Message-Id: <20240224015006.B93A1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: loongarch, crash: wrap crash dumping code into crash related ifdefs
has been removed from the -mm tree.  Its filename was
     loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: loongarch, crash: wrap crash dumping code into crash related ifdefs
Date: Wed, 24 Jan 2024 13:12:54 +0800

Now crash codes under kernel/ folder has been split out from kexec
code, crash dumping can be separated from kexec reboot in config
items on loongarch with some adjustments.

Here use IS_ENABLED(CONFIG_CRASH_RESERVE) check to decide if compiling
in the crashkernel reservation code.

Link: https://lkml.kernel.org/r/20240124051254.67105-15-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/setup.c~loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs
+++ a/arch/loongarch/kernel/setup.c
@@ -260,7 +260,7 @@ static void __init arch_reserve_crashker
 	char *cmdline = boot_command_line;
 	bool high = false;
 
-	if (!IS_ENABLED(CONFIG_KEXEC_CORE))
+	if (!IS_ENABLED(CONFIG_CRASH_RESERVE))
 		return;
 
 	ret = parse_crashkernel(cmdline, memblock_phys_mem_size(),
_

Patches currently in -mm which might be from bhe@redhat.com are


