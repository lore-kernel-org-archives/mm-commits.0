Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E1934B68C
	for <mm-commits@vger.kernel.org>; Tue,  4 Nov 2025 23:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762300522; cv=none; b=Di/sqDVZ3CoLkY8LtjmypVKhW+9Q1+9O0FyrRBVdEAYsfaV9STWFA/P5veKB+fp7vgDT8JE4uTqlEkIXnK2zKZkR/6TSU682zKeIJ1JqacdCdsoFN8sBkT0Qil79izsI/XV6CuFvrW4tImCTJNLMO65qlrAeCV6jt4xhKbVXIvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762300522; c=relaxed/simple;
	bh=Xy9DlHwIG0+ZkFrCOgc4iHpmX0q3azPyUuSr8dpug1s=;
	h=Date:To:From:Subject:Message-Id; b=o57gNbfd5VwITrqUDwVr75u89EYGXmVxAK5+UcVp8YE611OpMcQSO2NOe8j/61t53V2YKuQMk+WrKqEgaetA0q3NzM8/HLI8EpebAs+N94IpnFb+uu61byVfSbSswuNJA9IF3sB0DMIQ2aKRSTbg9BWOw5Ty7c2D4hxsjRIwUQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FtrleUQV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FtrleUQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E42DC4CEF7;
	Tue,  4 Nov 2025 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762300521;
	bh=Xy9DlHwIG0+ZkFrCOgc4iHpmX0q3azPyUuSr8dpug1s=;
	h=Date:To:From:Subject:From;
	b=FtrleUQV70foTOhoU84n1clzUDaXFdbIwEybZ/ZT+N5GQgUsfEh27UvxTvcq/LmKf
	 Bb04qYqugW0n6bpxZa7wUp6QM+KyYdIG5oPDH6IlE5JFdjzHSK18t7Z84gl9Ky3uSe
	 htkUaLjPSptUVmIByjaTQyspa/+HMG+hOOFSLK+M=
Date: Tue, 04 Nov 2025 15:55:21 -0800
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,david@kernel.org,zhangchujun@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-vm_util-remove-unused-variables.patch added to mm-new branch
Message-Id: <20251104235521.9E42DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/vm_util: remove unused variables
has been added to the -mm mm-new branch.  Its filename is
     selftest-vm_util-remove-unused-variables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-vm_util-remove-unused-variables.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: selftest/vm_util: remove unused variables
Date: Tue, 4 Nov 2025 14:28:55 +0800

The global variables __page_size and __page_shift are declared in
vm_util.c, but they are never used anywhere in the codebase.  This patch
removes them to clean up the source and eliminate dead code.

Link: https://lkml.kernel.org/r/20251104062855.2468-1-zhangchujun@cmss.chinamobile.com
Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~selftest-vm_util-remove-unused-variables
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -17,9 +17,6 @@
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
 
-unsigned int __page_size;
-unsigned int __page_shift;
-
 uint64_t pagemap_get_entry(int fd, char *start)
 {
 	const unsigned long pfn = (unsigned long)start / getpagesize();
_

Patches currently in -mm which might be from zhangchujun@cmss.chinamobile.com are

mm-debug-fix-missing-space-in-case-statement.patch
selftest-vm_util-remove-unused-variables.patch

