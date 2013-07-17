From: akpm@linux-foundation.org
Subject: + mm-drop-actor-argument-of-do_generic_file_read.patch added to
 -mm tree
Date: Wed, 17 Jul 2013 14:04:20 -0700
Message-ID: <51e706d4.xaqeCNK0edNLbnAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3GQVEV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:04:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, liwanp@linux.vnet.ibm.com, hughd@google.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-drop-actor-argument-of-do_generic_file_read.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com,hughd@google.com,liwanp@linux.vnet.ibm.com,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:04:20 -0700


The patch titled
     Subject: mm: drop actor argument of do_generic_file_read()
has been added to the -mm tree.  Its filename is
     mm-drop-actor-argument-of-do_generic_file_read.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-actor-argument-of-do_generic_file_read.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-actor-argument-of-do_generic_file_read.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop actor argument of do_generic_file_read()

There's only one caller of do_generic_file_read() and the only actor is
file_read_actor().  No reason to have a callback parameter.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read mm/filemap.c
--- a/mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read
+++ a/mm/filemap.c
@@ -1088,7 +1088,6 @@ static void shrink_readahead_size_eio(st
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
- * @actor:	read method
  *
  * This is a generic file read routine, and uses the
  * mapping->a_ops->readpage() function for the actual low-level stuff.
@@ -1097,7 +1096,7 @@ static void shrink_readahead_size_eio(st
  * of the logic when it comes to error handling etc.
  */
 static void do_generic_file_read(struct file *filp, loff_t *ppos,
-		read_descriptor_t *desc, read_actor_t actor)
+		read_descriptor_t *desc)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1198,13 +1197,14 @@ page_ok:
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
 		 *
-		 * The actor routine returns how many bytes were actually used..
+		 * The file_read_actor routine returns how many bytes were
+		 * actually used..
 		 * NOTE! This may not be the same as how much of a user buffer
 		 * we filled up (we may be padding etc), so we can only update
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = actor(desc, page, offset, nr);
+		ret = file_read_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
@@ -1477,7 +1477,7 @@ generic_file_aio_read(struct kiocb *iocb
 		if (desc.count == 0)
 			continue;
 		desc.error = 0;
-		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		do_generic_file_read(filp, ppos, &desc);
 		retval += desc.written;
 		if (desc.error) {
 			retval = retval ?: desc.error;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch

