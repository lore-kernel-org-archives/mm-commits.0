Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A31E5724
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 05:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773034335; cv=none; b=GGL/mLQsSWVgrcgks6auXXgLj9BDA41+vLPcJUCKE9WkraZlGuuZeS/ccGhH/cRsoCa2VDKR90S7MA/wwWz8i1fLi2+ORcrIdKHeNSYS4BsuJi+m3GJQWefUVfj5QNrRUTC4wSFHN4tC94woYAQ2T+k2diGycRP6bjvZj0ugBhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773034335; c=relaxed/simple;
	bh=q55Ezu53LF2JoaM7pgtvj/PcW0f9uc49G8zZpyrYvQo=;
	h=Date:To:From:Subject:Message-Id; b=WnjXmZ/CypiDZj0xvS0Rq1V/3sEwt/VRw1WTQQhWXGDOw7/yJdwMD7vmDw/BkcpKfCFoWhTwQ2E/c6UIyKJpPJA0uaSrjAWX9toPFiL1kDxBS94LzUg8BjkJNeQLEoJQ9ysUMBrWcnefBcfDff/KfQ09+qrZimMBYrfnWEiJdhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSzthk9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSzthk9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A0AC4CEF7;
	Mon,  9 Mar 2026 05:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773034335;
	bh=q55Ezu53LF2JoaM7pgtvj/PcW0f9uc49G8zZpyrYvQo=;
	h=Date:To:From:Subject:From;
	b=dSzthk9UfwrTKk5S8EOyn0Gcywf43ITDiKXJz37X9orblt1QyTJIRkz/uyyCxnDgA
	 FHsZs9ey1nu0C3xGNrGuoWlNVtfQ4lj7Pm675DlfxRbZdTKqgUediF8Vk85++9WGFo
	 yC8P01BGitk7RfkbckIo7DZFT3VvBaBckLFWI1oQ=
Date: Sun, 08 Mar 2026 22:32:14 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch added to mm-new branch
Message-Id: <20260309053215.48A0AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-prevent-droppable-mappings-from-being-locked-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-droppable-mappings-from-being-locked-fix-fix
Date: Sun Mar  8 10:28:48 PM PDT 2026

fix non-ascii junk from email demessification

Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/vma/include/dup.h~mm-prevent-droppable-mappings-from-being-locked-fix-fix
+++ a/tools/testing/vma/include/dup.h
@@ -351,7 +351,7 @@ enum {
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
 /* This mask prevents VMAs from being mlock'd */
-#define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
+#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
 
 #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

