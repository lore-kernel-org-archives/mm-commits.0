Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B3A14C5AA
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 03:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742356425; cv=none; b=ivUwqjSvty02mftmOL4knJgxaNWfvUfYa9s1hqqROEGTKF9T4y8R96Jr1zolJ3CSB06hyZqBbHCP1kYu3h+G3YMIkEv4UfYXBkmqIGJUqoU7LOFImFohslg2i0jHKCwV/VwwPlKWBeTZDqUGr9gZXwTVSnENRb78eCEMJEHOI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742356425; c=relaxed/simple;
	bh=/YOMjx9dHX6UtpxygBEeod2SBi0Jcef/uSn+hfxjugY=;
	h=Date:To:From:Subject:Message-Id; b=iMJ4gLXWw8lO3SluaMW/z26w0HIBKqT0N/QaTqdQw4UWmfs9NBpZ6TMpmZv0M0dPMfYnRf4ELwVtcxhy8VkSSGjgRPaoIBCd28TfSUf91zuAx0TaQzHbNrltPj7rrNiKkaRcANLGW7czkEdeFZ+eqkbq3VBaLIl0jW6KGjaa2PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P9ENYKQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P9ENYKQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77170C4CEEA;
	Wed, 19 Mar 2025 03:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742356424;
	bh=/YOMjx9dHX6UtpxygBEeod2SBi0Jcef/uSn+hfxjugY=;
	h=Date:To:From:Subject:From;
	b=P9ENYKQTHSf3WGPIqFgddc6fvxu9owRicjJiEIPGmZVW2Gz8Smx907csR3ppLcdBr
	 ihxoSUivQ2LPTjysd6miFT3HWxowMaiq0zZyEeZpQgiMB1YNjd6f11rzzcBaE6WxH0
	 RiaxNpQ1x0qIMb9J1CEGVk2rs2sUQYF3m74Imqcs=
Date: Tue, 18 Mar 2025 20:53:43 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch added to mm-unstable branch
Message-Id: <20250319035344.77170C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: document Balloon Meminfo entry
has been added to the -mm mm-unstable branch.  Its filename is
     meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch

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
From: Nico Pache <npache@redhat.com>
Subject: Documentation: document Balloon Meminfo entry
Date: Mon, 17 Mar 2025 16:07:18 -0600

Add a Balloon entry to the Meminfo documention.

Link: https://lkml.kernel.org/r/a0315ccf-f244-460e-8643-fd7388724fe5@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/filesystems/proc.rst~meminfo-add-a-per-node-counter-for-balloon-drivers-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1081,6 +1081,7 @@ Example output. You may not have all of
     FilePmdMapped:         0 kB
     CmaTotal:              0 kB
     CmaFree:               0 kB
+    Balloon:               0 kB
     HugePages_Total:       0
     HugePages_Free:        0
     HugePages_Rsvd:        0
@@ -1255,6 +1256,8 @@ CmaTotal
               Memory reserved for the Contiguous Memory Allocator (CMA)
 CmaFree
               Free remaining memory in the CMA reserves
+Balloon
+              Memory returned to Host by VM Balloon Drivers
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepagesize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
 DirectMap4k, DirectMap2M, DirectMap1G
_

Patches currently in -mm which might be from npache@redhat.com are

meminfo-add-a-per-node-counter-for-balloon-drivers.patch
meminfo-add-a-per-node-counter-for-balloon-drivers-fix.patch
balloon_compaction-update-the-nr_balloon_pages-state.patch
hv_balloon-update-the-nr_balloon_pages-state.patch
xen-balloon-update-the-nr_balloon_pages-state.patch
documentation-add-unaccepted-meminfo-entry.patch

