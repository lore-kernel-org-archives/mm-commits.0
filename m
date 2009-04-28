From: akpm@linux-foundation.org
Subject: [merged] scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin.patch removed from -mm tree
Date: Tue, 28 Apr 2009 12:25:36 -0700
Message-ID: <200904281925.n3SJPaF0020931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757790AbZD1T3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Apr 2009 15:29:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chombourger@gmail.com, sam@ravnborg.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     scripts/mod/modpost.c: fix Module.markers permission error under cygwin
has been removed from the -mm tree.  Its filename was
     scripts-mod-modpostc-fix-modulemarkers-permission-error-under-cygwin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

