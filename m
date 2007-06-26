From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:24 -0700
Message-ID: <200706260346.l5Q3kOTX017629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbXFZDqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhalevy@panasas.com, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: fix enc_stateid_sz for nfsd callbacks
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: fix enc_stateid_sz for nfsd callbacks
From: Benny Halevy <bhalevy@panasas.com>

enc_stateid_sz should be given in u32 words units, not bytes, so we were
overestimating the buffer space needed here.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4callback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4callback.c~knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks fs/nfsd/nfs4callback.c
--- a/fs/nfsd/nfs4callback.c~knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks
+++ a/fs/nfsd/nfs4callback.c
@@ -75,7 +75,7 @@ enum nfs_cb_opnum4 {
 #define op_enc_sz			1
 #define op_dec_sz			2
 #define enc_nfs4_fh_sz			(1 + (NFS4_FHSIZE >> 2))
-#define enc_stateid_sz			16
+#define enc_stateid_sz			(NFS4_STATEID_SIZE >> 2)
 #define NFS4_enc_cb_recall_sz		(cb_compound_enc_hdr_sz +       \
 					1 + enc_stateid_sz +            \
 					enc_nfs4_fh_sz)
_

Patches currently in -mm which might be from bhalevy@panasas.com are

git-scsi-misc.patch
knfsd-nfsd4-fix-enc_stateid_sz-for-nfsd-callbacks.patch
