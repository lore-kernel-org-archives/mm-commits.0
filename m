From: akpm@linux-foundation.org
Subject: + net-change-type-of-virtio_chan-p9_max_pages.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:49:23 -0800
Message-ID: <20130206224923.EA2C031C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:60372 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab3BFWtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:49:25 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so211626qcr.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:49:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com, davem@davemloft.net, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     Subject: net: change type of virtio_chan->p9_max_pages
has been added to the -mm tree.  Its filename is
     net-change-type-of-virtio_chan-p9_max_pages.patch

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
Subject: net: change type of virtio_chan->p9_max_pages

This member of struct virtio_chan is calculated from nr_free_buffer_pages
so change its type to unsigned long in case of overflow.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/9p/trans_virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/9p/trans_virtio.c~net-change-type-of-virtio_chan-p9_max_pages net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~net-change-type-of-virtio_chan-p9_max_pages
+++ a/net/9p/trans_virtio.c
@@ -87,7 +87,7 @@ struct virtio_chan {
 	/* This is global limit. Since we don't have a global structure,
 	 * will be placing it in each channel.
 	 */
-	int p9_max_pages;
+	unsigned long p9_max_pages;
 	/* Scatterlist: can be too big for stack. */
 	struct scatterlist sg[VIRTQUEUE_NUM];
 
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

