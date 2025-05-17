Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FF1101C8
	for <mm-commits@vger.kernel.org>; Sat, 17 May 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747495742; cv=none; b=WwhKBaQGNZ64CT2ZajwPw2g2zlAvio3MfR77HswfQWjY7PMHYlxz8vNw7gmsseD5k12sJzn2JcxHW6GSPNrYku2k0PN/ZbcU6mYI8YVC6OilEl5hG374rPwq4Aq0EffYHMm93DvIOXCiNJZDgPPraw604+6NcgEN7GMvyeA9uZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747495742; c=relaxed/simple;
	bh=+rNRVXfTkPWlkzB/GwBn6GTw7/FtMqfBuX9WadW1Ljc=;
	h=Date:To:From:Subject:Message-Id; b=L33I87bOuzikdc3SEAZcGUUdkx9LtcM8o0828xN/KNx4+FawIXd6qNVeMcjfsAYqYthgxTEUEIG32NwCjLoIFdiH6HiK2rCps8jf3FI8XRiNNNk0S5Eah9sdotTgT4x6Afljeua+Yd1O7nfC3AnUalSGRGEIqpgkLXM2zaN7OBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2A1LBz27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2A1LBz27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF99C4CEE3;
	Sat, 17 May 2025 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747495741;
	bh=+rNRVXfTkPWlkzB/GwBn6GTw7/FtMqfBuX9WadW1Ljc=;
	h=Date:To:From:Subject:From;
	b=2A1LBz27Z0IUbi7r03bEOR6Ee3IAfIOGn0ibVylfPtx7C2BmGX9TCI4YSK40gMG9M
	 /0bJPtk4T4UtMYnJZe+fevYSCW+F0iCuHebk/TwCARND4b7hf24CyXOZe1qowZ+kEG
	 v1zKydv2sjJNksAPXgWv8YVWStOYmowyhBpCulcU=
Date: Sat, 17 May 2025 08:29:00 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@redhat.com,chengming.zhou@linux.dev,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-ksm-section.patch added to mm-hotfixes-unstable branch
Message-Id: <20250517152901.8EF99C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm ksm section
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-mm-ksm-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-ksm-section.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add mm ksm section
Date: Thu, 15 May 2025 20:04:04 +0100

As part of the ongoing efforts to sub-divide memory management
maintainership and reviewership, establish a section for Kernel Samepage
Merging (KSM) and add appropriate maintainers and reviewers.

Link: https://lkml.kernel.org/r/20250515190404.203596-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Chengming Zhou <chengming.zhou@linux.dev>
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-ksm-section
+++ a/MAINTAINERS
@@ -15562,6 +15562,21 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	mm/gup.c
 
+MEMORY MANAGEMENT - KSM (Kernel Samepage Merging)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Xu Xin <xu.xin16@zte.com.cn>
+R:	Chengming Zhou <chengming.zhou@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/ksm.rst
+F:	Documentation/mm/ksm.rst
+F:	include/linux/ksm.h
+F:	include/trace/events/ksm.h
+F:	mm/ksm.c
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-mm-ksm-section.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch
memcg-memcg_rstat_updated-re-entrant-safe-against-irqs-fix.patch

