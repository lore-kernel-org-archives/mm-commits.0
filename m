Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EBFC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF449221FF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633257;
	bh=bqKSEmKhf9QMB9xgOCFvTFZNZuomRLIYfjNzHMEyfQA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=R9x1SzWR0zA4pW9Jd7DpBNB5VmNEzqYSnO3SKclPeP94Mpz6biAqQKgMBOkDu0BZV
	 fE1QH9OCjCcliJ/KrSDJe5PlFIoacRIeFJMQchcrinZOlFD0RPnTLy3nSgqa9Lyokb
	 /RB1MfV+9M7wyD+MpQ01JzQRc6dIdAXZySqB8Dok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgJMXyR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbgJMXyR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:54:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 414B721D7B;
        Tue, 13 Oct 2020 23:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633255;
        bh=bqKSEmKhf9QMB9xgOCFvTFZNZuomRLIYfjNzHMEyfQA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J+CQTh6JJOYBl+x381e6RQo/OtdNoKX8ii1q3eVx3tgJ6MKrJfxwRUV4ZLZjoXOqW
         2XiTRJ4RjI1kCY7QPvNSmy4toq9jM0A/+bIUsirC3N0usDa+Vz5ms86z4hH45tqjyT
         +2jGLzM+PXDKghPp2JR+geduT4qORuj0pxZqgg/Y=
Date:   Tue, 13 Oct 2020 16:54:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 107/181] mm/mmap.c: use helper function
 allow_write_access() in __remove_shared_vm_struct()
Message-ID: <20201013235414.Y-JFwtBNG%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmap.c: use helper function allow_write_access() in __remove_shared_vm_struct()

In commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), the helper allow_write_access
came with the atomic_inc operation of the i_writecount field in the func
__remove_shared_vm_struct().  But it forgot to use this helper function.

Link: https://lkml.kernel.org/r/20200921115814.39680-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct
+++ a/mm/mmap.c
@@ -143,7 +143,7 @@ static void __remove_shared_vm_struct(st
 		struct file *file, struct address_space *mapping)
 {
 	if (vma->vm_flags & VM_DENYWRITE)
-		atomic_inc(&file_inode(file)->i_writecount);
+		allow_write_access(file);
 	if (vma->vm_flags & VM_SHARED)
 		mapping_unmap_writable(mapping);
 
_
