Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356782582;
	Fri, 22 Nov 2024 06:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732257121; cv=none; b=MWLsjcHhT/Mp0m0cThv5WK9VGE9Z9tB8YUjHSKYiDqVT4T3bBOhL8eZh6ha5FyDclsn/PO1AWrzdMDKVKYqd/difD/evanMOtJtXLSnGayBoPrwq13af7JGPYsTC2Zjjh6RYVHFmeBxPXygyN5VhE+UMkcnpIe/B+SKjfMdmx14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732257121; c=relaxed/simple;
	bh=KeeCZfXqK0ofg1e9izwao4kKcz80oKRDdCc+p86Vg4A=;
	h=Date:To:From:Subject:Message-Id; b=JLetO5MKpf9GGcxwXwMS0dMLVL9hZA0I98yUPRe2iXKDqMFQu9aQLlFG6T5mzAC4gojKbNLg6R9nEZCcIp58SzHdfjFmlqKdai+TAXnHhRaA02CVCYx5h2fnFm/3qWzmmL3BXhhZ+YZnhsb5tFmEEqzmkVSXH7/eGzEx6GLHz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NYp/1fHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NYp/1fHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE9AC4CECE;
	Fri, 22 Nov 2024 06:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732257120;
	bh=KeeCZfXqK0ofg1e9izwao4kKcz80oKRDdCc+p86Vg4A=;
	h=Date:To:From:Subject:From;
	b=NYp/1fHEvI5VzL1679dB/5uH9lxsnJZVNGKvHE00875PSMbgex9u2QArc1XorderV
	 iUp2tP77F7oOZcrh4PqQCMX7xAoe9gJkX0xeOwImK11XioCh50KnZG2RRuRfpH8iNe
	 +DKw5cUOD74wr2aw6Qf9K+kC2nWmXkMI5zl2tOyI=
Date: Thu, 21 Nov 2024 22:31:56 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122063159.EDE9AC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch

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
Subject: nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
Date: Wed, 20 Nov 2024 02:23:37 +0900

Syzbot reported that when searching for records in a directory where the
inode's i_size is corrupted and has a large value, memory access outside
the folio/page range may occur, or a use-after-free bug may be detected if
KASAN is enabled.

This is because nilfs_last_byte(), which is called by nilfs_find_entry()
and others to calculate the number of valid bytes of directory data in a
page from i_size and the page index, loses the upper 32 bits of the 64-bit
size information due to an inappropriate type of local variable to which
the i_size value is assigned.

This caused a large byte offset value due to underflow in the end address
calculation in the calling nilfs_find_entry(), resulting in memory access
that exceeds the folio/page size.

Fix this issue by changing the type of the local variable causing the bit
loss from "unsigned int" to "u64".  The return value of nilfs_last_byte()
is also of type "unsigned int", but it is truncated so as not to exceed
PAGE_SIZE and no bit loss occurs, so no change is required.

Link: https://lkml.kernel.org/r/20241119172403.9292-1-konishi.ryusuke@gmail.com
Fixes: 2ba466d74ed7 ("nilfs2: directory entry operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=96d5d14c47d97015c624
Tested-by: syzbot+96d5d14c47d97015c624@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/dir.c~nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry
+++ a/fs/nilfs2/dir.c
@@ -70,7 +70,7 @@ static inline unsigned int nilfs_chunk_s
  */
 static unsigned int nilfs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned int last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch

