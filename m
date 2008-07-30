From: akpm@linux-foundation.org
Subject: - ath5k-fix-memory-corruption.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:40 -0700
Message-ID: <200807301917.m6UJHe79011235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbYG3T1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mcgrof@gmail.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: fix memory corruption
has been removed from the -mm tree.  Its filename was
     ath5k-fix-memory-corruption.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: ath5k: fix memory corruption
=46rom: Jiri Slaby <jirislaby@gmail.com>

When signal is noisy, hardware can use all RX buffers and since the las=
t
entry in the list is self-linked, it overwrites the entry until we link
new buffers.

Ensure that we don't free this last one until we are 100% sure that it
is not used by the hardware anymore to not cause memory curruption as
can be seen below.

This is done by checking next buffer in the list. Even after that we
know that the hardware refetched the new link and proceeded further
(the next buffer is ready) we can finally free the overwritten buffer.

We discard it since the status in its descriptor is overwritten (OR-ed
by new status) too.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-4096: Poison overwritten
-----------------------------------------------------------------------=
------

INFO: 0xffff810067419060-0xffff810067419667. First byte 0x8 instead of =
0x6b
INFO: Allocated in dev_alloc_skb+0x18/0x30 age=3D1118 cpu=3D1 pid=3D0
INFO: Freed in skb_release_data+0x85/0xd0 age=3D1105 cpu=3D1 pid=3D3718
INFO: Slab 0xffffe200019d0600 objects=3D7 used=3D0 fp=3D0xffff810067419=
048 flags=3D0x40000000000020c3
INFO: Object 0xffff810067419048 @offset=3D4168 fp=3D0xffff81006741c120

Bytes b4 0xffff810067419038:  4f 0b 02 00 01 00 00 00 5a 5a 5a 5a 5a 5a=
 5a 5a O.......ZZZZZZZZ
  Object 0xffff810067419048:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b=
 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff810067419058:  6b 6b 6b 6b 6b 6b 6b 6b 08 42 30 00 00 0b=
 6b 80 kkkkkkkk.B0...k.
  Object 0xffff810067419068:  f0 5d 00 4f 62 08 a3 64 00 0c 42 16 52 e4=
 f0 5a 360].Ob.243d..B.R344360Z
  Object 0xffff810067419078:  68 81 00 00 7b a5 b4 be 7d 3b 8f 53 cd d5=
 de 12 h...{245264276};.S315325336.
  Object 0xffff810067419088:  96 10 0b 89 48 54 23 41 0f 4e 2d b9 37 c3=
 cb 29 ....HT#A.N-2717303313)
  Object 0xffff810067419098:  d1 e0 de 14 8a 57 2a cc 3b 44 0d 78 7a 19=
 12 15 321340336..W*314;D.xz...
  Object 0xffff8100674190a8:  a9 ec d4 35 a8 10 ec 8c 40 a7 06 0a 51 a7=
 48 bb 2513543245250.354.@247..Q247H273
  Object 0xffff8100674190b8:  3e cf a1 c7 38 60 63 3f 51 15 c7 20 eb ba=
 65 30 >=CF=A13078`c?Q.307.353272e0
 Redzone 0xffff81006741a048:  bb bb bb bb bb bb bb bb                  =
       273273273273273273273273
 Padding 0xffff81006741a088:  5a 5a 5a 5a 5a 5a 5a 5a                  =
       ZZZZZZZZ
Pid: 3297, comm: ath5k_pci Not tainted 2.6.26-rc8-mm1_64 #427

Call Trace:
 [<ffffffff802a7306>] print_trailer+0xf6/0x150
 [<ffffffff802a7485>] check_bytes_and_report+0x125/0x180
 [<ffffffff802a75dc>] check_object+0xac/0x260
 [<ffffffff802a9308>] __slab_alloc+0x368/0x6d0
 [<ffffffff80544f82>] ? wireless_send_event+0x142/0x310
 [<ffffffff804b1bd4>] ? __alloc_skb+0x44/0x150
 [<ffffffff80544f82>] ? wireless_send_event+0x142/0x310
 [<ffffffff802aa853>] __kmalloc_track_caller+0xc3/0xf0
 [<ffffffff804b1bfe>] __alloc_skb+0x6e/0x150
[... stack snipped]

=46IX kmalloc-4096: Restoring 0xffff810067419060-0xffff810067419667=3D0=
x6b

=46IX kmalloc-4096: Marking all objects used

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |   32 +++++++++++++++++++++-------
 drivers/net/wireless/ath5k/base.h |    2 -
 2 files changed, 26 insertions(+), 8 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-fix-memory-corruption=
 drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-fix-memory-corruption
+++ a/drivers/net/wireless/ath5k/base.c
@@ -1682,20 +1682,21 @@ ath5k_tasklet_rx(unsigned long data)
 	struct ath5k_rx_status rs =3D {};
 	struct sk_buff *skb;
 	struct ath5k_softc *sc =3D (void *)data;
-	struct ath5k_buf *bf;
+	struct ath5k_buf *bf, *bf_last;
 	struct ath5k_desc *ds;
 	int ret;
 	int hdrlen;
 	int pad;
=20
 	spin_lock(&sc->rxbuflock);
+	if (list_empty(&sc->rxbuf)) {
+		ATH5K_WARN(sc, "empty rx buf pool\n");
+		goto unlock;
+	}
+	bf_last =3D list_entry(sc->rxbuf.prev, struct ath5k_buf, list);
 	do {
 		rxs.flag =3D 0;
=20
-		if (unlikely(list_empty(&sc->rxbuf))) {
-			ATH5K_WARN(sc, "empty rx buf pool\n");
-			break;
-		}
 		bf =3D list_first_entry(&sc->rxbuf, struct ath5k_buf, list);
 		BUG_ON(bf->skb =3D=3D NULL);
 		skb =3D bf->skb;
@@ -1705,8 +1706,24 @@ ath5k_tasklet_rx(unsigned long data)
 		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
 				sc->desc_len, PCI_DMA_FROMDEVICE);
=20
-		if (unlikely(ds->ds_link =3D=3D bf->daddr)) /* this is the end */
-			break;
+		/*
+		 * last buffer must not be freed to ensure proper hardware
+		 * function. When the hardware finishes also a packet next to
+		 * it, we are sure, it doesn't use it anymore and we can go on.
+		 */
+		if (bf_last =3D=3D bf)
+			bf->flags |=3D 1;
+		if (bf->flags) {
+			struct ath5k_buf *bf_next =3D list_entry(bf->list.next,
+					struct ath5k_buf, list);
+			ret =3D sc->ah->ah_proc_rx_desc(sc->ah, bf_next->desc,
+					&rs);
+			if (ret)
+				break;
+			bf->flags &=3D ~1;
+			/* skip the overwritten one (even status is martian) */
+			goto next;
+		}
=20
 		ret =3D sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);
 		if (unlikely(ret =3D=3D -EINPROGRESS))
@@ -1816,6 +1833,7 @@ accept:
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
 	} while (ath5k_rxbuf_setup(sc, bf) =3D=3D 0);
+unlock:
 	spin_unlock(&sc->rxbuflock);
 }
=20
diff -puN drivers/net/wireless/ath5k/base.h~ath5k-fix-memory-corruption=
 drivers/net/wireless/ath5k/base.h
--- a/drivers/net/wireless/ath5k/base.h~ath5k-fix-memory-corruption
+++ a/drivers/net/wireless/ath5k/base.h
@@ -56,7 +56,7 @@
=20
 struct ath5k_buf {
 	struct list_head	list;
-	unsigned int		flags;	/* tx descriptor flags */
+	unsigned int		flags;	/* rx descriptor flags */
 	struct ath5k_desc	*desc;	/* virtual addr of desc */
 	dma_addr_t		daddr;	/* physical addr of desc */
 	struct sk_buff		*skb;	/* skbuff for buf */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
