From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-drivers-atm-net.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:53:55 -0700
Message-ID: <200704281053.l3SArtmf020105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965693AbXD1KyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in drivers/atm, net
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-drivers-atm-net.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in drivers/atm, net
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/atmtcp.c |    2 +-
 net/atm/clip.c       |    2 +-
 net/atm/lec.c        |    2 +-
 net/atm/mpc.c        |    2 +-
 net/atm/signaling.c  |    2 +-
 net/dccp/minisocks.c |    2 +-
 net/ipv6/mip6.c      |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/atm/atmtcp.c~spin_lock_unlocked-cleanup-in-drivers-atm-net drivers/atm/atmtcp.c
--- a/drivers/atm/atmtcp.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/drivers/atm/atmtcp.c
@@ -352,7 +352,7 @@ static struct atm_dev atmtcp_control_dev
 	.ops		= &atmtcp_c_dev_ops,
 	.type		= "atmtcp",
 	.number		= 999,
-	.lock		= SPIN_LOCK_UNLOCKED
+	.lock		= __SPIN_LOCK_UNLOCKED(atmtcp_control_dev.lock)
 };
 
 
diff -puN net/atm/clip.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/atm/clip.c
--- a/net/atm/clip.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/atm/clip.c
@@ -702,7 +702,7 @@ static struct atm_dev atmarpd_dev = {
 	.ops =			&atmarpd_dev_ops,
 	.type =			"arpd",
 	.number = 		999,
-	.lock =			SPIN_LOCK_UNLOCKED
+	.lock =			__SPIN_LOCK_UNLOCKED(atmarpd_dev.lock)
 };
 
 
diff -puN net/atm/lec.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/atm/lec.c
--- a/net/atm/lec.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/atm/lec.c
@@ -630,7 +630,7 @@ static struct atm_dev lecatm_dev = {
 	.ops = &lecdev_ops,
 	.type = "lec",
 	.number = 999,		/* dummy device number */
-	.lock = SPIN_LOCK_UNLOCKED
+	.lock = __SPIN_LOCK_UNLOCKED(lecatm_dev.lock)
 };
 
 /*
diff -puN net/atm/mpc.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/atm/mpc.c
--- a/net/atm/mpc.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/atm/mpc.c
@@ -737,7 +737,7 @@ static struct atm_dev mpc_dev = {
 	.ops	= &mpc_ops,
 	.type	= "mpc",
 	.number	= 42,
-	.lock	= SPIN_LOCK_UNLOCKED
+	.lock	= __SPIN_LOCK_UNLOCKED(mpc_dev.lock)
 	/* members not explicitly initialised will be 0 */
 };
 
diff -puN net/atm/signaling.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/atm/signaling.c
--- a/net/atm/signaling.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/atm/signaling.c
@@ -256,7 +256,7 @@ static struct atm_dev sigd_dev = {
 	.ops =		&sigd_dev_ops,
 	.type =		"sig",
 	.number =	999,
-	.lock =		SPIN_LOCK_UNLOCKED
+	.lock =		__SPIN_LOCK_UNLOCKED(sigd_dev.lock)
 };
 
 
diff -puN net/dccp/minisocks.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/dccp/minisocks.c
--- a/net/dccp/minisocks.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/dccp/minisocks.c
@@ -27,7 +27,7 @@
 struct inet_timewait_death_row dccp_death_row = {
 	.sysctl_max_tw_buckets = NR_FILE * 2,
 	.period		= DCCP_TIMEWAIT_LEN / INET_TWDR_TWKILL_SLOTS,
-	.death_lock	= SPIN_LOCK_UNLOCKED,
+	.death_lock	= __SPIN_LOCK_UNLOCKED(dccp_death_row.death_lock),
 	.hashinfo	= &dccp_hashinfo,
 	.tw_timer	= TIMER_INITIALIZER(inet_twdr_hangman, 0,
 					    (unsigned long)&dccp_death_row),
diff -puN net/ipv6/mip6.c~spin_lock_unlocked-cleanup-in-drivers-atm-net net/ipv6/mip6.c
--- a/net/ipv6/mip6.c~spin_lock_unlocked-cleanup-in-drivers-atm-net
+++ a/net/ipv6/mip6.c
@@ -125,7 +125,7 @@ struct mip6_report_rate_limiter {
 };
 
 static struct mip6_report_rate_limiter mip6_report_rl = {
-	.lock = SPIN_LOCK_UNLOCKED
+	.lock = __SPIN_LOCK_UNLOCKED(mip6_report_rl.lock)
 };
 
 static int mip6_destopt_input(struct xfrm_state *x, struct sk_buff *skb)
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
git-jfs.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
git-netdev-all.patch
nfs-use-__set_current_state.patch
git-ocfs2.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch
