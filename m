From: akpm@linux-foundation.org
Subject: - aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:15:53 -0800
Message-ID: <200802082015.m18KFYug010629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895AbYBHUv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: mac_addr: avoid 64-bit arch compiler warnings
has been removed from the -mm tree.  Its filename was
     aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: mac_addr: avoid 64-bit arch compiler warnings
From: "Ed L. Cashin" <ecashin@coraid.com>

By returning unsigned long long, mac_addr does not generate compiler warnings
on 64-bit architectures.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    3 +--
 drivers/block/aoe/aoecmd.c |   10 +++++-----
 drivers/block/aoe/aoenet.c |    4 ++--
 4 files changed, 9 insertions(+), 10 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings
+++ a/drivers/block/aoe/aoe.h
@@ -198,4 +198,4 @@ void aoenet_xmit(struct sk_buff *);
 int is_aoe_netif(struct net_device *ifp);
 int set_aoe_iflist(const char __user *str, size_t size);
 
-u64 mac_addr(char addr[6]);
+unsigned long long mac_addr(char addr[6]);
diff -puN drivers/block/aoe/aoeblk.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings
+++ a/drivers/block/aoe/aoeblk.c
@@ -37,8 +37,7 @@ static ssize_t aoedisk_show_mac(struct d
 
 	if (t == NULL)
 		return snprintf(page, PAGE_SIZE, "none\n");
-	return snprintf(page, PAGE_SIZE, "%012llx\n",
-			(unsigned long long)mac_addr(t->addr));
+	return snprintf(page, PAGE_SIZE, "%012llx\n", mac_addr(t->addr));
 }
 static ssize_t aoedisk_show_netif(struct device *dev,
 				  struct device_attribute *attr, char *page)
diff -puN drivers/block/aoe/aoecmd.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings
+++ a/drivers/block/aoe/aoecmd.c
@@ -309,7 +309,8 @@ resend(struct aoedev *d, struct aoetgt *
 		"%15s e%ld.%d oldtag=%08x@%08lx newtag=%08x "
 		"s=%012llx d=%012llx nout=%d\n",
 		"retransmit", d->aoemajor, d->aoeminor, f->tag, jiffies, n,
-		mac_addr(h->src), mac_addr(h->dst), t->nout);
+		mac_addr(h->src),
+		mac_addr(h->dst), t->nout);
 	aoechr_error(buf);
 
 	f->tag = n;
@@ -633,7 +634,7 @@ ataid_complete(struct aoedev *d, struct 
 
 	if (d->ssize != ssize)
 		printk(KERN_INFO "aoe: %012llx e%lu.%lu v%04x has %llu sectors\n",
-			(unsigned long long)mac_addr(t->addr),
+			mac_addr(t->addr),
 			d->aoemajor, d->aoeminor,
 			d->fw_ver, (long long)ssize);
 	d->ssize = ssize;
@@ -727,8 +728,7 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 	t = gettgt(d, hin->src);
 	if (t == NULL) {
 		printk(KERN_INFO "aoe: can't find target e%ld.%d:%012llx\n",
-			d->aoemajor, d->aoeminor,
-			(unsigned long long) mac_addr(hin->src));
+			d->aoemajor, d->aoeminor, mac_addr(hin->src));
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
 	}
@@ -1003,7 +1003,7 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 				"aoe: e%ld.%d: setting %d%s%s:%012llx\n",
 				d->aoemajor, d->aoeminor, n,
 				" byte data frames on ", ifp->nd->name,
-				(unsigned long long) mac_addr(t->addr));
+				mac_addr(t->addr));
 			ifp->maxbcnt = n;
 		}
 	}
diff -puN drivers/block/aoe/aoenet.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-mac_addr-avoid-64-bit-arch-compiler-warnings
+++ a/drivers/block/aoe/aoenet.c
@@ -83,7 +83,7 @@ set_aoe_iflist(const char __user *user_s
 	return 0;
 }
 
-u64
+unsigned long long
 mac_addr(char addr[6])
 {
 	__be64 n = 0;
@@ -91,7 +91,7 @@ mac_addr(char addr[6])
 
 	memcpy(p + 2, addr, 6);	/* (sizeof addr != 6) */
 
-	return __be64_to_cpu(n);
+	return (unsigned long long) __be64_to_cpu(n);
 }
 
 void
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
