From: akpm@linux-foundation.org
Subject: + fs-ramfs-file-nommu-add-setpageuptodate.patch added to -mm tree
Date: Thu, 28 Jun 2012 14:59:51 -0700
Message-ID: <20120628215951.B8FAAA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:52874 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2F1V7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jun 2012 17:59:53 -0400
Received: by vbnl22 with SMTP id l22so261409vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Jun 2012 14:59:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lliubbo@gmail.com, dhowells@redhat.com, geert@linux-m68k.org, gerg@uclinux.org, hughd@google.com, stable@vger.kernel.org


The patch titled
     Subject: fs: ramfs: file-nommu: add SetPageUptodate()
has been added to the -mm tree.  Its filename is
     fs-ramfs-file-nommu-add-setpageuptodate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs: ramfs: file-nommu: add SetPageUptodate()

Patches currently in -mm which might be from lliubbo@gmail.com are

fs-ramfs-file-nommu-add-setpageuptodate.patch

