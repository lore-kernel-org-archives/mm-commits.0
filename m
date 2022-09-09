Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0322FECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 21:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiIIV6U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiIIV6R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 17:58:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB30110A99
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 14:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBB5262107
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 21:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E23C433C1;
        Fri,  9 Sep 2022 21:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760694;
        bh=auFbShl8rdRXVhJVMMljvWLyutXVXmejfHMzsGtnm9k=;
        h=Date:To:From:Subject:From;
        b=Bjq7y2x3+LMFSin+dxltMKGM/mOyH+UI9NONWFK852kOgwNjKpuIOKJz3Dagya3d0
         nBQ3sui9lBhytTFxbuU+E05UZX4Jsks9d12cKAcm8dL8e4ptQ4r0mCSnalSRbwSfFp
         +6UxAjKmtAinYRNfiyKSNt094K7jTtU4ZYweDvIk=
Date:   Fri, 09 Sep 2022 14:58:13 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-convert-to-define_seq_attribute.patch added to mm-unstable branch
Message-Id: <20220909215814.49E23C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kfence: convert to DEFINE_SEQ_ATTRIBUTE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-convert-to-define_seq_attribute.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-convert-to-define_seq_attribute.patch

This patch will later appear in the mm-unstable branch at
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

mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch
mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch

