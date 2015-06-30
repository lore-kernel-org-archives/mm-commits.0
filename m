From: akpm@linux-foundation.org
Subject: [folded-merged] scsi-resolve-sg-buffer-const-ness-issue-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:51:08 -0700
Message-ID: <55930f4c.UU0Qk3HKm6aK+0Oh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbbF3VvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, arnd@arndb.de, david.s.gordon@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi-resolve-sg-buffer-const-ness-issue-fix
has been removed from the -mm tree.  Its filename was
     scsi-resolve-sg-buffer-const-ness-issue-fix.patch

This patch was dropped because it was folded into scsi-resolve-sg-buffer-const-ness-issue.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scsi-resolve-sg-buffer-const-ness-issue-fix

fix very broken build

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Gordon <david.s.gordon@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    3 +++
 lib/scatterlist.c           |    6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue-fix include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~scsi-resolve-sg-buffer-const-ness-issue-fix
+++ a/include/linux/scatterlist.h
@@ -265,6 +265,9 @@ int sg_alloc_table_from_pages(struct sg_
 	unsigned long offset, unsigned long size,
 	gfp_t gfp_mask);
 
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer);
+
 size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
 			   const void *buf, size_t buflen);
 size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
diff -puN lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue-fix lib/scatterlist.c
--- a/lib/scatterlist.c~scsi-resolve-sg-buffer-const-ness-issue-fix
+++ a/lib/scatterlist.c
@@ -650,9 +650,8 @@ EXPORT_SYMBOL(sg_miter_stop);
  * Returns the number of copied bytes.
  *
  **/
-static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
-			     void *buf, size_t buflen, off_t skip,
-			     bool to_buffer)
+size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
+		      size_t buflen, off_t skip, bool to_buffer)
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
@@ -689,6 +688,7 @@ static size_t sg_copy_buffer(struct scat
 	local_irq_restore(flags);
 	return offset;
 }
+EXPORT_SYMBOL(sg_copy_buffer);
 
 /**
  * sg_copy_from_buffer - Copy from a linear buffer to an SG list
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
ipcshm-move-bug_on-check-into-shm_lock.patch
scsi-resolve-sg-buffer-const-ness-issue.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

