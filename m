From: akpm@linux-foundation.org
Subject: [merged] nfsd-wrong-index-used-in-inner-loop.patch removed from -mm tree
Date: Thu, 10 Mar 2011 13:56:52 -0800
Message-ID: <201103102158.p2ALw8qU030784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879Ab1CJV6V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 16:58:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, bfields@fieldses.org, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nfsd: wrong index used in inner loop
has been removed from the -mm tree.  Its filename was
     nfsd-wrong-index-used-in-inner-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfsd: wrong index used in inner loop
From: Roel Kluin <roel.kluin@gmail.com>

Index i was already used in the outer loop.

(akpm: I suspect this will allow a rogue packet to cause a kernel lockup
and oops, so cc:stable)

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4xdr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/nfs4xdr.c~nfsd-wrong-index-used-in-inner-loop fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~nfsd-wrong-index-used-in-inner-loop
+++ a/fs/nfsd/nfs4xdr.c
@@ -1142,7 +1142,7 @@ nfsd4_decode_create_session(struct nfsd4
 
 	u32 dummy;
 	char *machine_name;
-	int i;
+	int i, j;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1215,7 +1215,7 @@ nfsd4_decode_create_session(struct nfsd4
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (i = 0; i < dummy; ++i)
+			for (j = 0; j < dummy; ++j)
 				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

