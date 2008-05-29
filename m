From: akpm@linux-foundation.org
Subject: + bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling.patch added to -mm tree
Date: Wed, 28 May 2008 21:53:15 -0700
Message-ID: <200805290453.m4T4rFZr017095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYE2ExZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 00:53:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, davem@davemloft.net, hidave.darkstar@gmail.com, marcel@holtmann.org


The patch titled
     bluetooth: fix locking bug in the rfcomm socket cleanup handling
has been added to the -mm tree.  Its filename is
     bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bluetooth: fix locking bug in the rfcomm socket cleanup handling
From: Arjan van de Ven <arjan@linux.intel.com>

in net/bluetooth/rfcomm/sock.c, rfcomm_sk_state_change() does the
following operation:

        if (parent && sock_flag(sk, SOCK_ZAPPED)) {
                /* We have to drop DLC lock here, otherwise
                 * rfcomm_sock_destruct() will dead lock. */
                rfcomm_dlc_unlock(d);
                rfcomm_sock_kill(sk);
                rfcomm_dlc_lock(d);
        }
}

which is fine, since rfcomm_sock_kill() will call sk_free() which will
call rfcomm_sock_destruct() which takes the rfcomm_dlc_lock()...  so far
so good.

HOWEVER, this assumes that the rfcomm_sk_state_change() function always
gets called with the rfcomm_dlc_lock() taken.  This is the case for all
but one case, and in that case where we don't have the lock, we do a
double unlock followed by an attempt to take the lock, which due to
underflow isn't going anywhere fast.

This patch fixes this by moving the straggling case inside the lock, like
the other usages of the same call are doing in this code.

This was found with the help of the www.kerneloops.org project, where this
deadlock was observed 51 times at this point in time:
http://www.kerneloops.org/search.php?search=rfcomm_sock_destruct

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/rfcomm/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/bluetooth/rfcomm/core.c~bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling net/bluetooth/rfcomm/core.c
--- a/net/bluetooth/rfcomm/core.c~bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling
+++ a/net/bluetooth/rfcomm/core.c
@@ -423,8 +423,8 @@ static int __rfcomm_dlc_close(struct rfc
 
 		rfcomm_dlc_lock(d);
 		d->state = BT_CLOSED;
-		rfcomm_dlc_unlock(d);
 		d->state_change(d, err);
+		rfcomm_dlc_unlock(d);
 
 		skb_queue_purge(&d->tx_queue);
 		rfcomm_dlc_unlink(d);
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
bluetooth-fix-locking-bug-in-the-rfcomm-socket-cleanup-handling.patch
rename-warn-to-warning-to-clear-the-namespace.patch
rename-warn-to-warning-to-clear-the-namespace-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix.patch
add-a-warn-macro-this-is-warn_on-printk-arguments-fix-2.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
example-use-of-warn.patch

