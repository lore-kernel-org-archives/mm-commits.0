From: akpm@linux-foundation.org
Subject: + mm-drop-actor-argument-of-do_shmem_file_read.patch added to -mm tree
Date: Wed, 17 Jul 2013 14:04:21 -0700
Message-ID: <51e706d5.Gz/Z1T3a2W8Srh3U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3GQVEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, hughd@google.com, dave.hansen@linux.intel.com, willy@linux.intel.com

Subject: + mm-drop-actor-argument-of-do_shmem_file_read.patch added to -mm tree
To: willy@linux.intel.com,dave.hansen@linux.intel.com,hughd@google.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:04:21 -0700


The patch titled
     Subject: mm: drop actor argument of do_shmem_file_read()
has been added to the -mm tree.  Its filename is
     mm-drop-actor-argument-of-do_shmem_file_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-actor-argument-of-do_shmem_file_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-actor-argument-of-do_shmem_file_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: mm: drop actor argument of do_shmem_file_read()

There's only one caller of do_shmem_file_read() and the only actor is
file_read_actor(). No reason to have a callback parameter.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~mm-drop-actor-argument-of-do_shmem_file_read mm/shmem.c
--- a/mm/shmem.c~mm-drop-actor-argument-of-do_shmem_file_read
+++ a/mm/shmem.c
@@ -1464,7 +1464,7 @@ shmem_write_end(struct file *file, struc
 	return copied;
 }
 
-static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc, read_actor_t actor)
+static void do_shmem_file_read(struct file *filp, loff_t *ppos, read_descriptor_t *desc)
 {
 	struct inode *inode = file_inode(filp);
 	struct address_space *mapping = inode->i_mapping;
@@ -1546,13 +1546,14 @@ static void do_shmem_file_read(struct fi
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
 		 *
-		 * The actor routine returns how many bytes were actually used..
+		 * The file_read_actor routine returns how many bytes were actually
+		 * used..
 		 * NOTE! This may not be the same as how much of a user buffer
 		 * we filled up (we may be padding etc), so we can only update
-		 * "pos" here (the actor routine has to update the user buffer
+		 * "pos" here (file_read_actor has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
+		ret = file_read_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
@@ -1590,7 +1591,7 @@ static ssize_t shmem_file_aio_read(struc
 		if (desc.count == 0)
 			continue;
 		desc.error = 0;
-		do_shmem_file_read(filp, ppos, &desc, file_read_actor);
+		do_shmem_file_read(filp, ppos, &desc);
 		retval += desc.written;
 		if (desc.error) {
 			retval = retval ?: desc.error;
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch

