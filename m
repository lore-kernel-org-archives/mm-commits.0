Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7821A262D;
	Thu, 20 Aug 2026 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787265441; cv=none; b=efj7wqKb73a4Xy3entawoyQe6RkkbavyH1PLb6GbW5X9/Cif7fwxA547qfN0xFTgn3le2O9GuLz9FUd9t8cq5Ku6ykdMlrcCth7lYWrOwZHtSZGab+F7m5KeEIeY80i9B9T/bBS8nB0JXtSN6EiZIkJhA8bC6C+dAjaSBxWJFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787265441; c=relaxed/simple;
	bh=GNh1oKIqh1hYIXNfY62No/2QEQy26mL/OGvmGJICiHM=;
	h=Date:To:From:Subject:Message-Id; b=RB8EjKk7bNh3C7RN2fILG2yi5QN5Qv3wSGukqAj5GA4tU5MYFww10cJGN+X1sO4rwO3CB8jca0M+QaZn3ngtGQUXHb/KEcbjroVxJ4Unx27zaqKAUmHMMiMl12g66kn3MOlEeSSlEVLEHC5U19CRXD5Z9qbHWXwmAtNqzkheokc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xK/zJ4wz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xK/zJ4wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A3C1F000E9;
	Thu, 20 Aug 2026 22:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787265439;
	bh=aR7QFhU2qyyqWdWg7WWSdTugbKcWOxnWP7sqGWbushs=;
	h=Date:To:From:Subject;
	b=xK/zJ4wztatdgR/B8NQbYzjbFu//GilTvJbqL0RCpTWt7Dxo0g6OZs35knQzUjgcd
	 0S1CCwc/TGBkBg7VMeTM3IkMBCeK2AdkfwrIOYVnl0WAXtMTfD22kxYOfyy24OKEjL
	 CRWh9uE6yNnhcj52utOIANrvoYUm3JM+BXStF6HU=
Date: Thu, 20 Aug 2026 15:37:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stern@rowland.harvard.edu,stable@vger.kernel.org,gregkh@linuxfoundation.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch added to mm-nonmm-unstable branch
Message-Id: <20260820223719.A4A3C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: USB: gadgetfs: do not WARN about excessively large memory allocations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Zi Yan <ziy@nvidia.com>
Subject: USB: gadgetfs: do not WARN about excessively large memory allocations
Date: Thu, 20 Aug 2026 09:19:12 -0400

GadgetFS passes an excessively large user input len to kmalloc and kmalloc
gives a WARN (see below for details).  Suppress it by passing __GFP_NOWARN
to kmalloc used by both ep_write_iter() and ep_read_iter().  Follow the
same method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about
excessively large memory allocations").

kmalloc is used to allocate physically contiguous memory for kernel
allocations.  For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc
uses the page allocator and can only support up to KMALLOC_MAX_SIZE.  For
request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
WARN because kmalloc allocates an order greater than MAX_PAGE_ORDER.

Link: https://lore.kernel.org/DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com
Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast=
 path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@googl=
e.com/
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/legacy/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/legacy/inode.c~usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -604,7 +604,7 @@ ep_read_iter(struct kiocb *iocb, struct
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
xarray-honor-xa_flags_account-in-xas_split_alloc.patch
usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

