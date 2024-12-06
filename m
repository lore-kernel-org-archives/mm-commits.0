Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417D66FBF;
	Fri,  6 Dec 2024 03:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733457317; cv=none; b=p9IEJA4nvZ9kljId4EIziFwhkgldiLpwA5wCZvJfuKdO6Tn1X+3ontv1CoGXtTyvebT/I2REqtxZhV3FIP9fCj5PWOFqhNOLlimBL1Tp6SNaQ3OrDfc4j3XfCWvrzP7+qwaQUHw9udMH3PR0e6UzdFwAOqXNV/1npOImPxjAOtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733457317; c=relaxed/simple;
	bh=xlcYBMfXE2Mo5caQX1NFxeokIbMhRaGUMHq1Y0PeHqs=;
	h=Date:To:From:Subject:Message-Id; b=iuZjVEhHBL4gHkWe3oT9w2e7brBOJirLSntBsj5sW+ysr9rZBe8xOe3pmhSMGoJ3z2TkPKroquqJ2Rb4Ro0rTBuV/mCRmYloOOeWoqUWjzkUPhWHzb3J5Lb8m+YAmBzCc/6/qXHV3RBaUt2NbWzOHQm2uwT/8BrTJGfhWBnteew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TbNY8agT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TbNY8agT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089F6C4CED1;
	Fri,  6 Dec 2024 03:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733457317;
	bh=xlcYBMfXE2Mo5caQX1NFxeokIbMhRaGUMHq1Y0PeHqs=;
	h=Date:To:From:Subject:From;
	b=TbNY8agTUo0/5sUx+bxr9I/smQdrib2Lz8L6S6cgHcLwzDY9poyp0jDEn91AHR52D
	 kwcZ/ozArjxuuy5vqH1bjEweL23RDiZwEvPP8zG7tLYRW3GjSStAt33nFwKH3PCktZ
	 dG9HUEWh/fIRbWvn6OwJ1ioIOQTM0OMJNDa2Q6xY=
Date: Thu, 05 Dec 2024 19:55:16 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch removed from -mm tree
Message-Id: <20241206035517.089F6C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix potential out-of-bounds memory access in nilfs_find_entry()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-out-of-bounds-memory-access-in-nilfs_find_entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


