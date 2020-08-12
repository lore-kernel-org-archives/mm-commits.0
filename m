Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7AD5C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8089320829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195924;
	bh=LR4UGW+njSoXnZHAIRR0pSvQ0DPvccZZtLZeliQC1Vg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WcKEXgbeWkv3TY1rp0VJqGxcuBWEIOTIMTTuqjF4d1wrKxAHN/+37+ubI73yEcBjE
	 Uxt6Ycv1B3on2ZtzI7sc4TstUZ/FTkVVKQdE0eXSmKSNdLa89ZPyHPRouXX3N4vojQ
	 2ybyym8Q7wB86y7x8+gX/nD0Tqrdh9f2lVQvTevs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLBbh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbgHLBbg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAA62076C;
        Wed, 12 Aug 2020 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195896;
        bh=LR4UGW+njSoXnZHAIRR0pSvQ0DPvccZZtLZeliQC1Vg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R3/JLmzK/OuNfC0EC3L2nL9tGRjuxBTBY7N1mPutFJpnR0UVxWIBrfSms0x81zEXE
         DJqLobslLTaetLjxNJ5amsU2FfNYtR5H+9qKPQQaEOM69kz3h4CEd1YxEfK4jVEYD1
         zgOOAZljpExVAZ3/6t3kPNkcZn/wdqhXFR0kVTgs=
Date:   Tue, 11 Aug 2020 18:31:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amir73il@gmail.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mszeredi@redhat.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, walters@verbum.org, willy@infradead.org
Subject:  [patch 025/165] hugetlbfs: prevent filesystem stacking of
 hugetlbfs
Message-ID: <20200812013135.OJVdJOjRJ%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
