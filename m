From: akpm@linux-foundation.org
Subject: [merged]
 fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch removed from
 -mm tree
Date: Mon, 01 May 2017 12:21:00 -0700
Message-ID: <20170501192100.Pnj3niJl8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdEATVB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 1 May 2017 15:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/affs: bugfix: write files greater than page size on OFS
has been removed from the -mm tree.  Its filename was
     fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: bugfix: write files greater than page size on OFS

Previous AFFS patch fixed OFS write operations but unveiled another bug:
files greater than 4KB are being created with a wrong size resulting in
errors like the following:

dd if=/dev/zero of=file bs=4097 count=1
cp file /mnt/affs/
cp: error writing '/mnt/affs/file': Bad address

Link: http://lkml.kernel.org/r/20170424201310.1796-1-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/affs/file.c~fs-affs-bugfix-write-files-greater-than-page-size-on-ofs fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-bugfix-write-files-greater-than-page-size-on-ofs
+++ a/fs/affs/file.c
@@ -679,7 +679,7 @@ static int affs_write_end_ofs(struct fil
 	int written;
 
 	from = pos & (PAGE_SIZE - 1);
-	to = pos + len;
+	to = from + len;
 	/*
 	 * XXX: not sure if this can handle short copies (len < copied), but
 	 * we don't have to, because the page should always be uptodate here,
_

Patches currently in -mm which might be from fabf@skynet.be are


