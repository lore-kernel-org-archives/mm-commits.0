From: akpm@linux-foundation.org
Subject: [merged] ipc-fix-compat-msgrcv-with-negative-msgtyp.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:43 -0800
Message-ID: <52e80077.HUVmuS9QrTMMkgnV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaA1TJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, manfred@colorfullife.com, gsc@bruker.de, davidlohr@hp.com, mguzik@redhat.com

Subject: [merged] ipc-fix-compat-msgrcv-with-negative-msgtyp.patch removed from -mm tree
To: mguzik@redhat.com,davidlohr@hp.com,gsc@bruker.de,manfred@colorfullife.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:43 -0800


The patch titled
     Subject: ipc: fix compat msgrcv with negative msgtyp
has been removed from the -mm tree.  Its filename was
     ipc-fix-compat-msgrcv-with-negative-msgtyp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

