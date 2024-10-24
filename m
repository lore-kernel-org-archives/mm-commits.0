Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F7B3C3C
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 03:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738896; cv=none; b=ReGQ7Pu6KbpLWYVZuEGhK64S7yAmuJs4SPVIbsgvvA8wLyvnH3wF5dyR4q7MhpyNFhjhArS39A1+Zar0IhIG5o8Q4a7Qwub9KVUp6RnCT3Vuvipzzrr2ymB7iMK2t4NpmMSSZLGeIFtcvhKVsV2UUV7p4lsfSQAkx7oWjOfFSKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738896; c=relaxed/simple;
	bh=c1OYydnuFmQ3Q5I5yHsxFJApnJ2ddSNpnUQsE5V/ttE=;
	h=Date:To:From:Subject:Message-Id; b=Zr2UgUJRPZ7w1hgSGs0EiX2Jb3coWiA0Fb+wg+SMJihlgnUEQBw/WNGaXdNbNzQsVgjTiJaEPzAWh/2RTDgL5A3K7VoKoXulLe/lBGFqThsJxQr5hdRsENDoOiphJe9kZTDBAxn+IkxraopHrSJkipbLDL7XPWD5wN1FaFw7cgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U23zROww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U23zROww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB08C4CEC6;
	Thu, 24 Oct 2024 03:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738896;
	bh=c1OYydnuFmQ3Q5I5yHsxFJApnJ2ddSNpnUQsE5V/ttE=;
	h=Date:To:From:Subject:From;
	b=U23zROwwzhwTrQjuolqXafEaaQt0EdhpO0cAGyRI5JMeJhU+QqQlvJjfOLirb8wYQ
	 ZUMjI0m7JrAyukjge8pIU6gXYb7evrD8XULE2Ni6fcxexsL0QtVQC8O35/kTLaJ+EG
	 3XaxA5P2HS/EJQ9nZutMjI2kkYr3Ne1VYvaOcLJs=
Date: Wed, 23 Oct 2024 20:01:35 -0700
To: mm-commits@vger.kernel.org,yi1.lai@linux.intel.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024030136.0CB08C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: fix variable overflow in squashfs_readpage_block
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix variable overflow in squashfs_readpage_block
Date: Mon, 21 Oct 2024 00:22:00 +0100

Syzbot reports a slab out of bounds access in squashfs_readpage_block().

This is caused by an attempt to read page index 0x2000000000.  This value
(start_index) is stored in an integer loop variable which overflows
producing a value of 0.  This causes a loop which iterates over pages
start_index -> end_index to iterate over 0 -> end_index, which ultimately
causes an out of bounds page array access.

Fix by changing variable to a loff_t, and rename to index to make it
clearer it is a page index, and not a loop count.

Link: https://lkml.kernel.org/r/20241020232200.837231-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/ZwzcnCAosIPqQ9Ie@ly-workstation/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file_direct.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file_direct.c~squashfs-fix-variable-overflow-in-squashfs_readpage_block
+++ a/fs/squashfs/file_direct.c
@@ -30,7 +30,8 @@ int squashfs_readpage_block(struct page
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
 	loff_t start_index = folio->index & ~mask;
 	loff_t end_index = start_index | mask;
-	int i, n, pages, bytes, res = -ENOMEM;
+	loff_t index;
+	int i, pages, bytes, res = -ENOMEM;
 	struct page **page, *last_page;
 	struct squashfs_page_actor *actor;
 	void *pageaddr;
@@ -45,9 +46,9 @@ int squashfs_readpage_block(struct page
 		return res;
 
 	/* Try to grab all the pages covered by the Squashfs block */
-	for (i = 0, n = start_index; n <= end_index; n++) {
-		page[i] = (n == folio->index) ? target_page :
-			grab_cache_page_nowait(target_page->mapping, n);
+	for (i = 0, index = start_index; index <= end_index; index++) {
+		page[i] = (index == folio->index) ? target_page :
+			grab_cache_page_nowait(target_page->mapping, index);
 
 		if (page[i] == NULL)
 			continue;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-variable-overflow-in-squashfs_readpage_block.patch

