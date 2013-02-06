From: akpm@linux-foundation.org
Subject: + fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:13 -0800
Message-ID: <20130206224914.2EC1031C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:49012 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3BFWtP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:15 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so210975qen.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: fs/buffer.c: change type of max_buffer_heads to unsigned long
has been added to the -mm tree.  Its filename is
     fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: fs/buffer.c: change type of max_buffer_heads to unsigned long

max_buffer_heads is calculated from nr_free_buffer_pages(), so change its
type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long
+++ a/fs/buffer.c
@@ -3237,7 +3237,7 @@ static struct kmem_cache *bh_cachep __re
  * Once the number of bh's in the machine exceeds this level, we start
  * stripping them in writeback.
  */
-static int max_buffer_heads;
+static unsigned long max_buffer_heads;
 
 int buffer_heads_over_limit;
 
@@ -3353,7 +3353,7 @@ EXPORT_SYMBOL(bh_submit_read);
 
 void __init buffer_init(void)
 {
-	int nrpages;
+	unsigned long nrpages;
 
 	bh_cachep = kmem_cache_create("buffer_head",
 			sizeof(struct buffer_head), 0,
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

mm-fix-return-type-for-functions-nr_free__pages.patch
ia64-use-%ld-to-print-pages-calculated-in-nr_free_buffer_pages.patch
fs-bufferc-change-type-of-max_buffer_heads-to-unsigned-long.patch
fs-nfsd-change-type-of-max_delegations-nfsd_drc_max_mem-and-nfsd_drc_mem_used.patch
vmscan-change-type-of-vm_total_pages-to-unsigned-long.patch
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
net-change-type-of-virtio_chan-p9_max_pages.patch
binfmt_elf-remove-unused-argument-in-fill_elf_header.patch
kexec-get-rid-of-duplicate-check-for-hole_end.patch

