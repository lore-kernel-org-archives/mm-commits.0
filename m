Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F0BC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B103961250
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhKKC4I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234509AbhKKC4I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:56:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98FD760F46;
        Thu, 11 Nov 2021 02:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599199;
        bh=HtcwJW2LFCGD100/kc/AvkqIMqXCf8T27vrWl//Fork=;
        h=Date:From:To:Subject:From;
        b=a6/xou6bfEofrPuRf9ky/xJhzOpAnnEa+h99+cgi0UxgahC4rjsprKTlnSSak2Rwq
         ltPlbeSYvP4EKCOJqAJtCs1pd5sLO1MWZK2Wti96t6sGTTPVRwNwVn8Yaz9jMiiRcZ
         wLcPjbNRi/e5I89Jeu8m3MsNcbW5DeFCzZkz2gbs=
Date:   Wed, 10 Nov 2021 18:53:19 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, jaharkes@cs.cmu.edu,
        jing.yangyang@zte.com.cn, mm-commits@vger.kernel.org,
        tanxin.ctf@gmail.com, xiyuyang19@fudan.edu.cn, zealci@zte.com.cn
Subject:  [merged] coda-avoid-flagging-null-inodes.patch removed
 from -mm tree
Message-ID: <20211111025319.TdqRPe3cE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: coda: avoid flagging NULL inodes
has been removed from the -mm tree.  Its filename was
     coda-avoid-flagging-null-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: coda: avoid flagging NULL inodes

Somehow we hit a negative dentry in coda_rename even after checking with
d_really_is_positive.  Maybe something raced and turned the new_dentry
negative while we were fixing up directory link counts.

Link: https://lkml.kernel.org/r/20210908140308.18491-5-jaharkes@cs.cmu.edu
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Jing Yangyang <jing.yangyang@zte.com.cn>
Cc: Xin Tan <tanxin.ctf@gmail.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/coda_linux.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/coda/coda_linux.h~coda-avoid-flagging-null-inodes
+++ a/fs/coda/coda_linux.h
@@ -83,6 +83,9 @@ static __inline__ void coda_flag_inode(s
 {
 	struct coda_inode_info *cii = ITOC(inode);
 
+	if (!inode)
+		return;
+
 	spin_lock(&cii->c_lock);
 	cii->c_flags |= flag;
 	spin_unlock(&cii->c_lock);
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are


