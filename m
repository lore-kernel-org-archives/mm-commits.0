Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18328FA
	for <mm-commits@vger.kernel.org>; Sat,  8 Jun 2024 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717813024; cv=none; b=ii1icRt6y6wokVn9s2RXwvlLGN9HThkZe94WL4yJaKSpnG/ozpvB3JGsUwV4uEITZT7CeptcFG00bcio0FlDgjIEicJq9DxhFdVeguSHTz5aR0vNAUpXMYbxoezzvThyARkZp7+PNdGUzBUsFUSuNkl0lQFTGfRenge+tKaAcm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717813024; c=relaxed/simple;
	bh=t0YsZ3YArPeQG7CIEuT+qnlOv9iCZRAxAIH1jpw4HVc=;
	h=Date:To:From:Subject:Message-Id; b=E66i1x8YcVQipiTJ4qvJZDHgzyM49I25qCSC+cffM4zzcIC2HzJI7/X/ZuuQJR1kMWer2DWpQCagP9/k4AzMQq5Hl6g6F2Jyx8gEsObOUQDjq4sfx7QLN6Puyn2J+/ilEHUZmpNsQDRrXlZ6g+k0rIBS7Q/QVxx+o36HJQQDoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=afpTd59s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="afpTd59s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B641C2BBFC;
	Sat,  8 Jun 2024 02:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717813024;
	bh=t0YsZ3YArPeQG7CIEuT+qnlOv9iCZRAxAIH1jpw4HVc=;
	h=Date:To:From:Subject:From;
	b=afpTd59sNKLhA3FIqVUqPZMjGHTXIYnLsrmcRv8hOdkzzCZer0iWRMi2R6YkEi3rw
	 nlU8ZR0zuLBvYbE+16n81J3abmp+FldHTgpve+ErY68rJzjY6O0Qn2/ymV9nqPxwBW
	 35JDNdgpz+BPjZAYJUK8CCHDEn2o0BNPZ3ZwoMz8=
Date: Fri, 07 Jun 2024 19:17:03 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,haowenchao22@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-remove-header-files-which-are-included-more-than-once.patch added to mm-nonmm-unstable branch
Message-Id: <20240608021704.3B641C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: remove header files which are included more than once
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash-remove-header-files-which-are-included-more-than-once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-remove-header-files-which-are-included-more-than-once.patch

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
From: Wenchao Hao <haowenchao22@gmail.com>
Subject: crash: remove header files which are included more than once
Date: Thu, 6 Jun 2024 17:14:27 +0800

Following warning is reported, so remove these duplicated header
including:

./kernel/crash_reserve.c: linux/kexec.h is included more than once.

This is just a clean code, no logic changed.

Link: https://lkml.kernel.org/r/20240606091427.3512314-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_reserve.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/crash_reserve.c~crash-remove-header-files-which-are-included-more-than-once
+++ a/kernel/crash_reserve.c
@@ -13,7 +13,6 @@
 #include <linux/memory.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
-#include <linux/kexec.h>
 #include <linux/kmemleak.h>
 
 #include <asm/page.h>
_

Patches currently in -mm which might be from haowenchao22@gmail.com are

crash-remove-header-files-which-are-included-more-than-once.patch

