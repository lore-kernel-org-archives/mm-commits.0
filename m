From: akpm@linux-foundation.org
Subject: + nfsd-wrong-index-used-in-inner-loop.patch added to -mm tree
Date: Wed, 09 Mar 2011 15:43:59 -0800
Message-ID: <201103092343.p29NhxMV002636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab1CIXoK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 18:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, bfields@fieldses.org, neilb@suse.de, stable@kernel.org


The patch titled
     nfsd: wrong index used in inner loop
has been added to the -mm tree.  Its filename is
     nfsd-wrong-index-used-in-inner-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
nfsd-wrong-index-used-in-inner-loop.patch
btrfs-dont-dereference-extent_mapping-if-null.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch

