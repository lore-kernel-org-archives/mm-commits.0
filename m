Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EC3C43334
	for <mm-commits@archiver.kernel.org>; Mon, 13 Jun 2022 20:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbiFMUas (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Jun 2022 16:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiFMU1r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jun 2022 16:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E6638A8
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 12:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A188E61486
        for <mm-commits@vger.kernel.org>; Mon, 13 Jun 2022 19:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0368FC34114;
        Mon, 13 Jun 2022 19:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655147687;
        bh=n3KcnU5+7zNCxpcT2fUFq40Dy6lR+3BgX5MjpvsB4rM=;
        h=Date:To:From:Subject:From;
        b=Y1mN9HdOfo9XZ1wsI1ZLDW9Lf/BFsYO86CQ7s0W3ePdTS+/91sr2tH1VsVyl4qn4e
         S0TdQOV5Ut34LQQ4LcMpI2KPmg3YpNd1BubLjV2t2A2mcOT5Dw5003qi3XzlZGoRci
         5GNCAmFXFCGvajMywssl0gwfwq+90OrIb+KgBoHc=
Date:   Mon, 13 Jun 2022 12:14:46 -0700
To:     mm-commits@vger.kernel.org, yhs@fb.com, songliubraving@fb.com,
        mhiramat@kernel.org, kpsingh@kernel.org, kafai@fb.com,
        john.fastabend@gmail.com, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-error-inject-convert-to-define_seq_attribute.patch added to mm-nonmm-unstable branch
Message-Id: <20220613191447.0368FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/error-inject: convert to DEFINE_SEQ_ATTRIBUTE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-error-inject-convert-to-define_seq_attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-error-inject-convert-to-define_seq_attribute.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: wuchi <wuchi.zero@gmail.com>
Subject: lib/error-inject: convert to DEFINE_SEQ_ATTRIBUTE
Date: Sun, 12 Jun 2022 13:20:15 +0800

Use DEFINE_SEQ_ATTRIBUTE helper macro to simplify the code.

Link: https://lkml.kernel.org/r/20220612052015.23283-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/error-inject.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/lib/error-inject.c~lib-error-inject-convert-to-define_seq_attribute
+++ a/lib/error-inject.c
@@ -197,24 +197,14 @@ static int ei_seq_show(struct seq_file *
 	return 0;
 }
 
-static const struct seq_operations ei_seq_ops = {
+static const struct seq_operations ei_sops = {
 	.start = ei_seq_start,
 	.next  = ei_seq_next,
 	.stop  = ei_seq_stop,
 	.show  = ei_seq_show,
 };
 
-static int ei_open(struct inode *inode, struct file *filp)
-{
-	return seq_open(filp, &ei_seq_ops);
-}
-
-static const struct file_operations debugfs_ei_ops = {
-	.open           = ei_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = seq_release,
-};
+DEFINE_SEQ_ATTRIBUTE(ei);
 
 static int __init ei_debugfs_init(void)
 {
@@ -224,7 +214,7 @@ static int __init ei_debugfs_init(void)
 	if (!dir)
 		return -ENOMEM;
 
-	file = debugfs_create_file("list", 0444, dir, NULL, &debugfs_ei_ops);
+	file = debugfs_create_file("list", 0444, dir, NULL, &ei_fops);
 	if (!file) {
 		debugfs_remove(dir);
 		return -ENOMEM;
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-flex_proportionsc-remove-local_irq_ops-in-fprop_new_period.patch
lib-btree-simplify-btree_lookupupdate.patch
lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
lib-error-inject-convert-to-define_seq_attribute.patch

