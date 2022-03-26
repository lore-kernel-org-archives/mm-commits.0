Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677FBC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiCZD2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiCZD2g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:28:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4F115E8AB
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59348619E2
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD097C340F0;
        Sat, 26 Mar 2022 03:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648265219;
        bh=PS0CGn2EIumYSltpMiWtHcy8WE4ZP4zhpTILnYzh4J4=;
        h=Date:To:From:Subject:From;
        b=UMjha3unpJTY/5lL+rZZ9pbEnQe+EwoJMiIe4oAfrbPI2PsuOy21pBRG3Qbq6VQH7
         AuoHMLA/u8R79pOK4NqNqAR2apXCDHEjxZD583BY9WtufU+PHrXQDLJQs8g+sF/CXj
         fZ8ZtY0sY3HGdmUZcAmdEKEbZIIClWPWATdu+g5A=
Date:   Fri, 25 Mar 2022 20:26:58 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        juanfengpy@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch added to -mm tree
Message-Id: <20220326032659.AD097C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix dentry/inode overinstantiating under /proc/${pid}/net
has been added to the -mm tree.  Its filename is
     proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix dentry/inode overinstantiating under /proc/${pid}/net

When a process exits, /proc/${pid}, and /proc/${pid}/net dentries are
flushed.  However some leaf dentries like /proc/${pid}/net/arp_cache
aren't.  That's because respective PDEs have proc_misc_d_revalidate() hook
which returns 1 and leaves dentries/inodes in the LRU.

Force revalidation/lookup on everything under /proc/${pid}/net by
inheriting proc_net_dentry_ops.

Link: https://lkml.kernel.org/r/YjdVHgildbWO7diJ@localhost.localdomain
Fixes: c6c75deda813 ("proc: fix lookup in /proc/net subdirectories after setns(2)")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: hui li <juanfengpy@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |    4 ++++
 fs/proc/proc_net.c |    3 +++
 2 files changed, 7 insertions(+)

--- a/fs/proc/generic.c~proc-fix-dentry-inode-overinstantiating-under-proc-pid-net
+++ a/fs/proc/generic.c
@@ -448,6 +448,10 @@ static struct proc_dir_entry *__proc_cre
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
 
 	ent->proc_dops = &proc_misc_dentry_ops;
+	/* Revalidate everything under /proc/${pid}/net */
+	if ((*parent)->proc_dops == &proc_net_dentry_ops) {
+		pde_force_lookup(ent);
+	}
 
 out:
 	return ent;
--- a/fs/proc/proc_net.c~proc-fix-dentry-inode-overinstantiating-under-proc-pid-net
+++ a/fs/proc/proc_net.c
@@ -376,6 +376,9 @@ static __net_init int proc_net_ns_init(s
 
 	proc_set_user(netd, uid, gid);
 
+	/* Seed dentry revalidation for /proc/${pid}/net */
+	pde_force_lookup(netd);
+
 	err = -EEXIST;
 	net_statd = proc_net_mkdir(net, "stat", netd);
 	if (!net_statd)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch

