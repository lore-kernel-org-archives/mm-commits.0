Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A452572;
	Tue, 12 Nov 2024 01:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731374448; cv=none; b=rJD+fgVqWUn6ZfkbUTmCSD3Ty/GQhprBodd48hRuabVbA+fUUsBcHLgWVP7FszNEnu8z7McTk25d+ph9SjveE3t6qcVQh+fpBTN1krTR9GHvF19HHsU4KZZYgz/aWGqqdSQsyMNuqS/asHJtYyftvQ1RQPVtPIMWJ/e8guhmKb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731374448; c=relaxed/simple;
	bh=w02gIJxpxP3vZCJTIXny8RTLwglJhBacTC6TxcQ3rhg=;
	h=Date:To:From:Subject:Message-Id; b=tUd54DTlmj1zMvn0UKEt7Aa3Mwoh3j7OnE1YdkXb75HQcBHduxJ12qSLyhr1nDSYL3pPJC8g34JHamBMnzXpYk2PzdtS1htxyUxo/PYiVobSBJP5II6hAhGlaJfjv6HGZA4lZUDdUp5Q5hYTx3iVZfGFYdJzbHAekmxk4MtdWAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qy/T7sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qy/T7sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F87C4CECF;
	Tue, 12 Nov 2024 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731374448;
	bh=w02gIJxpxP3vZCJTIXny8RTLwglJhBacTC6TxcQ3rhg=;
	h=Date:To:From:Subject:From;
	b=0qy/T7sOdGe6vOD1YUdtXDtwV34DvciUxj0pp0TLmBApT0brdSk8bEsV4Gky1h3hp
	 7eN8FTnt2IHsZR6hx4ahxHgK2A5l1ACOXXsOAW2KFP4Ovs1LlakYOG5plErDIjntiM
	 H+dHqbkDIvTd+TuPTaXo/SQKpcrXSIDoNujYRk/c=
Date: Mon, 11 Nov 2024 17:20:47 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,bugreport@valiantsec.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch removed from -mm tree
Message-Id: <20241112012048.27F87C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix null-ptr-deref in block_touch_buffer tracepoint
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


