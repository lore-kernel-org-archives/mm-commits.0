From: akpm@linux-foundation.org
Subject: [merged] fs-ramfs-file-nommu-add-setpageuptodate.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:11 -0700
Message-ID: <20120712193711.C2DD910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:43159 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030748Ab2GLThM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:12 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so265538vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, hughd@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: ramfs: file-nommu: add SetPageUptodate()
has been removed from the -mm tree.  Its filename was
     fs-ramfs-file-nommu-add-setpageuptodate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: fs: ramfs: file-nommu: add SetPageUptodate()

There is a bug in the below scenario for !CONFIG_MMU:

1. create a new file
2. mmap the file and write to it
3. read the file can't get the correct value

Because
sys_read() > generic_file_aio_read() > simple_readpage() > clear_page()
which make the page be zeroed.

Add SetPageUptodate() to ramfs_nommu_expand_for_mapping() so that
generic_file_aio_read() do not call simple_readpage().

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommu-add-setpageuptodate fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommu-add-setpageuptodate
+++ a/fs/ramfs/file-nommu.c
@@ -110,6 +110,7 @@ int ramfs_nommu_expand_for_mapping(struc
 
 		/* prevent the page from being discarded on memory pressure */
 		SetPageDirty(page);
+		SetPageUptodate(page);
 
 		unlock_page(page);
 		put_page(page);
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch

