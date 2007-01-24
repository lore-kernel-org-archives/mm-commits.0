From: akpm@osdl.org
Subject: + make-static-counters-in-new_inode-and-iunique-be-32-bits.patch added to -mm tree
Date: Tue, 23 Jan 2007 20:48:14 -0800
Message-ID: <200701240448.l0O4mEAX008677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51183 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030187AbXAXEs0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:48:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     inode numbering: make static counters in new_inode and iunique be 32 bits
has been added to the -mm tree.  Its filename is
     make-static-counters-in-new_inode-and-iunique-be-32-bits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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



This patch:

When a 32-bit program that was not compiled with large file offsets does a
stat and gets a st_ino value back that won't fit in the 32 bit field, glibc
(correctly) generates an EOVERFLOW error.  We can't do anything about fs's
with larger permanent inode numbers, but when we generate them on the fly, we
ought to try and have them fit within a 32 bit field.

This patch takes the first step toward this by making the static counters in
these two functions be 32 bits.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/inode.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits fs/inode.c
--- a/fs/inode.c~make-static-counters-in-new_inode-and-iunique-be-32-bits
+++ a/fs/inode.c
@@ -525,7 +525,8 @@ repeat:
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	static unsigned long last_ino;
+	/* 32 bits for compatability mode stat calls */
+	static unsigned int last_ino;
 	struct inode * inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -684,7 +685,8 @@ static unsigned long hash(struct super_b
  */
 ino_t iunique(struct super_block *sb, ino_t max_reserved)
 {
-	static ino_t counter;
+	/* 32 bits for compatability mode stat calls */
+	static unsigned int counter;
 	struct inode *inode;
 	struct hlist_head * head;
 	ino_t res;
_

Patches currently in -mm which might be from jlayton@redhat.com are

make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch
