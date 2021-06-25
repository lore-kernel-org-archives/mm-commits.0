Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F11C49EAB
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B25613C1
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhFYBlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFYBly (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE7D6044F;
        Fri, 25 Jun 2021 01:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585173;
        bh=Rl3INkCWLXQUZ+pg4mwfU0Rz3o+ozGzkbWJMmLIpk1A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gJvkjtUf27BQxW50JGOvzv91hHLghsv1nOo6OQxlp5Q4aaNOufZuLa2RjFvrkwihy
         txV8l7ARgaDLsSMFeMzzGUUrWLqSXkrE+QOHdAXz4lu7zhnSKCeoUJjzoxfZbDyMhh
         hPcKUB0ctMqurm6OmHyMiwkrRcHr72hJNmhQo26M=
Date:   Thu, 24 Jun 2021 18:39:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        linux-mm@kvack.org, mlsemon35@gmail.com,
        mm-commits@vger.kernel.org, paskripkin@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 11/24] nilfs2: fix memory leak in
 nilfs_sysfs_delete_device_group
Message-ID: <20210625013933.6EAm6MayP%akpm@linux-foundation.org>
In-Reply-To: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>
Subject: nilfs2: fix memory leak in nilfs_sysfs_delete_device_group

My local syzbot instance hit memory leak in nilfs2.  The problem was in
missing kobject_put() in nilfs_sysfs_delete_device_group().

kobject_del() does not call kobject_cleanup() for passed kobject and it
leads to leaking duped kobject name if kobject_put() was not called.

Fail log:

BUG: memory leak
unreferenced object 0xffff8880596171e0 (size 8):
  comm "syz-executor379", pid 8381, jiffies 4294980258 (age 21.100s)
  hex dump (first 8 bytes):
    6c 6f 6f 70 30 00 00 00                          loop0...
  backtrace:
    [<ffffffff81a2c656>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff81a2c6e3>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff83ccc698>] kvasprintf_const+0x108/0x190 lib/kasprintf.c:48
    [<ffffffff83e99926>] kobject_set_name_vargs+0x56/0x150 lib/kobject.c:289
    [<ffffffff83e99fd9>] kobject_add_varg lib/kobject.c:384 [inline]
    [<ffffffff83e99fd9>] kobject_init_and_add+0xc9/0x160 lib/kobject.c:473
    [<ffffffff8304e840>] nilfs_sysfs_create_device_group+0x150/0x800 fs/nilfs2/sysfs.c:999
    [<ffffffff830159f6>] init_nilfs+0xe26/0x12b0 fs/nilfs2/the_nilfs.c:637

Link: https://lkml.kernel.org/r/20210612140559.20022-1-paskripkin@gmail.com
Fixes: da7141fb78db ("nilfs2: add /sys/fs/nilfs2/<device> group")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Michael L. Semon <mlsemon35@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/sysfs.c~nilfs2-fix-memory-leak-in-nilfs_sysfs_delete_device_group
+++ a/fs/nilfs2/sysfs.c
@@ -1053,6 +1053,7 @@ void nilfs_sysfs_delete_device_group(str
 	nilfs_sysfs_delete_superblock_group(nilfs);
 	nilfs_sysfs_delete_segctor_group(nilfs);
 	kobject_del(&nilfs->ns_dev_kobj);
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 }
 
_
