From: akpm@linux-foundation.org
Subject: - make-static-counters-in-new_inode-and-iunique-be-32-bits.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:10 -0700
Message-ID: <200705090253.l492rA9R009664@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032245AbXEICx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, dada1@cosmosbay.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inode numbering: make static counters in new_inode and iunique be 32 bits
has been removed from the -mm tree.  Its filename was
     make-static-counters-in-new_inode-and-iunique-be-32-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: inode numbering: make static counters in new_inode and iunique be 32 bits
From: Jeff Layton <jlayton@redhat.com>

The problems are:

- on filesystems w/o permanent inode numbers, i_ino values can be larger
  than 32 bits, which can cause problems for some 32 bit userspace programs on
  a 64 bit kernel.  We can't do anything for filesystems that have actual
  >32-bit inode numbers, but on filesystems that generate i_ino values on the
  fly, we should try to have them fit in 32 bits.  We could trivially fix this
  by making the static counters in new_inode and iunique 32 bits, but...

- many filesystems call new_inode and assume that the i_ino values they are
  given are unique.  They are not guaranteed to be so, since the static
  counter can wrap.  This problem is exacerbated by the fix for #1.

- after allocating a new inode, some filesystems call iunique to try to get
  a unique i_ino value, but they don't actually add their inodes to the
  hashtable, and so they're still not guaranteed to be unique if that counter
  wraps.

This patch set takes the simpler approach of simply using iunique and hashing
the inodes afterward.  Christoph H.  previously mentioned that he thought that
this approach may slow down lookups for filesystems that currently hash their
inodes.

The questions are:

1) how much would this slow down lookups for these filesystems?
2) is it enough to justify adding more infrastructure to avoid it?

What might be best is to start with this approach and then only move to using
IDR or some other scheme if these extra inodes in the hashtable prove to be
problematic.

I've done some cursory testing with this patch and the overhead of hashing and
unhashing the inodes with pipefs is pretty low -- just a few seconds of system
time added on to the creation and destruction of 10 million pipes (very
similar to the overhead that the IDR approach would add).

The hard thing to measure is what effect this has on other filesystems. I'm
open to ways to try and gauge this.

Again, I've only converted pipefs as an example. If this approach is
acceptable then I'll start work on patches to convert other filesystems.


With a pretty-much-worst-case microbenchmark provided by Eric Dumazet
<dada1@cosmosbay.com>:

hashing patch (pipebench):
sys     1m15.329s
sys     1m16.249s
sys     1m17.169s

unpatched (pipebench):
sys     1m9.836s
sys     1m12.541s
sys     1m14.153s

Which works out to 1.05642174294555027017.  So ~5-6% slowdown.


This patch:

When a 32-bit program that was not compiled with large file offsets does a
stat and gets a st_ino value back that won't fit in the 32 bit field, glibc
(correctly) generates an EOVERFLOW error.  We can't do anything about fs's
with larger permanent inode numbers, but when we generate them on the fly, we
ought to try and have them fit within a 32 bit field.

This patch takes the first step toward this by making the static counters in
these two functions be 32 bits.

[jlayton@redhat.com: mention that it's only the case for 32bit, non-LFS stat]
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits fs/inode.c
--- a/fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits
+++ a/fs/inode.c
@@ -524,7 +524,12 @@ repeat:
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	static unsigned long last_ino;
+	/*
+	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+	 * error if st_ino won't fit in target struct field. Use 32bit counter
+	 * here to attempt to avoid that.
+	 */
+	static unsigned int last_ino;
 	struct inode * inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -683,7 +688,12 @@ static unsigned long hash(struct super_b
  */
 ino_t iunique(struct super_block *sb, ino_t max_reserved)
 {
-	static ino_t counter;
+	/*
+	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+	 * error if st_ino won't fit in target struct field. Use 32bit counter
+	 * here to attempt to avoid that.
+	 */
+	static unsigned int counter;
 	struct inode *inode;
 	struct hlist_head *head;
 	ino_t res;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
