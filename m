From: akpm@linux-foundation.org
Subject: - knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch removed from -mm tree
Date: Sun, 04 Mar 2007 17:18:45 -0800
Message-ID: <200703050118.l251IkkC005841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54788 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbXCEBSz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Mar 2007 20:18:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: avoid checksum checks when collecting metadata for a UDP packet
has been removed from the -mm tree.  Its filename was
     knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch

This patch was dropped because I don't know if it depended on the other two

------------------------------------------------------
Subject: knfsd: avoid checksum checks when collecting metadata for a UDP packet
From: NeilBrown <neilb@suse.de>

When recv_msg is called with a size of 0 and MSG_PEEK (and sunrpc/svcsock.c
does), it is clear that we only interested in metadata (from/to addresses) and
not the data, so don't do any checksum checking at this point.  Leave that
until the data is requested.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/udp.c |    3 +++
 net/ipv6/udp.c |    4 ++++
 2 files changed, 7 insertions(+)

diff -puN net/ipv4/udp.c~knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet net/ipv4/udp.c
--- a/net/ipv4/udp.c~knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet
+++ a/net/ipv4/udp.c
@@ -846,6 +846,9 @@ try_again:
 			goto csum_copy_err;
 		copy_only = 1;
 	}
+	if (len == 0 &&  (flags & MSG_PEEK))
+		/* avoid checksum concerns when just getting metadata */
+		copy_only = 1;
 
 	if (copy_only)
 		err = skb_copy_datagram_iovec(skb, sizeof(struct udphdr),
diff -puN net/ipv6/udp.c~knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet net/ipv6/udp.c
--- a/net/ipv6/udp.c~knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet
+++ a/net/ipv6/udp.c
@@ -151,6 +151,10 @@ try_again:
 		copy_only = 1;
 	}
 
+	if (len == 0 &&  (flags & MSG_PEEK))
+		/* avoid checksum concerns when just getting metadata */
+		copy_only = 1;
+
 	if (copy_only)
 		err = skb_copy_datagram_iovec(skb, sizeof(struct udphdr),
 					      msg->msg_iov, copied       );
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
knfsd-avoid-checksum-checks-when-collecting-metadata-for-a-udp-packet.patch
md-fix-for-raid6-reshape.patch
md-fix-for-raid6-reshape-fix.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous-tidy.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
