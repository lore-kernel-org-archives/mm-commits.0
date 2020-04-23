From: akpm@linux-foundation.org
Subject: [merged]
 coredump-fix-null-pointer-dereference-on-coredump.patch removed from -mm
 tree
Date: Thu, 23 Apr 2020 12:51:59 -0700
Message-ID: <20200423195159.0VMIQNjo-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgDWTwA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:52:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.ruffell@canonical.com, mm-commits@vger.kernel.org, nhorman@tuxdriver.com, pabs3@bonedaddy.net, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: coredump: fix null pointer dereference on coredump
has been removed from the -mm tree.  Its filename was
     coredump-fix-null-pointer-dereference-on-coredump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: coredump: fix null pointer dereference on coredump

If the core_pattern is set to "|" and any process segfaults then we get
a null pointer derefernce while trying to coredump. The call stack shows:
[  108.212680] RIP: 0010:do_coredump+0x628/0x11c0

When the core_pattern has only "|" there is no use of trying the coredump
and we can check that while formating the corename and exit with an error.

After this change I get:
[   48.453756] format_corename failed
[   48.453758] Aborting core

Link: http://lkml.kernel.org/r/20200416194612.21418-1-sudipm.mukherjee@gmail.com
Fixes: 315c69261dd3 ("coredump: split pipe command whitespace before expanding template")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reported-by: Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Paul Wise <pabs3@bonedaddy.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/coredump.c~coredump-fix-null-pointer-dereference-on-coredump
+++ a/fs/coredump.c
@@ -211,6 +211,8 @@ static int format_corename(struct core_n
 			return -ENOMEM;
 		(*argv)[(*argc)++] = 0;
 		++pat_ptr;
+		if (!(*pat_ptr))
+			return -ENOMEM;
 	}
 
 	/* Repeat as long as we have more pattern to process and more output
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are
