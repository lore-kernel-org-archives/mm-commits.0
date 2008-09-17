From: akpm@linux-foundation.org
Subject: + cifs-dont-use-gfp_kernel-with-gfp_nofs.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:12:25 -0700
Message-ID: <200809172112.m8HLCPfM030624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYIQVMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, sfrench@samba.org


The patch titled
     cifs: don't use GFP_KERNEL with GFP_NOFS
has been added to the -mm tree.  Its filename is
     cifs-dont-use-gfp_kernel-with-gfp_nofs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: don't use GFP_KERNEL with GFP_NOFS
From: Pekka Enberg <penberg@cs.helsinki.fi>

GFP_KERNEL and GFP_NOFS are mutually exclusive.  If you combine them, you
end up with plain GFP_KERNEL which can deadlock in cases where you really
want GFP_NOFS.

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/misc.c      |    6 ++----
 fs/cifs/transport.c |    3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN fs/cifs/misc.c~cifs-dont-use-gfp_kernel-with-gfp_nofs fs/cifs/misc.c
--- a/fs/cifs/misc.c~cifs-dont-use-gfp_kernel-with-gfp_nofs
+++ a/fs/cifs/misc.c
@@ -150,8 +150,7 @@ cifs_buf_get(void)
    but it may be more efficient to always alloc same size
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
-	ret_buf = (struct smb_hdr *) mempool_alloc(cifs_req_poolp,
-						   GFP_KERNEL | GFP_NOFS);
+	ret_buf = mempool_alloc(cifs_req_poolp, GFP_NOFS);
 
 	/* clear the first few header bytes */
 	/* for most paths, more is cleared in header_assemble */
@@ -188,8 +187,7 @@ cifs_small_buf_get(void)
    but it may be more efficient to always alloc same size
    albeit slightly larger than necessary and maxbuffersize
    defaults to this and can not be bigger */
-	ret_buf = (struct smb_hdr *) mempool_alloc(cifs_sm_req_poolp,
-						   GFP_KERNEL | GFP_NOFS);
+	ret_buf = mempool_alloc(cifs_sm_req_poolp, GFP_NOFS);
 	if (ret_buf) {
 	/* No need to clear memory here, cleared in header assemble */
 	/*	memset(ret_buf, 0, sizeof(struct smb_hdr) + 27);*/
diff -puN fs/cifs/transport.c~cifs-dont-use-gfp_kernel-with-gfp_nofs fs/cifs/transport.c
--- a/fs/cifs/transport.c~cifs-dont-use-gfp_kernel-with-gfp_nofs
+++ a/fs/cifs/transport.c
@@ -50,8 +50,7 @@ AllocMidQEntry(const struct smb_hdr *smb
 		return NULL;
 	}
 
-	temp = (struct mid_q_entry *) mempool_alloc(cifs_mid_poolp,
-						    GFP_KERNEL | GFP_NOFS);
+	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	if (temp == NULL)
 		return temp;
 	else {
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
cifs-dont-use-gfp_kernel-with-gfp_nofs.patch
hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch
slab-leaks3-default-y.patch

