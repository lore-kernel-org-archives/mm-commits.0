Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C19C20C328;
	Wed,  6 Nov 2024 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925236; cv=none; b=AvhkkkUZ75OD7hjzxzfb5o1fzsPL7o3oCY9/JlHE6q8TMFIpdn8CIJEf3tD9+a/lHBpLB5Dlhr9/PrR3JLlyF7usTHy2WXgw3HSpKHuyntz44xjpYDmrZsHlMZjrXUYYjTnlAa+AnwZvtT6amHPJXXSJB1ATDPIDyfZqg8ot58Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925236; c=relaxed/simple;
	bh=bFm3H5xaKjdBfPTeKzQYKQ/MDJtJzswxi5/1angTsas=;
	h=Date:To:From:Subject:Message-Id; b=Vd4XsVIDPlOaynZOzzVhzyLOvm3sQPk+fyWGDnKInMctJ7vIc4izC0jJYJ+QnMf2teJY2/3GiLY4I4puPxN2WUh0Dw/cHAMY8UMdvG2xTWDGzBEgV8tho6NyYhlT6Tll3riO/2aE5/5Xe1eYWhv1V4k/eiSFyM4kw2L+M9R/+uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GUuU01Zr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GUuU01Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F85C4CEC6;
	Wed,  6 Nov 2024 20:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730925236;
	bh=bFm3H5xaKjdBfPTeKzQYKQ/MDJtJzswxi5/1angTsas=;
	h=Date:To:From:Subject:From;
	b=GUuU01Zr6HuZqI+JLRGu1FOJ3ql6+/9L4a73XsPKwx330U+TaIbxt/f1mFVjkoPm3
	 upWvUMpl9uigNu+3RzhHXWP1ABETb7St7huEQtZveNoPwgXmCjYgzexAqzfX1hodxo
	 u2JjEoawI6gyzMgdPXgdw54Wdq+/TTuRxmBkKSTQ=
Date: Wed, 06 Nov 2024 12:33:55 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,bugreport@valiantsec.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch added to mm-hotfixes-unstable branch
Message-Id: <20241106203356.17F85C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
Date: Thu, 7 Nov 2024 01:07:32 +0900

Patch series "nilfs2: fix null-ptr-deref bugs on block tracepoints".

This series fixes null pointer dereference bugs that occur when using
nilfs2 and two block-related tracepoints.


This patch (of 2):

It has been reported that when using "block:block_touch_buffer"
tracepoint, touch_buffer() called from __nilfs_get_folio_block() causes a
NULL pointer dereference, or a general protection fault when KASAN is
enabled.

This happens because since the tracepoint was added in touch_buffer(), it
references the dev_t member bh->b_bdev->bd_dev regardless of whether the
buffer head has a pointer to a block_device structure.  In the current
implementation, the block_device structure is set after the function
returns to the caller.

Here, touch_buffer() is used to mark the folio/page that owns the buffer
head as accessed, but the common search helper for folio/page used by the
caller function was optimized to mark the folio/page as accessed when it
was reimplemented a long time ago, eliminating the need to call
touch_buffer() here in the first place.

So this solves the issue by eliminating the touch_buffer() call itself.

Link: https://lkml.kernel.org/r/20241106160811.3316-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20241106160811.3316-2-konishi.ryusuke@gmail.com
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Ubisectech Sirius <bugreport@valiantsec.com>
Closes: https://lkml.kernel.org/r/86bd3013-887e-4e38-960f-ca45c657f032.bugreport@valiantsec.com
Reported-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9982fb8d18eba905abe2
Tested-by: syzbot+9982fb8d18eba905abe2@syzkaller.appspotmail.com
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nilfs2/page.c~nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint
+++ a/fs/nilfs2/page.c
@@ -39,7 +39,6 @@ static struct buffer_head *__nilfs_get_f
 	first_block = (unsigned long)index << (PAGE_SHIFT - blkbits);
 	bh = get_nth_bh(bh, block - first_block);
 
-	touch_buffer(bh);
 	wait_on_buffer(bh);
 	return bh;
 }
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch
nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint.patch

