Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E4E2E645
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 01:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749518513; cv=none; b=ssP+452VcDVrMWa3uUZVeBxipdGqHHk8v+OjDVCed5xmU54WAHcf6JoyA+ZcFytbWsziR7wYn9QPveFopU4KNpnnWgBlvGTYwmM3kwgcFLAbO+X5inULTeU2b01PN1vX6XF4TSO85reeuTHWCQZJNGOL6qpgmsiIEz7ctBuJExA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749518513; c=relaxed/simple;
	bh=whIkTBX2bjkKElp/ZAEQ94U86ey6waAkcllkdKyKUIU=;
	h=Date:To:From:Subject:Message-Id; b=JqdSF7H/D+4tX3fm4IQZlPRxNlLZHTGIdzDefcsO07A6X2oPvOYI1g4D6GmMBEzIxWERRM9jRu/g/05R8HlXtn43Do4H+b8DjXqYUDS9hRBll6xoSJilKpmm3TFQ0hD4H92W2TSgK6MSkSuG6ixCg5W+H3lauKG1UNcX1S17yXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uH0vI8as; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uH0vI8as"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0CDC4CEEB;
	Tue, 10 Jun 2025 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749518513;
	bh=whIkTBX2bjkKElp/ZAEQ94U86ey6waAkcllkdKyKUIU=;
	h=Date:To:From:Subject:From;
	b=uH0vI8asQCplzgTInDS4lXTDk3XC8jp11D5yDyusedxJeKrsu5CvZLfCKIENmi/E7
	 4GkLANnH0PclJ9y2GeEfjDG1yQGlDpKYk4OouhEy4U/mvJZEPnQYf8jRgTNP5yqgIp
	 0w8BSrYdaUSkmFbSABvuVSTgVngLOFjg/o8Icu8w=
Date: Mon, 09 Jun 2025 18:21:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20250610012153.4B0CDC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
Date: Mon Jun  9 06:17:45 PM PDT 2025

export compat_vma_mmap_prepare tp fix build

ERROR: modpost: "compat_vma_mmap_prepare" [fs/coda/coda.ko] undefined!
ERROR: modpost: "compat_vma_mmap_prepare" [drivers/gpu/drm/i915/i915.ko] undefined!

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/util.c~mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix
+++ a/mm/util.c
@@ -1170,3 +1170,4 @@ int compat_vma_mmap_prepare(struct file
 
 	return 0;
 }
+EXPORT_SYMBOL(compat_vma_mmap_prepare);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-proc-update-vmflags-documentation-in-smaps-fix.patch
drivers-rapidio-rio_cmc-prevent-possible-used-uninitialized.patch
mm-add-mmap_prepare-compatibility-layer-for-nested-file-systems-fix.patch
mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch

