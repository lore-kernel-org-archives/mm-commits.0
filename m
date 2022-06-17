Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE83CCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379561AbiFQC7q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379910AbiFQC71 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7BF66214
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10971B826F8
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB239C34114;
        Fri, 17 Jun 2022 02:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434754;
        bh=FCvLhtruTHOCFjqXCo0cE2iuDqslFE7LgarJKYpPpq0=;
        h=Date:To:From:Subject:From;
        b=YVagsOhtOWga5FdbclkAhXZCDoOPGofu4RfpBaD7NuxhO3n24tVP/ikYefYnl02n+
         dGSuL9U0CBmljKKeyJmCxxLwSinBcX5E/LjBuNmBg52iJfx0CR7cIPBUybnDWfBqoe
         GnaPTFkPZk7SHtj1GB3F0618L9t3GCoViDPOWY4o=
Date:   Thu, 16 Jun 2022 19:59:14 -0700
To:     mm-commits@vger.kernel.org, yhs@fb.com, songliubraving@fb.com,
        mhiramat@kernel.org, kpsingh@kernel.org, kafai@fb.com,
        john.fastabend@gmail.com, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-error-inject-convert-to-define_seq_attribute.patch removed from -mm tree
Message-Id: <20220617025914.AB239C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/error-inject: convert to DEFINE_SEQ_ATTRIBUTE
has been removed from the -mm tree.  Its filename was
     lib-error-inject-convert-to-define_seq_attribute.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch

