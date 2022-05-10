Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1CFC433FE
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiEJEZB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiEJEXO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDE71CD27D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51241B81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF59C385C2;
        Tue, 10 May 2022 04:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156280;
        bh=cUNhNo7UG/Gy5qvhj0Lz8PQCkFVdOMee6wbgn3hc51E=;
        h=Date:To:From:Subject:From;
        b=ypnSgBh2Po+iQXrn8zf7LmKOmmYw89vF3gyh45hzSWpnh4MydWfLDvYB2bqGHIYyK
         d9NoWMLzRyrNX/AEHgyOCerWvuxCxwMm7rLCWqz9OLUSbzsPYrxxKFOYrE/gZaM2l6
         km1Ot9NbPm2v83fuO6sa6JfTXYk4OezvjDIXONOU=
Date:   Mon, 09 May 2022 21:17:59 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        juanfengpy@gmail.com, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch removed from -mm tree
Message-Id: <20220510041800.0BF59C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: proc: fix dentry/inode overinstantiating under /proc/${pid}/net
has been removed from the -mm tree.  Its filename was
     proc-fix-dentry-inode-overinstantiating-under-proc-pid-net.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: fix dentry/inode overinstantiating under /proc/${pid}/net

When a process exits, /proc/${pid}, and /proc/${pid}/net dentries are
flushed.  However some leaf dentries like /proc/${pid}/net/arp_cache
aren't.  That's because respective PDEs have proc_misc_d_revalidate() hook
which returns 1 and leaves dentries/inodes in the LRU.

Force revalidation/lookup on everything under /proc/${pid}/net by
inheriting proc_net_dentry_ops.

[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/YjdVHgildbWO7diJ@localhost.localdomain
Fixes: c6c75deda813 ("proc: fix lookup in /proc/net subdirectories after setns(2)")
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reported-by: hui li <juanfengpy@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |    3 +++
 fs/proc/proc_net.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/fs/proc/generic.c~proc-fix-dentry-inode-overinstantiating-under-proc-pid-net
+++ a/fs/proc/generic.c
@@ -448,6 +448,9 @@ static struct proc_dir_entry *__proc_cre
 	proc_set_user(ent, (*parent)->uid, (*parent)->gid);
 
 	ent->proc_dops = &proc_misc_dentry_ops;
+	/* Revalidate everything under /proc/${pid}/net */
+	if ((*parent)->proc_dops == &proc_net_dentry_ops)
+		pde_force_lookup(ent);
 
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

elf-uapi-fixup-elf_st_type-definition.patch

