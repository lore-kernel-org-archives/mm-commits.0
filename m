From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 05/25] nilfs2: fix null pointer dereference at
 nilfs_segctor_do_construct()
Date: Wed, 10 Jun 2020 18:41:35 -0700
Message-ID: <20200611014135.qj6WrSl6h%akpm__46696.0384904937$1591839706$gmane$org@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:37 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hdk1983@gmail.com, hermes@ceres.dti.ne.jp, konishi.ryusuke@gmail.com, linux-mm@kvack.org, me@waltonhoops.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, tom@logand.com, torvalds@linux-foundation.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix null pointer dereference at nilfs_segctor_do_construct()

After commit c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if
mapping has no dirty pages"), the following null pointer dereference has
been reported on nilfs2:

 BUG: kernel NULL pointer dereference, address: 00000000000000a8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 ...
 RIP: 0010:percpu_counter_add_batch+0xa/0x60
 ...
 Call Trace:
  __test_set_page_writeback+0x2d3/0x330
  nilfs_segctor_do_construct+0x10d3/0x2110 [nilfs2]
  nilfs_segctor_construct+0x168/0x260 [nilfs2]
  nilfs_segctor_thread+0x127/0x3b0 [nilfs2]
  kthread+0xf8/0x130
  ...

This crash turned out to be caused by set_page_writeback() call for
segment summary buffers at nilfs_segctor_prepare_write().

set_page_writeback() can call inc_wb_stat(inode_to_wb(inode),
WB_WRITEBACK) where inode_to_wb(inode) is NULL if the inode of
underlying block device does not have an associated wb.

This fixes the issue by calling inode_attach_wb() in advance to ensure
to associate the bdev inode with its wb.

Link: http://lkml.kernel.org/r/20200608.011819.1399059588922299158.konishi.ryusuke@gmail.com
Fixes: c3aab9a0bd91 ("mm/filemap.c: don't initiate writeback if mapping has no dirty pages")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: Walton Hoops <me@waltonhoops.com>
Reported-by: Tomas Hlavaty <tom@logand.com>
Reported-by: ARAI Shun-ichi <hermes@ceres.dti.ne.jp>
Reported-by: Hideki EIRAKU <hdk1983@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/segment.c~nilfs2-fix-null-pointer-dereference-at-nilfs_segctor_do_construct
+++ a/fs/nilfs2/segment.c
@@ -2780,6 +2780,8 @@ int nilfs_attach_log_writer(struct super
 	if (!nilfs->ns_writer)
 		return -ENOMEM;
 
+	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
+
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
 	if (err) {
 		kfree(nilfs->ns_writer);
_
