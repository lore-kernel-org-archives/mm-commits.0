From: akpm@linux-foundation.org
Subject: + scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin.patch added to -mm tree
Date: Thu, 16 Apr 2009 14:47:05 -0700
Message-ID: <200904162147.n3GLl5FO004724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbZDPVuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Apr 2009 17:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chombourger@gmail.com, sam@ravnborg.org, stable@kernel.org


The patch titled
     scripts/mod/modpost.c: fix Module.markers permission error under cygwin
has been added to the -mm tree.  Its filename is
     scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/mod/modpost.c: fix Module.markers permission error under cygwin
From: Cedric Hombourger <chombourger@gmail.com>

While building the kernel, we end-up calling modpost with -K and -M
options for the same file (Modules.markers).  This is resulting in
modpost's main function calling read_markers() and then write_markers() on
the same file.

We then have read_markers() mmap'ing the file, and writer_markers()
opening that same file for writing.

The issue is that read_markers() exits without munmap'ing the file and is
as a matter holding a reference on Modules.markers.  When write_markers()
is opening that very same file for writing, we still have a reference on
it and cygwin (Windows?) is then making fopen() fail with EPERM.

Calling release_file() before exiting read_markers() clears that reference
(and memory leak) and fopen() then succeeds.

Tested on both cygwin (1.3.22) and Linux.  Also ran modpost within
valgrind on Linux to make sure that the munmap'ed file was not accessed
after read_markers()

Signed-off-by: Cedric Hombourger <chombourger@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/modpost.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/mod/modpost.c~scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin
+++ a/scripts/mod/modpost.c
@@ -2008,6 +2008,7 @@ static void read_markers(const char *fna
 		if (!mod->skip)
 			add_marker(mod, marker, fmt);
 	}
+	release_file(file, size);
 	return;
 fail:
 	fatal("parse error in markers list file\n");
_

Patches currently in -mm which might be from chombourger@gmail.com are

scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin.patch

