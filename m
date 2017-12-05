From: akpm@linux-foundation.org
Subject: [alternative-merged]
 fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch removed
 from -mm tree
Date: Tue, 05 Dec 2017 11:24:31 -0800
Message-ID: <20171205192431.gfsxKU1Wq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdLETYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 14:24:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Anna.Schumaker@netapp.com, mm-commits@vger.kernel.org, rostedt@goodmis.org, torvalds@linux-foundation.org, trond.myklebust@primarydata.com


The patch titled
     Subject: fs/nfs/nfs4state.c: work around gcc-4.4.4 union initializer bug
has been removed from the -mm tree.  Its filename was
     fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: fs/nfs/nfs4state.c: work around gcc-4.4.4 union initializer bug

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <Anna.Schumaker@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4state.c   |    3 +--
 include/linux/nfs4.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug
+++ a/fs/nfs/nfs4state.c
@@ -71,8 +71,7 @@ const nfs4_stateid zero_stateid = {
 };
 const nfs4_stateid invalid_stateid = {
 	{
-		.seqid = cpu_to_be32(0xffffffffU),
-		.other = { 0 },
+		{ .seqid = cpu_to_be32(0xffffffffU), .other = { 0 }, },
 	},
 	.type = NFS4_INVALID_STATEID_TYPE,
 };
diff -puN include/linux/nfs4.h~fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug include/linux/nfs4.h
--- a/include/linux/nfs4.h~fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug
+++ a/include/linux/nfs4.h
@@ -53,11 +53,11 @@ typedef struct { char data[NFS4_VERIFIER
 
 struct nfs4_stateid_struct {
 	union {
-		char data[NFS4_STATEID_SIZE];
 		struct {
 			__be32 seqid;
 			char other[NFS4_STATEID_OTHER_SIZE];
 		} __attribute__ ((packed));
+		char data[NFS4_STATEID_SIZE];
 	};
 
 	enum {
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

workaround-for-a-pci-restoring-bug.patch

