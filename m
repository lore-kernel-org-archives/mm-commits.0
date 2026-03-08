Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF042475D0
	for <mm-commits@vger.kernel.org>; Sun,  8 Mar 2026 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773005741; cv=none; b=QXWJc0ctOanbt9HVLOyZoYO2wJmJ4CBZHPaBs5dLyUPcwD0xv6X8RLXztya+nVFwcH9cpHwQB+Wg7IXuHXrJ+dCZWx0gGLRvACFuHT2+svZNVWO6Qhry4Mdc9TX2wzSVuyoX8vEdoeI3Z1sSVyk2luDsBRP4tpnhn4Iw9hJgqRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773005741; c=relaxed/simple;
	bh=w3e4TX3Cn4dop7xNlD9DpXnZoC1CX9rOBtRGu6sYjuI=;
	h=Date:To:From:Subject:Message-Id; b=Ft8fXEyzgdITAaMUcphlf3x8cjJaFAomKsyh0ilVLBZTnWYnIOM6F8t32COHmeemuKfrLBQICEy/wSj5pIk2QEgk9+4U7n7l1hIGfntjXkjJJez4SdzQ1Cidi1OBNMvfpscbAsvAcBPg0tV4zhObKMJpCbhu0p8X75sOuidoySo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdBAXfoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdBAXfoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5DDC116C6;
	Sun,  8 Mar 2026 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773005741;
	bh=w3e4TX3Cn4dop7xNlD9DpXnZoC1CX9rOBtRGu6sYjuI=;
	h=Date:To:From:Subject:From;
	b=gdBAXfoNIXFh+8uwg5amFgG5j6T+rQDWz0vJ+G8wv3zYBibxzCs4x6jJolPSG6cNU
	 u4XVcOsr1/03cbtxYBrhvCgGAPKFqJz6p0H+f3trgRKUgLgNDnDELrQ9to0xDsBh0K
	 jIPMdA9fS1gHL8QhkeW6RXs//Rcn4Xejn6PboqJI=
Date: Sun, 08 Mar 2026 14:35:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-droppable-mappings-from-being-locked-fix.patch added to mm-new branch
Message-Id: <20260308213541.5A5DDC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-prevent-droppable-mappings-from-being-locked-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-prevent-droppable-mappings-from-being-locked-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-droppable-mappings-from-being-locked-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm-prevent-droppable-mappings-from-being-locked-fix
Date: Sat, 7 Mar 2026 13:23:50 -0800

fix build

Link: https://lkml.kernel.org/r/dae49547-48d9-4abd-9fb1-05250fcd7d23@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202603070433.MUXyiGWN-lkp@intel.com/
Closes: https://lkml.kernel.org/r/aaujSXGjGBv5NVAD@rli9-mobl
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/vma/include/dup.h~mm-prevent-droppable-mappings-from-being-locked-fix
+++ a/tools/testing/vma/include/dup.h
@@ -350,6 +350,9 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* This mask prevents VMAs from being mlock'd */
+#define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
+
 #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0)
 
 #define VM_DATA_FLAGS_TSK_EXEC	(VM_READ | VM_WRITE | TASK_EXEC | \
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

mm-prevent-droppable-mappings-from-being-locked.patch
mm-prevent-droppable-mappings-from-being-locked-fix.patch

