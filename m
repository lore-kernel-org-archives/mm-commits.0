From: akpm@osdl.org
Subject: - knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch removed from -mm tree
Date: Fri, 26 Jan 2007 17:31:48 -0800
Message-ID: <200701270131.l0R1Vm13031861@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbXA0Bb6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 20:31:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: fix an NFSD bug with full sized, non-page-aligned reads
has been removed from the -mm tree.  Its filename was
     knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: fix an NFSD bug with full sized, non-page-aligned reads
From: NeilBrown <neilb@suse.de>

NFSd assumes that largest number of pages that will be needed for a
request+response is 2+N where N pages is the size of the largest permitted
read/write request.  The '2' are 1 for the non-data part of the request, and 1
for the non-data part of the reply.

However, when a read request is not page-aligned, and we choose to use
->sendfile to send it directly from the page cache, we may need N+1 pages to
hold the whole reply.  This can overflow and array and cause an Oops.

This patch increases size of the array for holding pages by one and makes sure
that entry is NULL when it is not in use.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/vfs.c              |    3 ++-
 include/linux/sunrpc/svc.h |    5 ++++-
 net/sunrpc/svcsock.c       |    2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads
+++ a/fs/nfsd/vfs.c
@@ -822,7 +822,8 @@ nfsd_read_actor(read_descriptor_t *desc,
 		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
-		put_page(*pp);
+		if (*pp)
+			put_page(*pp);
 		*pp = page;
 		rqstp->rq_resused++;
 		rqstp->rq_res.page_len += size;
diff -puN include/linux/sunrpc/svc.h~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads
+++ a/include/linux/sunrpc/svc.h
@@ -144,8 +144,11 @@ extern u32 svc_max_payload(const struct 
  *
  * Each request/reply pair can have at most one "payload", plus two pages,
  * one for the request, and one for the reply.
+ * We using ->sendfile to return read data, we might need one extra page
+ * if the request is not page-aligned.  So add another '1'.
  */
-#define RPCSVC_MAXPAGES		((RPCSVC_MAXPAYLOAD+PAGE_SIZE-1)/PAGE_SIZE + 2)
+#define RPCSVC_MAXPAGES		((RPCSVC_MAXPAYLOAD+PAGE_SIZE-1)/PAGE_SIZE \
+				+ 2 + 1)
 
 static inline u32 svc_getnl(struct kvec *iov)
 {
diff -puN net/sunrpc/svcsock.c~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads net/sunrpc/svcsock.c
--- a/net/sunrpc/svcsock.c~knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads
+++ a/net/sunrpc/svcsock.c
@@ -1278,6 +1278,8 @@ svc_recv(struct svc_rqst *rqstp, long ti
 				schedule_timeout_uninterruptible(msecs_to_jiffies(500));
 			rqstp->rq_pages[i] = p;
 		}
+	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	BUG_ON(pages >= RPCSVC_MAXPAGES);
 
 	/* Make arg->head point to first page and arg->pages point to rest */
 	arg = &rqstp->rq_arg;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
