Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62422989B5
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773861810; cv=none; b=RRCMzXdt1YOfVIWxdWCrxgj9yOxYLSeuMjia4nD4L1TVpXu3xb2o885EDV8KDCK6pm3k6/26wPdzygo06ZRRSULvWYe5xmZl0VZFP3iYTXifdY+8taYjGDn606enxQxg8nbgenuOTN3PvByNn478mpBDqQinZwnZYrMh+TUjXbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773861810; c=relaxed/simple;
	bh=cvB7otWsSavA13MWqGRK8SkNhQZC7SrVNrUqevc54g4=;
	h=Date:To:From:Subject:Message-Id; b=XNj1evURdr2G1JSJMi7wgDUh1M2HIyuOlBhnh3iebrE3+i8RsuIXhh1b+DUyfmRfs7/2A/d8LNDqxo1QQGAIxVty1mo8z65ympPXhZjCjXCJ6L6FCEOrpbbxeWWulX8jSygZs0BrefcUd0iki1DKy03ETpfB80G9SS+IiyBBRSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A89fu+fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A89fu+fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633DDC19421;
	Wed, 18 Mar 2026 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773861810;
	bh=cvB7otWsSavA13MWqGRK8SkNhQZC7SrVNrUqevc54g4=;
	h=Date:To:From:Subject:From;
	b=A89fu+fPDuyuyJZuvgu0pKDZJEwwQm4tnsdsB70n+WCMvsL2KDbGpQNc2XnouTy4c
	 jXLGInbH93DEbkh3/tHlK41hJ+6dxMDnD1nAy8i8sI+jQbR/UNy7T19C2UGVjlrOQ4
	 Smm2Dz8MNi+7SBP+SZ+D0V5DavOF94ll7IQG0dkE=
Date: Wed, 18 Mar 2026 12:23:29 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-remove-duplicate-include-of-swap_tableh.patch added to mm-new branch
Message-Id: <20260318192330.633DDC19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swapfile: remove duplicate include of swap_table.h
has been added to the -mm mm-new branch.  Its filename is
     mm-swapfile-remove-duplicate-include-of-swap_tableh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-remove-duplicate-include-of-swap_tableh.patch

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
From: Chen Ni <nichen@iscas.ac.cn>
Subject: mm/swapfile: remove duplicate include of swap_table.h
Date: Wed, 18 Mar 2026 12:38:49 +0800

Remove duplicate inclusion of swap_table.h in swapfile.c to clean up
redundant code.

Link: https://lkml.kernel.org/r/20260318043849.399266-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-remove-duplicate-include-of-swap_tableh
+++ a/mm/swapfile.c
@@ -48,7 +48,6 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
-#include "swap_table.h"
 #include "swap.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are

selftests-mm-remove-duplicate-include-of-unistdh.patch
mm-swapfile-remove-duplicate-include-of-swap_tableh.patch

