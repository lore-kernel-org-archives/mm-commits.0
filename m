Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 899A0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7407A61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhKKC4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234502AbhKKC4G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 789BB6103C;
        Thu, 11 Nov 2021 02:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599197;
        bh=sANw8inKrJ1qTzJtdf6GAT2n6sgf4fxGtvShMIPVLz0=;
        h=Date:From:To:Subject:From;
        b=fgZu04xVeSZl1KiwJDYlZ/Yavu1Kh93IMaSpzfmNoWrjifci84QMZWhteTSyiJtEi
         pWsLEV9/WyUn5I0ubRlw4UicKJh2t1UYGbeSwNv2eR/EybyWAaC5i0kWU2wCjgX2y9
         DF/bIPR/ZpJiLDvTIHceBUimgDgfIg8b/mQK5tpU=
Date:   Wed, 10 Nov 2021 18:53:17 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged] coda-remove-err-which-no-one-care.patch removed
 from -mm tree
Message-ID: <20211111025317.hKM17S2E9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: remove err which no one care
has been removed from the -mm tree.  Its filename was
     coda-remove-err-which-no-one-care.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: coda: remove err which no one care

No one care 'err' in func coda_release, so better remove it.

Link: https://lkml.kernel.org/r/20210908140308.18491-4-jaharkes@cs.cmu.edu
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/coda/file.c~coda-remove-err-which-no-one-care
+++ a/fs/coda/file.c
@@ -238,11 +238,10 @@ int coda_release(struct inode *coda_inod
 	struct coda_file_info *cfi;
 	struct coda_inode_info *cii;
 	struct inode *host_inode;
-	int err;
 
 	cfi = coda_ftoc(coda_file);
 
-	err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
+	venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
 			  coda_flags, coda_file->f_cred->fsuid);
 
 	host_inode = file_inode(cfi->cfi_container);
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are


