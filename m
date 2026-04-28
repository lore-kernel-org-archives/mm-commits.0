Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEADD37F8DF
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777388235; cv=none; b=YlI+uWvAjtYHCL9Hkm0YeLAFLQU8cl83ORxmk0SpxBvE+bZy5DIfJbreAIcdKgoJX3IXnZTDW7a/jFVYZPhBWIvNQTqo5S5bAyPkiwt1A2869CprZ3UxA9fkRSWzgzf/0qt8xOKotDOJll9oxq0Rj5Qj5soP1RiJ/eJs2jiR0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777388235; c=relaxed/simple;
	bh=ngbfE2sQPbTri5X9CCqFtcb07oaBz8tQmNVAzqxOetw=;
	h=Date:To:From:Subject:Message-Id; b=bdY6U7JSEcJGcc5a7afB9bagUS7fbdMlRl2SWGfsAywxVOss8R8kt3IMEPiWTSP/UfY6PR17afjvb9GNXUb9CbSjwrk3+BNPE7iRVq8kHyTmxWBaDsVOjrpY4W4dwwhFl8Xv1kQz9kdB9IF66ybkMoOoj9a106JwARHFMIEjwIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yeq9J5VC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yeq9J5VC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5862FC2BCAF;
	Tue, 28 Apr 2026 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777388234;
	bh=ngbfE2sQPbTri5X9CCqFtcb07oaBz8tQmNVAzqxOetw=;
	h=Date:To:From:Subject:From;
	b=yeq9J5VCDeJ6+0MG3B9glo4OBkVknymO5Oq0ddV63fiP6EvBikAgLO9axaBl1VDs7
	 YHW7xYZRspN3nVuuOjVfLVmMIKl7K1xbv69tComIr2iR39F+VDvmhRlEymCEeS8lri
	 3XRxCkUykjIwuS0DRP02vyW6wFL1R27ol+NHhaxc=
Date: Tue, 28 Apr 2026 07:57:13 -0700
To: mm-commits@vger.kernel.org,ruirui.yang@linux.dev,pratyush@kernel.org,pasha.tatashin@soleen.com,ebiederm@xmission.com,baoquan.he@linux.dev,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-tree-for-kdump-and-kexec.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428145714.5862FC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add tree for KDUMP and KEXEC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-tree-for-kdump-and-kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-tree-for-kdump-and-kexec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add tree for KDUMP and KEXEC
Date: Tue, 28 Apr 2026 15:48:32 +0300

Patch series "MAINTAINERS: update KEXEC, KDUMP and LIVE UPDATE".

KHO and LiveUpdate team is going to pick kdump and kexec patches to
their tree at
    
https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git

Update MAINTAINERS to reflect this change and add kexec@ list to LIVE
UPDATE entry.


This patch (of 2):

KHO and LiveUpdate team is going to pick kdump and kexec patches to their
tree at

https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git

Update MAINTAINERS to reflect it.

Link: https://lore.kernel.org/20260428124833.1903302-1-rppt@kernel.org
Link: https://lore.kernel.org/20260428124833.1903302-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, 
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-tree-for-kdump-and-kexec
+++ a/MAINTAINERS
@@ -13860,6 +13860,7 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 R:	Dave Young <ruirui.yang@linux.dev>
 L:	kexec@lists.infradead.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	Documentation/admin-guide/kdump/
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
@@ -14176,6 +14177,7 @@ M:	Pasha Tatashin <pasha.tatashin@soleen
 M:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	include/linux/kexec.h
 F:	include/uapi/linux/kexec.h
 F:	kernel/kexec*
_

Patches currently in -mm which might be from rppt@kernel.org are

sh-fix-fallout-from-zero_page-consolidation.patch
maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch

