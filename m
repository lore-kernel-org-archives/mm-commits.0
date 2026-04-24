Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AED3290B0
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777033388; cv=none; b=BZ3bI/I8PJCFP6pgHwKuir/FvbHlhdTwh+oDzYjnCDWVRyqZNeQKTA9oIp3GbvxGzVrwUL10Xjztygv+PIXPr9dw+lNv6o3aGrsUVDvMGdHcZmW6wR/YBPyXdZGjEeERjgimOAiMUMLTBnjddEB+T6KcdxEkFMHNGqVwxMCeWL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777033388; c=relaxed/simple;
	bh=wNfZ88c3QYxJV7+pSHS1YEDI+rJ116aXxf5WhZnnqqM=;
	h=Date:To:From:Subject:Message-Id; b=hFU1Qzb/gcqzCLRpWFvPcoBgH0/WwmJWhH2wlSd0XqWH4X4hiRiZMYr1gNlhwuRo3olsSeuW6LZgF84RigOLcUOpchXe3G75YGNGwGnU07eyAxUzWVRDddfFlnq1cGiZ7EReLkS3YaFBrWcF6hXNI1la5ROSWZLdGyBpva7ij8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iwa2k44A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iwa2k44A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B01C19425;
	Fri, 24 Apr 2026 12:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777033388;
	bh=wNfZ88c3QYxJV7+pSHS1YEDI+rJ116aXxf5WhZnnqqM=;
	h=Date:To:From:Subject:From;
	b=Iwa2k44ASm4W/mwUDq7sGfvlB2WsjalcDMDqop+s99GRgd6Vd4OU8LIJ/WGsxymp9
	 UJQBpAg7dGxcy3roGft4EXHAoLuttN0DaQzTt+7sNwrDn/j53N6S8zHy48ThAtOsXH
	 I/Ilp3HY23HdgjYEHOu1v883mHgvmZ7n13RTFAKs=
Date: Fri, 24 Apr 2026 05:23:07 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,dyoung@redhat.com,baoquan.he@linux.dev,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-stale-kdump-project-url.patch added to mm-hotfixes-unstable branch
Message-Id: <20260424122308.11B01C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: remove stale kdump project URL
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-remove-stale-kdump-project-url.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-stale-kdump-project-url.patch

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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: MAINTAINERS: remove stale kdump project URL
Date: Sat, 18 Apr 2026 13:32:26 +0530

The kdump project URL in MAINTAINERS points to
http://lse.sourceforge.net/kdump/, but it is no longer maintained.

Remove this outdated link to avoid confusion and keep the file
up to date.

Discussion to remove this link:
https://lore.kernel.org/all/e1e9e200-17d7-4ae9-b0eb-71300f4eb1ac@linux.ibm.com/

Link: https://lore.kernel.org/20260418080226.40415-1-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-stale-kdump-project-url
+++ a/MAINTAINERS
@@ -13865,7 +13865,6 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 R:	Dave Young <ruirui.yang@linux.dev>
 L:	kexec@lists.infradead.org
 S:	Maintained
-W:	http://lse.sourceforge.net/kdump/
 F:	Documentation/admin-guide/kdump/
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

maintainers-remove-stale-kdump-project-url.patch

