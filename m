From: akpm@linux-foundation.org
Subject: + ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch added to -mm tree
Date: Wed, 18 Aug 2010 11:51:14 -0700
Message-ID: <201008181851.o7IIpEbY005942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733Ab0HRSvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 14:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deller@gmx.de, hughd@google.com, manfred@colorfullife.com


The patch titled
     ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2
has been added to the -mm tree.  Its filename is
     ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch

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
Subject: ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2
From: Helge Deller <deller@gmx.de>

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2 ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2
+++ a/ipc/shm.c
@@ -109,9 +109,9 @@ void __init shm_init (void)
 	shm_init_ns(&init_ipc_ns);
 	ipc_init_proc_interface("sysvipc/shm",
 #if BITS_PER_LONG <= 32
-				"       key      shmid perms       size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime        RSS       swap\n",
+				"       key      shmid perms       size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime        rss       swap\n",
 #else
-				"       key      shmid perms                  size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime                   RSS                  swap\n",
+				"       key      shmid perms                  size  cpid  lpid nattch   uid   gid  cuid  cgid      atime      dtime      ctime                   rss                  swap\n",
 #endif
 				IPC_SHM_IDS, sysvipc_shm_proc_show);
 }
_

Patches currently in -mm which might be from deller@gmx.de are

ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm.patch
ipc-shmc-add-rss-and-swap-size-information-to-proc-sysvipc-shm-v2.patch

