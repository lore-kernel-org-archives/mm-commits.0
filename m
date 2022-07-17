Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B1CC43334
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiGQEcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGQEcq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:32:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B6B20189
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:32:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EA5E60F98
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE224C3411E;
        Sun, 17 Jul 2022 04:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032364;
        bh=bc9gruXtMwjIQRQtwZ0bQyc4P2PViqLwqny7OmB5QLA=;
        h=Date:To:From:Subject:From;
        b=zU4n7az8S8g1e6ZCShR/mUzbcs/eE5JrqSedP02RwywolC2nPnTfkntu8lUspXKQ4
         F90fK13bzMXc8/rWibsbBQotgczKAMESvEKHPmByfM5YXNFJHLGRXiggpb6x/hJxF8
         wmswxyuuS5wtmx5x0D9nPpuXWV8PHfGY4a7nhGM0=
Date:   Sat, 16 Jul 2022 21:32:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hdanton@sina.com,
        ebiggers@kernel.org, axelrasmussen@google.com, rppt@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] secretmem-fix-unhandled-fault-in-truncate-v3.patch removed from -mm tree
Message-Id: <20220717043244.CE224C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: secretmem: fix unhandled fault in truncate
has been removed from the -mm tree.  Its filename was
     secretmem-fix-unhandled-fault-in-truncate-v3.patch

This patch was dropped because it was folded into secretmem-fix-unhandled-fault-in-truncate.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: secretmem: fix unhandled fault in truncate
Date: Thu, 14 Jul 2022 12:13:37 +0300

v3: use invalidate_lock rather than inode_lock
v2: use inode_lock_shared() rather than add a new rw_sem to secretmem

Link: https://lkml.kernel.org/r/20220714091337.412297-1-rppt@kernel.org
Reported-by: syzbot+9bd2b7adbd34b30b87e4@syzkaller.appspotmail.com
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/mm/secretmem.c~secretmem-fix-unhandled-fault-in-truncate-v3
+++ a/mm/secretmem.c
@@ -61,7 +61,7 @@ static vm_fault_t secretmem_fault(struct
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return vmf_error(-EINVAL);
 
-	inode_lock_shared(inode);
+	filemap_invalidate_lock_shared(mapping);
 
 retry:
 	page = find_lock_page(mapping, offset);
@@ -104,7 +104,7 @@ retry:
 	ret = VM_FAULT_LOCKED;
 
 out:
-	inode_unlock_shared(inode);
+	filemap_invalidate_unlock_shared(mapping);
 	return ret;
 }
 
@@ -173,12 +173,20 @@ static int secretmem_setattr(struct user
 			     struct dentry *dentry, struct iattr *iattr)
 {
 	struct inode *inode = d_inode(dentry);
+	struct address_space *mapping = inode->i_mapping;
 	unsigned int ia_valid = iattr->ia_valid;
+	int ret;
+
+	filemap_invalidate_lock(mapping);
 
 	if ((ia_valid & ATTR_SIZE) && inode->i_size)
-		return -EINVAL;
+		ret = -EINVAL;
+	else
+		ret = simple_setattr(mnt_userns, dentry, iattr);
 
-	return simple_setattr(mnt_userns, dentry, iattr);
+	filemap_invalidate_unlock(mapping);
+
+	return ret;
 }
 
 static const struct inode_operations secretmem_iops = {
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

secretmem-fix-unhandled-fault-in-truncate.patch
csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pgd_order-v2.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch
arm-heads-rename-pmd_order-to-pmd_entry_order.patch

