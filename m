Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCE9C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJCVMr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJCVL1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F95F5142E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DEF611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2980C433C1;
        Mon,  3 Oct 2022 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831220;
        bh=8Wb2AgeNncnT8NoXg67BZnPPsgIC2LK003bQyZ4qoRw=;
        h=Date:To:From:Subject:From;
        b=LvzPeZtNVDRa4Nr3hH48lNOQnbvQ+RxbFODdnmsDpxAtAMDHIEuc5810XVGdg1wW4
         /SGYcirDsS/bxcnhf5iXj2kdPiuyfMcAtpE+nHukhfrge5S2+PlRUHmenBErMcEXVm
         EvGj4UCnVkuF/WHaDFisn9qtpmjZyxVwVhcxkaC4=
Date:   Mon, 03 Oct 2022 14:06:59 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-convert-to-define_seq_attribute.patch removed from -mm tree
Message-Id: <20221003210659.F2980C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: convert to DEFINE_SEQ_ATTRIBUTE
has been removed from the -mm tree.  Its filename was
     mm-kfence-convert-to-define_seq_attribute.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm: kfence: convert to DEFINE_SEQ_ATTRIBUTE
Date: Fri, 9 Sep 2022 16:31:40 +0800

Use DEFINE_SEQ_ATTRIBUTE helper macro to simplify the code.

Link: https://lkml.kernel.org/r/20220909083140.3592919-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/mm/kfence/core.c~mm-kfence-convert-to-define_seq_attribute
+++ a/mm/kfence/core.c
@@ -719,24 +719,13 @@ static int show_object(struct seq_file *
 	return 0;
 }
 
-static const struct seq_operations object_seqops = {
+static const struct seq_operations objects_sops = {
 	.start = start_object,
 	.next = next_object,
 	.stop = stop_object,
 	.show = show_object,
 };
-
-static int open_objects(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &object_seqops);
-}
-
-static const struct file_operations objects_fops = {
-	.open = open_objects,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(objects);
 
 static int __init kfence_debugfs_init(void)
 {
_

Patches currently in -mm which might be from liushixin2@huawei.com are


