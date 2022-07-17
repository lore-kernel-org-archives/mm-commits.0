Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D98AC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 00:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiGQAej (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Jul 2022 20:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiGQAei (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Jul 2022 20:34:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2A3654A
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 17:34:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20710B8015A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 00:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB4FC34114;
        Sun, 17 Jul 2022 00:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658018074;
        bh=9UcsWKciknVq6yAV4Hs0JA6bt+oh3CfES9BCO2k3TaY=;
        h=Date:To:From:Subject:From;
        b=iK07zGnya14C7FwE2iLaZKsgUMMz6ZCaHgb8cUdL5y60ZmEGBqVdARlGFQixpi7qT
         pdQf71cZF+A42AHvKOoZAE9VE3VwQofuiHRDM7hGHcnH16Srqcg8s0VJ23I6UI+5na
         IltLVj8RVmkUr0tGgC3XzjV14z40y3h97zMYNxSo=
Date:   Sat, 16 Jul 2022 17:34:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, hdanton@sina.com,
        ebiggers@kernel.org, axelrasmussen@google.com, rppt@linux.ibm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + secretmem-fix-unhandled-fault-in-truncate-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20220717003434.8CB4FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: secretmem: fix unhandled fault in truncate
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     secretmem-fix-unhandled-fault-in-truncate-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/secretmem-fix-unhandled-fault-in-truncate-v3.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
secretmem-fix-unhandled-fault-in-truncate-v3.patch
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

