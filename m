From: akpm@linux-foundation.org
Subject: +
 fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch added to
 -mm tree
Date: Wed, 29 Nov 2017 19:50:15 -0800
Message-ID: <20171130035015.47vPhhtCQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33914 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751959AbdK3DuR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 22:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Anna.Schumaker@netapp.com, mm-commits@vger.kernel.org, rostedt@goodmis.org, torvalds@linux-foundation.org, trond.myklebust@primarydata.com


The patch titled
     Subject: fs/nfs/nfs4state.c: work around gcc-4.4.4 union initializer bug
has been added to the -mm tree.  Its filename is
     fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: fs/nfs/nfs4state.c: work around gcc-4.4.4 union initializer bug

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <Anna.Schumaker@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

fs-nfs-nfs4statec-work-around-gcc-444-union-initializer-bug.patch
workaround-for-a-pci-restoring-bug.patch

