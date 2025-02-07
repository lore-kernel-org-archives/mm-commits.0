Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D96C185B67
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 03:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738899704; cv=none; b=KtHknwI4XC750ZGsEBgQK7oGZNUy7CuHIAxriS7cYUzuc1EC8Ngi8NQg+tKvTWtN6tTuDK8HyoveK1hie8XE8LQTKalcGh9XEmLz5orkScOfLYZiOfuZ+DQmyc26mjnb0x4UKF/MqLrorUR4dpvNAOTkWzgaCg3uDzqXgJjHllI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738899704; c=relaxed/simple;
	bh=4cI+SQZEwINSlG8FTomzkr0QkSPiIZGamAGtU0JAiwM=;
	h=Date:To:From:Subject:Message-Id; b=CJ5LopxTJQKQ9/MB8Zs/vchTh6k7AcE7oxo5hyZf9JPx1xn7osM9t8HbDd1m9CCjYtFOSt4wuDlN3HCSxtPDWRiJntWjqI5/NvYO7uWy0tDNvyKhmvxr29CqIS+bD4xIncrkwRU1LxJC3STFS6sUIQXY7d0sa24yPCyi8GKj13k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eZXZ25/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eZXZ25/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11D7C4CED1;
	Fri,  7 Feb 2025 03:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738899703;
	bh=4cI+SQZEwINSlG8FTomzkr0QkSPiIZGamAGtU0JAiwM=;
	h=Date:To:From:Subject:From;
	b=eZXZ25/j7wdpNxVtF9DGUDd3FXQvrqIodjMo/XEIrBQ+Oxia+KalnzxbMTGoihND/
	 ujbO/koO5+3kdcff3qrmElJo2U7Vj+do2jIG/HlmFzy9cDzd/xTzfFfd6zqqFISMtb
	 fB5SrZiabDUJGEW/OsyR7HXnx8dWYw0JEEQKeXnQ=
Date: Thu, 06 Feb 2025 19:41:42 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tzimmermann@suse.de,soci@c64.rulez.org,simona.vetter@ffwll.ch,mcanal@igalia.com,lorenzo.stoakes@oracle.com,jayakumar.lkml@gmail.com,deller@gmx.de,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch added to mm-unstable branch
Message-Id: <20250207034142.F11D7C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
has been added to the -mm mm-unstable branch.  Its filename is
     fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
Date: Thu Feb  6 07:40:04 PM PST 2025

fix fb_err() call

Cc: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Kajtar Zsolt <soci@c64.rulez.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Maíra Canal <mcanal@igalia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -133,7 +133,7 @@ static vm_fault_t fb_deferred_io_fault(s
 		return VM_FAULT_SIGBUS;
 
 	if (!vmf->vma->vm_file)
-		fb_err("no mapping available\n");
+		fb_err(info, "no mapping available\n");
 
 	BUG_ON(!info->fbdefio->mapping);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

