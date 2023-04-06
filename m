Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F6EC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjDFCsY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjDFCr3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:47:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C589EE8
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B44F0642DC
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC3C4339B;
        Thu,  6 Apr 2023 02:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749132;
        bh=0cSmnBDj7sYlTMAK6BKirwNUJ0btfHKWuBHe5r+ldpo=;
        h=Date:To:From:Subject:From;
        b=X9nwLMnYPchmGJlUuzLytffR2v/7xh21iGERZxNHmKTSmNPz9f1ot069CQ7Xhs8zZ
         ECcaVZIQbc2UW58nyKdPxX57FEsQ1OR9AU1TjJTBeeM3Jba6L5626ojMF8gmLKQ5ta
         e6Ilhr8Cb1Cr/sND0yCuBqlLT+mTjbcIPbVnI3gw=
Date:   Wed, 05 Apr 2023 19:45:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, urezki@gmail.com, liushixin2@huawei.com,
        jolsa@kernel.org, david@redhat.com, bhe@redhat.com,
        axboe@kernel.dk, lstoakes@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch removed from -mm tree
Message-Id: <20230406024532.16DC3C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/kcore: avoid bounce buffer for ktext data
has been removed from the -mm tree.  Its filename was
     fs-proc-kcore-avoid-bounce-buffer-for-ktext-data.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: fs/proc/kcore: avoid bounce buffer for ktext data
Date: Wed, 22 Mar 2023 18:57:01 +0000

Patch series "convert read_kcore(), vread() to use iterators", v8.

While reviewing Baoquan's recent changes to permit vread() access to
vm_map_ram regions of vmalloc allocations, Willy pointed out [1] that it
would be nice to refactor vread() as a whole, since its only user is
read_kcore() and the existing form of vread() necessitates the use of a
bounce buffer.

This patch series does exactly that, as well as adjusting how we read the
kernel text section to avoid the use of a bounce buffer in this case as
well.

This has been tested against the test case which motivated Baoquan's
changes in the first place [2] which continues to function correctly, as
do the vmalloc self tests.


This patch (of 4):

Commit df04abfd181a ("fs/proc/kcore.c: Add bounce buffer for ktext data")
introduced the use of a bounce buffer to retrieve kernel text data for
/proc/kcore in order to avoid failures arising from hardened user copies
enabled by CONFIG_HARDENED_USERCOPY in check_kernel_text_object().

We can avoid doing this if instead of copy_to_user() we use
_copy_to_user() which bypasses the hardening check.  This is more
efficient than using a bounce buffer and simplifies the code.

We do so as part an overall effort to eliminate bounce buffer usage in the
function with an eye to converting it an iterator read.

Link: https://lkml.kernel.org/r/cover.1679566220.git.lstoakes@gmail.com
Link: https://lore.kernel.org/all/Y8WfDSRkc%2FOHP3oD@casper.infradead.org/ [1]
Link: https://lore.kernel.org/all/87ilk6gos2.fsf@oracle.com/T/#u [2]
Link: https://lkml.kernel.org/r/fd39b0bfa7edc76d360def7d034baaee71d90158.1679511146.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-avoid-bounce-buffer-for-ktext-data
+++ a/fs/proc/kcore.c
@@ -541,19 +541,12 @@ read_kcore(struct file *file, char __use
 		case KCORE_VMEMMAP:
 		case KCORE_TEXT:
 			/*
-			 * Using bounce buffer to bypass the
-			 * hardened user copy kernel text checks.
+			 * We use _copy_to_user() to bypass usermode hardening
+			 * which would otherwise prevent this operation.
 			 */
-			if (copy_from_kernel_nofault(buf, (void *)start, tsz)) {
-				if (clear_user(buffer, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
-			} else {
-				if (copy_to_user(buffer, buf, tsz)) {
-					ret = -EFAULT;
-					goto out;
-				}
+			if (_copy_to_user(buffer, (char *)start, tsz)) {
+				ret = -EFAULT;
+				goto out;
 			}
 			break;
 		default:
_

Patches currently in -mm which might be from lstoakes@gmail.com are


