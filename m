From: akpm@linux-foundation.org
Subject: + fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch
 added to -mm tree
Date: Tue, 25 Apr 2017 13:51:51 -0700
Message-ID: <58ffb6e7.FE6ZRQtj9vz5cUqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950936AbdDYUvx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Apr 2017 16:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: bugfix: write files greater than page size on OFS
has been added to the -mm tree.  Its filename is
     fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-affs-bugfix-make-symbolic-links-work-again.patch
fs-affs-bugfix-enable-writes-on-ofs-disks.patch
fs-affs-bugfix-write-files-greater-than-page-size-on-ofs.patch

