From: akpm@linux-foundation.org
Subject: + bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:20:14 -0800
Message-ID: <200703060420.l264KETA011655@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50008 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933933AbXCFEU0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, marcel@holtmann.org


The patch titled
     bluetooth: fix socket locking in hci_sock_dev_event()
has been added to the -mm tree.  Its filename is
     bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bluetooth: fix socket locking in hci_sock_dev_event()
From: Jiri Kosina <jkosina@suse.cz>

[Bluetooth] Fix socket locking in hci_sock_dev_event()

hci_sock_dev_event() uses bh_lock_sock() to lock the socket lock.
This is not deadlock-safe against locking of the same socket lock in
l2cap_connect_cfm() from softirq context. In addition to that,
hci_sock_dev_event() doesn't seem to be called from softirq context,
so it is safe to use lock_sock()/release_sock() instead.

The lockdep warning can be triggered on my T42p simply by switching
the Bluetooth off by the keyboard button.

=================================
[ INFO: inconsistent lock state ]
2.6.21-rc2 #4
---------------------------------
inconsistent {in-softirq-W} -> {softirq-on-W} usage.
khubd/156 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (slock-AF_BLUETOOTH){-+..}, at: [<e0ca5520>] hci_sock_dev_event+0xa8/0xc5 [bluetooth]
{in-softirq-W} state was registered at:
  [<c012d1db>] mark_lock+0x59/0x414
  [<e0cef688>] l2cap_connect_cfm+0x4e/0x11f [l2cap]
  [<c012dfd7>] __lock_acquire+0x3e5/0xb99
  [<e0cef688>] l2cap_connect_cfm+0x4e/0x11f [l2cap]
  [<c012e7f2>] lock_acquire+0x67/0x81
  [<e0cef688>] l2cap_connect_cfm+0x4e/0x11f [l2cap]
  [<c036ee72>] _spin_lock+0x29/0x34
  [<e0cef688>] l2cap_connect_cfm+0x4e/0x11f [l2cap]
  [<e0cef688>] l2cap_connect_cfm+0x4e/0x11f [l2cap]
  [<e0ca17c3>] hci_send_cmd+0x126/0x14f [bluetooth]
  [<e0ca4ce4>] hci_event_packet+0x729/0xebd [bluetooth]
  [<e0ca205b>] hci_rx_task+0x2a/0x20f [bluetooth]
  [<e0ca209d>] hci_rx_task+0x6c/0x20f [bluetooth]
  [<c012d7be>] trace_hardirqs_on+0x10d/0x14e
  [<c011ac85>] tasklet_action+0x3d/0x68
  [<c011abba>] __do_softirq+0x41/0x92
  [<c011ac32>] do_softirq+0x27/0x3d
  [<c0105134>] do_IRQ+0x7b/0x8f
  [<c0103dec>] common_interrupt+0x24/0x34
  [<c0103df6>] common_interrupt+0x2e/0x34
  [<c0248e65>] acpi_processor_idle+0x1b3/0x34a
  [<c0248e68>] acpi_processor_idle+0x1b6/0x34a
  [<c010232b>] cpu_idle+0x39/0x4e
  [<c04bab0c>] start_kernel+0x372/0x37a
  [<c04ba42b>] unknown_bootoption+0x0/0x202
  [<ffffffff>] 0xffffffff

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/bluetooth/hci_sock.c~bluetooth-fix-socket-locking-in-hci_sock_dev_event net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c~bluetooth-fix-socket-locking-in-hci_sock_dev_event
+++ a/net/bluetooth/hci_sock.c
@@ -656,7 +656,7 @@ static int hci_sock_dev_event(struct not
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, node, &hci_sk_list.head) {
-			bh_lock_sock(sk);
+			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -665,7 +665,7 @@ static int hci_sock_dev_event(struct not
 
 				hci_dev_put(hdev);
 			}
-			bh_unlock_sock(sk);
+			release_sock(sk);
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-hid.patch
bluetooth-hid-quirks-mightymouse-quirk.patch
bluetooth-fix-socket-locking-in-hci_sock_dev_event.patch
git-ipwireless_cs.patch
