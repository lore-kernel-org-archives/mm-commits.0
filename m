From: akpm@linux-foundation.org
Subject: + net-ipv6-ndiscc-remove-unused-variable.patch added to -mm tree
Date: Mon, 17 Mar 2008 16:29:03 -0700
Message-ID: <200803172329.m2HNT470003775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755521AbYCQX3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 19:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, davem@davemloft.net, pekkas@netcore.fi


The patch titled
     net/ipv6/ndisc.c: remove unused variable
has been added to the -mm tree.  Its filename is
     net-ipv6-ndiscc-remove-unused-variable.patch

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
Subject: net/ipv6/ndisc.c: remove unused variable
From: Julia Lawall <julia@diku.dk>

The variable hlen is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Pekka Savola <pekkas@netcore.fi>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/ndisc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/ipv6/ndisc.c~net-ipv6-ndiscc-remove-unused-variable net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c~net-ipv6-ndiscc-remove-unused-variable
+++ a/net/ipv6/ndisc.c
@@ -1420,7 +1420,6 @@ void ndisc_send_redirect(struct sk_buff 
 	u8 *opt;
 	int rd_len;
 	int err;
-	int hlen;
 	u8 ha_buf[MAX_ADDR_LEN], *ha = NULL;
 
 	dev = skb->dev;
@@ -1491,7 +1490,6 @@ void ndisc_send_redirect(struct sk_buff 
 		return;
 	}
 
-	hlen = 0;
 
 	skb_reserve(buff, LL_RESERVED_SPACE(dev));
 	ip6_nd_hdr(sk, buff, dev, &saddr_buf, &ipv6_hdr(skb)->saddr,
_

Patches currently in -mm which might be from julia@diku.dk are

git-acpi.patch
git-alsa-tiwai.patch
git-powerpc.patch
drivers-block-viodasdc-use-field_sizeof.patch
git-dvb.patch
git-hid.patch
git-udf.patch
git-net.patch
git-ocfs2.patch
drivers-net-wireless-iwlwifi-iwl-4965c-correct-use-of-and.patch
fs-affs-filec-use-bug_on.patch
fbdev-use-div_round_up-or-roundup.patch
fs-ext2-use-bug_on.patch
fs-ext3-use-bug_on.patch
fs-ext4-use-bug_on.patch
net-9p-trans_fdc-remove-unused-variable.patch
net-ipv6-ndiscc-remove-unused-variable.patch
sound-pci-remove-unused-variable.patch
drivers-net-ixgb-ixgb_mainc-remove-unused-variable.patch

