Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E57C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D3520768
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266120;
	bh=45o/6kcUWrkmqm8N+mYZAZL/jcUSdt+KCnWphd31iOU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Xg2P3VkKcYF9xycMUW18OqE6ZHEJ+8yEmcFP0uagSzyB1HOEgEom2rOrrSPsQRoEk
	 fC9t6fFflcCL38i2bdGshvxUdsVO+sXXTPM2X0tMK0KS0yW8RsIbpXk/d+b+cZcQhv
	 dkeFYcnw5Fay4hjT8v3CHPtM6sEdLmzhUluWUG6k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHLVCA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgHLVCA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:02:00 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8088520774;
        Wed, 12 Aug 2020 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266119;
        bh=45o/6kcUWrkmqm8N+mYZAZL/jcUSdt+KCnWphd31iOU=;
        h=Date:From:To:Subject:From;
        b=2ZSGZe2SMa+fqtS+ws34Zrxw/y8HUNb6kBdgI2Osr+2u4uR1p4dbv1Fw+eiA6NmUD
         3Uur7EgISbnYppfYTh6PSxlSI1suk7IsHkXDGXfIPWw5LjVpdV/pjh6AL1wvl7PjH1
         i444TdqSdjxGlS5ggaunJ72ObGdQR3Cl3jsdvxwg=
Date:   Wed, 12 Aug 2020 14:01:59 -0700
From:   akpm@linux-foundation.org
To:     amir73il@gmail.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mszeredi@redhat.com,
        viro@zeniv.linux.org.uk, walters@verbum.org, willy@infradead.org
Subject:  [merged]
 hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch removed from -mm
 tree
Message-ID: <20200812210159.rzoTj8Mfw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: prevent filesystem stacking of hugetlbfs
has been removed from the -mm tree.  Its filename was
     hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: prevent filesystem stacking of hugetlbfs

syzbot found issues with having hugetlbfs on a union/overlay as reported
in [1].  Due to the limitations (no write) and special functionality of
hugetlbfs, it does not work well in filesystem stacking.  There are no
know use cases for hugetlbfs stacking.  Rather than making modifications
to get hugetlbfs working in such environments, simply prevent stacking.

[1] https://lore.kernel.org/linux-mm/000000000000b4684e05a2968ca6@google.com/

Link: http://lkml.kernel.org/r/80f869aa-810d-ef6c-8888-b46cee135907@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: syzbot+d6ec23007e951dadf3de@syzkaller.appspotmail.com
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Colin Walters <walters@verbum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-prevent-filesystem-stacking-of-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -1364,6 +1364,12 @@ hugetlbfs_fill_super(struct super_block
 	sb->s_magic = HUGETLBFS_MAGIC;
 	sb->s_op = &hugetlbfs_ops;
 	sb->s_time_gran = 1;
+
+	/*
+	 * Due to the special and limited functionality of hugetlbfs, it does
+	 * not work well as a stacking filesystem.
+	 */
+	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 	sb->s_root = d_make_root(hugetlbfs_get_root(sb, ctx));
 	if (!sb->s_root)
 		goto out_free;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


