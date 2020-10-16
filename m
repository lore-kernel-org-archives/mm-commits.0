Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 113F3C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F7320897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816641;
	bh=Pb5HyaYy5wPRxs7I9/6HO+7jyJgjiX7hLIbtEfgCEfA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WCsM0bnutel9ARS3mghGn+8RAiNXmeYqIebK4O9CkCeIAABOEiSB+Q+75O8/pJKy/
	 W+1rj6OQCwJJRILDbBQGe2N9KCYjvo81MhwMf+r/puvQ2V4s5KV/dURoV8nmMHIRcO
	 07dLjjWmuQqUcDmAgLQw7FjgiK9D2AqCNWfatl44=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404162AbgJPCul (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404127AbgJPCul (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEC2208E4;
        Fri, 16 Oct 2020 02:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816639;
        bh=Pb5HyaYy5wPRxs7I9/6HO+7jyJgjiX7hLIbtEfgCEfA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qJLssOHPFrrBSggkH2uhnnU0g8sitEkbGSNJWid4LwOX3uimGoJJzBpul8ybS1McD
         vQyLRG25br1YjTJ/UWPFuNtKn9FAMHbnNhEsUjkUI79fnnwlnaFCs1QMbJl7Sh51zj
         9ocY+1e7Emf1JRHkchm22Qs0nWmbQtS2rc/pthtM=
Date:   Thu, 15 Oct 2020 19:50:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        libing.zhou@nokia-sbell.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 154/156] ROMFS: support inode blocks calculation
Message-ID: <20201016025038.CfvMBxhwT%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Libing Zhou <libing.zhou@nokia-sbell.com>
Subject: ROMFS: support inode blocks calculation

When use 'stat' tool to display file status, the 'Blocks' field always in
'0', this is not good for tool 'du'(e.g.: busybox 'du'), it always output
'0' size for the files under ROMFS since such tool calculates number of
512B Blocks.

This patch calculates approx.  number of 512B blocks based on inode size.

Link: http://lkml.kernel.org/r/20200811052606.4243-1-libing.zhou@nokia-sbell.com
Signed-off-by: Libing Zhou <libing.zhou@nokia-sbell.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/romfs/super.c~romfs-support-inode-blocks-calculation
+++ a/fs/romfs/super.c
@@ -356,6 +356,7 @@ static struct inode *romfs_iget(struct s
 	}
 
 	i->i_mode = mode;
+	i->i_blocks = (i->i_size + 511) >> 9;
 
 	unlock_new_inode(i);
 	return i;
_
