From: akpm@osdl.org
Subject: - re-baycom_eppc-compile-failure.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:07 -0800
Message-ID: <200612130656.kBD6u7CE030696@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57910 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965041AbWLMG4P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     baycom_epp.c compile failure
has been removed from the -mm tree.  Its filename was
     re-baycom_eppc-compile-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: baycom_epp.c compile failure
From: Ralf Baechle <ralf@linux-mips.org>

Fix foobar in 15b1c0e822f578306332d4f4c449250db5c5dceb and
e8cc49bb0fdb9e18a99e6780073d1400ba2b0d1f patch series.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/hamradio/baycom_epp.c |    2 +-
 include/net/ax25.h                |    2 ++
 net/ax25/ax25_addr.c              |    2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/hamradio/baycom_epp.c~re-baycom_eppc-compile-failure drivers/net/hamradio/baycom_epp.c
--- a/drivers/net/hamradio/baycom_epp.c~re-baycom_eppc-compile-failure
+++ a/drivers/net/hamradio/baycom_epp.c
@@ -1177,7 +1177,7 @@ static void baycom_probe(struct net_devi
 	dev->mtu = AX25_DEF_PACLEN;        /* eth_mtu is the default */
 	dev->addr_len = AX25_ADDR_LEN;     /* sizeof an ax.25 address */
 	memcpy(dev->broadcast, &ax25_bcast, AX25_ADDR_LEN);
-	memcpy(dev->dev_addr, &ax25_nocall, AX25_ADDR_LEN);
+	memcpy(dev->dev_addr, &null_ax25_address, AX25_ADDR_LEN);
 	dev->tx_queue_len = 16;
 
 	/* New style flags */
diff -puN include/net/ax25.h~re-baycom_eppc-compile-failure include/net/ax25.h
--- a/include/net/ax25.h~re-baycom_eppc-compile-failure
+++ a/include/net/ax25.h
@@ -285,6 +285,8 @@ extern struct sock *ax25_make_new(struct
 extern const ax25_address ax25_bcast;
 extern const ax25_address ax25_defaddr;
 extern const ax25_address null_ax25_address;
+extern char *ax2asc(char *buf, const ax25_address *);
+extern void asc2ax(ax25_address *addr, const char *callsign);
 extern int ax25cmp(const ax25_address *, const ax25_address *);
 extern int ax25digicmp(const ax25_digi *, const ax25_digi *);
 extern const unsigned char *ax25_addr_parse(const unsigned char *, int,
diff -puN net/ax25/ax25_addr.c~re-baycom_eppc-compile-failure net/ax25/ax25_addr.c
--- a/net/ax25/ax25_addr.c~re-baycom_eppc-compile-failure
+++ a/net/ax25/ax25_addr.c
@@ -83,7 +83,7 @@ EXPORT_SYMBOL(ax2asc);
  */
 void asc2ax(ax25_address *addr, const char *callsign)
 {
-	char *s;
+	const char *s;
 	int n;
 
 	for (s = callsign, n = 0; n < 6; n++) {
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
i2o_exec_exit-and-i2o_driver_exit-should-not-be-__exit.patch
fix-namespace-conflict-between-w9968cfc-on-mips.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
fix-cow-d-cache-aliasing-on-fork.patch
pass-vma-argument-to-copy_user_highpage.patch
mips-fix-cow-d-cache-aliasing-on-fork.patch
optimize-d-cache-alias-handling-on-fork.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

