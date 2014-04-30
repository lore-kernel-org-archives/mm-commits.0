From: akpm@linux-foundation.org
Subject: + mm-zbudc-make-size-unsigned-like-unique-callsite.patch added to -mm tree
Date: Wed, 30 Apr 2014 13:06:46 -0700
Message-ID: <536157d6.TC+yk5+UwMMPVPGn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310AbaD3UGr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 16:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, fabf@skynet.be

Subject: + mm-zbudc-make-size-unsigned-like-unique-callsite.patch added to -mm tree
To: fabf@skynet.be,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:06:46 -0700


The patch titled
     Subject: mm/zbud.c: make size unsigned like unique callsite
has been added to the -mm tree.  Its filename is
     mm-zbudc-make-size-unsigned-like-unique-callsite.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zbudc-make-size-unsigned-like-unique-callsite.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zbudc-make-size-unsigned-like-unique-callsite.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/zbud.c: make size unsigned like unique callsite

zbud_alloc is only called by zswap_frontswap_store with unsigned int len. 
Change function parameter + update >= 0 check.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/zbud.h~mm-zbudc-make-size-unsigned-like-unique-callsite include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbudc-make-size-unsigned-like-unique-callsite
+++ a/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff -puN mm/zbud.c~mm-zbudc-make-size-unsigned-like-unique-callsite mm/zbud.c
--- a/mm/zbud.c~mm-zbudc-make-size-unsigned-like-unique-callsite
+++ a/mm/zbud.c
@@ -247,7 +247,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
@@ -255,7 +255,7 @@ int zbud_alloc(struct zbud_pool *pool, i
 	enum buddy bud;
 	struct page *page;
 
-	if (size <= 0 || gfp & __GFP_HIGHMEM)
+	if (!size || (gfp & __GFP_HIGHMEM))
 		return -EINVAL;
 	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
 		return -ENOSPC;
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

