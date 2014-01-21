From: akpm@linux-foundation.org
Subject: + ipc-fix-compat-msgrcv-with-negative-msgtyp.patch added to -mm
 tree
Date: Tue, 21 Jan 2014 11:24:00 -0800
Message-ID: <52dec950.OzyEeZlrb/6O9aAb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbaAUTYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 14:24:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, manfred@colorfullife.com, gsc@bruker.de, davidlohr@hp.com, mguzik@redhat.com

Subject: + ipc-fix-compat-msgrcv-with-negative-msgtyp.patch added to -mm tree
To: mguzik@redhat.com,davidlohr@hp.com,gsc@bruker.de,manfred@colorfullife.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 11:24:00 -0800


The patch titled
     Subject: ipc: fix compat msgrcv with negative msgtyp
has been added to the -mm tree.  Its filename is
     ipc-fix-compat-msgrcv-with-negative-msgtyp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-fix-compat-msgrcv-with-negative-msgtyp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-fix-compat-msgrcv-with-negative-msgtyp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Guzik <mguzik@redhat.com>
Subject: ipc: fix compat msgrcv with negative msgtyp

Compat function takes msgtyp argument as u32 and passes it down to
do_msgrcv which results in casting to long, thus the sign is lost and we
get a big positive number instead.

Cast the argument to signed type before passing it down.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reported-by: Gabriellla Schmidt <gsc@bruker.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/compat.c~ipc-fix-compat-msgrcv-with-negative-msgtyp ipc/compat.c
--- a/ipc/compat.c~ipc-fix-compat-msgrcv-with-negative-msgtyp
+++ a/ipc/compat.c
@@ -381,7 +381,7 @@ COMPAT_SYSCALL_DEFINE6(ipc, u32, call, i
 			uptr = compat_ptr(ipck.msgp);
 			fifth = ipck.msgtyp;
 		}
-		return do_msgrcv(first, uptr, second, fifth, third,
+		return do_msgrcv(first, uptr, second, (s32)fifth, third,
 				 compat_do_msg_fill);
 	}
 	case MSGGET:
_

Patches currently in -mm which might be from mguzik@redhat.com are

ipc-fix-compat-msgrcv-with-negative-msgtyp.patch
linux-next.patch

