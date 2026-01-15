Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD0E27732
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509263; cv=none; b=qCbIi6pGcKIZ3jXod5rWvuFpR19ZPPhX1TS+TvNxBXkKPO8X2crOZHk5XThLlSbnqXvODlLomuVk7EdPyxOeWfr48VL3Yyj+XOXU4Hn5B3vD2MqGb24fnfh4FKNsMbqQKMgoXsh1xBwezlt2KWBrTjxUWkGW3rRn7je+gxfZFcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509263; c=relaxed/simple;
	bh=TeR0GjD2unL4pkJzWxq/l1c4xZyk1qjg7xiziUQSWXY=;
	h=Date:To:From:Subject:Message-Id; b=GuT669MHqC5K2aN2OXDefdLwKsjjwRscWx+JF0SLIc+rCQrQwL46BvtdLHfSUjPzdGfRzR9CeXLKArBn1jIlsXr+TL85vhWon2ZORLRSgLxKbrFOd4l8409oUlvKBJgU8xx/p++Ht1rh5jEpwCbJdC4cKLuCWykwNatNthCVQMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qproIfu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qproIfu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BACC116D0;
	Thu, 15 Jan 2026 20:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768509262;
	bh=TeR0GjD2unL4pkJzWxq/l1c4xZyk1qjg7xiziUQSWXY=;
	h=Date:To:From:Subject:From;
	b=qproIfu2kQSI/Rb6kLkiCF5FsUGHSwTX5lYGptUCKLOulnhr1FKYX9nSXnP4XdpJo
	 f7GP0vVRur9TFO4ME0+VTpzGQODM2cwkEag08NpcFrkNmSVHuQ8cZXIU2bt4I0sUtX
	 1crT8Fna97Ei72AMQ4Kmad9jnk+yDzK+F+AAsr0w=
Date: Thu, 15 Jan 2026 12:34:22 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,manish1588@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-drop-filename-from-page_allocc-header-comment.patch added to mm-new branch
Message-Id: <20260115203422.B9BACC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: drop filename from page_alloc.c header comment
has been added to the -mm mm-new branch.  Its filename is
     mm-drop-filename-from-page_allocc-header-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-drop-filename-from-page_allocc-header-comment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Manish Kumar <manish1588@gmail.com>
Subject: mm: drop filename from page_alloc.c header comment
Date: Fri, 16 Jan 2026 01:01:00 +0530

The file name in the header comment is redundant and not useful, as the
location is already known from the path.  Remove it to align with kernel
coding style.  No functional change.

Link: https://lkml.kernel.org/r/20260115193100.116109-1-manish1588@gmail.com
Signed-off-by: Manish Kumar <manish1588@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c~mm-drop-filename-from-page_allocc-header-comment
+++ a/mm/page_alloc.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  linux/mm/page_alloc.c
  *
  *  Manages the free list, the system allocates free pages here.
  *  Note that kmalloc() lives in slab.c
_

Patches currently in -mm which might be from manish1588@gmail.com are

mm-drop-filename-from-page_allocc-header-comment.patch

