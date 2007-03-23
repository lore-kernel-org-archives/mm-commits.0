From: akpm@linux-foundation.org
Subject: + knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch added to -mm tree
Date: Thu, 22 Mar 2007 23:52:52 -0800
Message-ID: <200703230752.l2N7qq2S009455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41344 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422673AbXCWHw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 Mar 2007 03:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: allow nfsd READDIR to return 64bit cookies
has been added to the -mm tree.  Its filename is
     knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: allow nfsd READDIR to return 64bit cookies
From: NeilBrown <neilb@suse.de>

->readdir passes lofft_t offsets (used as nfs cookies) to
nfs3svc_encode_entry{,_plus}, but when they pass it on to encode_entry it
becomes an 'off_t', which isn't good.

So filesystems that returned 64bit offsets would lose.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs3xdr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~knfsd-allow-nfsd-readdir-to-return-64bit-cookies fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~knfsd-allow-nfsd-readdir-to-return-64bit-cookies
+++ a/fs/nfsd/nfs3xdr.c
@@ -859,8 +859,8 @@ compose_entry_fh(struct nfsd3_readdirres
 #define NFS3_ENTRY_BAGGAGE	(2 + 1 + 2 + 1)
 #define NFS3_ENTRYPLUS_BAGGAGE	(1 + 21 + 1 + (NFS3_FHSIZE >> 2))
 static int
-encode_entry(struct readdir_cd *ccd, const char *name,
-	     int namlen, off_t offset, ino_t ino, unsigned int d_type, int plus)
+encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
+	     loff_t offset, ino_t ino, unsigned int d_type, int plus)
 {
 	struct nfsd3_readdirres *cd = container_of(ccd, struct nfsd3_readdirres,
 		       					common);
@@ -880,7 +880,7 @@ encode_entry(struct readdir_cd *ccd, con
 			*cd->offset1 = htonl(offset64 & 0xffffffff);
 			cd->offset1 = NULL;
 		} else {
-			xdr_encode_hyper(cd->offset, (u64) offset);
+			xdr_encode_hyper(cd->offset, offset64);
 		}
 	}
 
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-allow-nfsd-readdir-to-return-64bit-cookies.patch
knfsd-nfsd4-fix-inheritance-flags-on-v4-ace-derived-from-posix-default-ace.patch
knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch
knfsd-nfsd4-remove-superfluous-cancel_delayed_work-call.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
