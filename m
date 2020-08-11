Return-Path: <SRS0=Ir1+=BV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5478C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 21:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7221E2076B
	for <mm-commits@archiver.kernel.org>; Tue, 11 Aug 2020 21:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597180588;
	bh=JFAngJ7tXeMj6+vwB/ctGB51vAQLpK0kVp+hTYlmjNY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qWqddLp2vf/u/GTUL88RSI19LIcjq0oMgZX/ZN1RCpFJV+tNqoDZcQ3AUujHcI+BY
	 TJrYFZzf1hUL5Na/RLqobHqSZyxr4Qsnhq7v/VqnfeHIaoIUuYTlKJmthcOIVwjvD5
	 wcDdVQ7pBXMZvWX3YwBa99+ZiIDnHQufcqRfn9e0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKVQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 17:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgHKVQ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 17:16:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94415205CB;
        Tue, 11 Aug 2020 21:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597180587;
        bh=JFAngJ7tXeMj6+vwB/ctGB51vAQLpK0kVp+hTYlmjNY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u66CvgASk9xg8NMSpVBTDl3/rpTXSDE2zedYIpYjeqGpXT0kz56ZrOZlnBpML8OxV
         luSSKO80ualaEMLJytQc3Bo9tmsTOzD3mQKQZqTL9ftE6hZxQMJmyFRisa7JfW2m9/
         Gp7ZIgALWcrblOfSQ4iEIzBA/I9b+10jb2jro2Fk=
Date:   Tue, 11 Aug 2020 14:16:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     dhowells@redhat.com, libing.zhou@nokia-sbell.com,
        mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  + romfs-support-inode-blocks-calculation.patch added to
 -mm tree
Message-ID: <20200811211627.WFoN4zSXu%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ROMFS: support inode blocks calculation
has been added to the -mm tree.  Its filename is
     romfs-support-inode-blocks-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/romfs-support-inode-blocks-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/romfs-support-inode-blocks-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from libing.zhou@nokia-sbell.com are

romfs-support-inode-blocks-calculation.patch

