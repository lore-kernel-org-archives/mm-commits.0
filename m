Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC92472AA;
	Wed,  7 Oct 2026 02:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338638; cv=none; b=AJdI5BeNbRiq3egC90MieELWosJukIwEGSGJjmXP6QLX9zDkx5Vr4K65lT9NaYA40aMO/FjoOW0bG4PTci6LnczTyb5SzmSWGR0DUW5VDwPZlAK6fWklzYfGpi+CGiYBIt7hjZQQAJBnNaGbb+cC2KGOy1EuF/cH1YUbSfZjr/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338638; c=relaxed/simple;
	bh=VYKEyThAgAb/DjKoPsQEdG5o5b0nHqpr6opgslHzErc=;
	h=Date:To:From:Subject:Message-Id; b=tKO0M+CJo+JZf4y+Z1Fh8Csgm8rlLL+ImDsQEnbdy8BnVo5M/llrJC04HflRMfI+F1pUIAN+PmPXA5VkjEm6sRgE75x0P7Nh6TnI7KQO4cz0fGUVdmEFy00cbSOxeRqOiJAlrYFzpB4NubJm7ta77ZiHTQVrwJyrCpxCoY8wDDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gxW+ve6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gxW+ve6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707641F0089C;
	Wed,  7 Oct 2026 02:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338637;
	bh=64ZW5UMOfz5tAESgRfoncf2Nzah5zIP8Px4fZrAVMJs=;
	h=Date:To:From:Subject;
	b=gxW+ve6faW+u3RvhDYZiJ5R+POjX/5i8sBPldRo7qyGHmPMP5dpTVGvrWJlwmUw8h
	 TQOvGTr/28xHtc1iYo3xpkJE6zJkFkFBmak7c1BmIWiQ8jAoUODvPkCK9zJgnb7lFr
	 Uk4LG3Q6Wp3qde8ujHhTU0xsG6LkiGwMj+/sKL6Q=
Date: Tue, 06 Oct 2026 19:03:57 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,syzbot+805630f1453e490427fa@syzkaller.appspotmail.com,stern@rowland.harvard.edu,stable@vger.kernel.org,gregkh@linuxfoundation.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch removed from -mm tree
Message-Id: <20261007020357.707641F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: USB: gadgetfs: do not WARN about excessively large memory allocations
has been removed from the -mm tree.  Its filename was
     usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast path")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
---

 drivers/usb/gadget/legacy/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/legacy/inode.c~usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations
+++ a/drivers/usb/gadget/legacy/inode.c
@@ -613,7 +613,7 @@ ep_read_iter(struct kiocb *iocb, struct
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
@@ -675,7 +675,7 @@ ep_write_iter(struct kiocb *iocb, struct
 		return -EBADMSG;
 	}
 
-	buf = kmalloc(len, GFP_KERNEL);
+	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!buf)) {
 		mutex_unlock(&epdata->lock);
 		return -ENOMEM;
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-zsmalloc-replace-pg_private-with-pointer-comparison.patch
perf-ring_buffer-stop-using-pg_private-as-aux-page-high-order-marker.patch
xen-grant-table-stop-setting-pg_private-on-pages-for-grant-mapping.patch
fscrypt-stop-setting-pg_private-on-bounce-page.patch
mm-hugetlb-use-direct-assignment-instead-of-folio_change_private.patch
f2fs-stop-using-pg_private.patch
f2fs-convert-the-private-flag-helpers-to-folio-only.patch
erofs-mm-pagemap-add-readahead_folio_last-to-avoid-folio-private.patch
erofs-use-folio_attach-detach_private-instead-of-direct-assignment.patch
mm-page-flags-check-page-folio-private-instead-of-pg_private.patch
treewide-remove-folio_set-clear_private-usage.patch
ceph-replace-pageprivate-with-page_private.patch
treewide-remove-pageprivate-and-pg_private-from-comments-and-docs.patch
mm-page-flags-remove-pg_private.patch

