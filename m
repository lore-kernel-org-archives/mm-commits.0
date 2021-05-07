Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F11C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AFC261164
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhEGAID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 20:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232375AbhEGAIC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 20:08:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 189B761104;
        Fri,  7 May 2021 00:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620346023;
        bh=gt+Hm4JlgT0KbVXxwWoSz78c2NyE4WXvZWcFZ7TrObw=;
        h=Date:From:To:Subject:From;
        b=bgnWHVoh7Sr64k8bHKXauAmBrspITYG2IwmnQ+xSAqRAHE/NLxFx+aW4p3OJb6SgE
         vsJ4fJXkU7bDJRsFW4kGiGE3Dw8dgiXlAS1IPEmYgNS2niuaQ0x25aqDlLseJ3igMS
         qXpT+l3or+ojuruUEtYEn7fcroETE8+rNQ+MEy+U=
Date:   Thu, 06 May 2021 17:07:02 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch removed from -mm tree
Message-ID: <20210507000702.iDNd2VHcn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: smoke test lseek()
has been removed from the -mm tree.  Its filename was
     proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch

This patch was dropped because it was folded into proc-mandate-proc_lseek-in-struct-proc_ops.patch

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: smoke test lseek()

Now that ->proc_lseek has been made mandatory it would be nice to test
that nothing has been forgotten.

Link: https://lkml.kernel.org/r/YG4OIhChOrVTPgdN@localhost.localdomain
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/read.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/read.c~proc-mandate-proc_lseek-in-struct-proc_ops-fix
+++ a/tools/testing/selftests/proc/read.c
@@ -14,7 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 // Test
-// 1) read of every file in /proc
+// 1) read and lseek on every file in /proc
 // 2) readlink of every symlink in /proc
 // 3) recursively (1) + (2) for every directory in /proc
 // 4) write to /proc/*/clear_refs and /proc/*/task/*/clear_refs
@@ -45,6 +45,8 @@ static void f_reg(DIR *d, const char *fi
 	fd = openat(dirfd(d), filename, O_RDONLY|O_NONBLOCK);
 	if (fd == -1)
 		return;
+	/* struct proc_ops::proc_lseek is mandatory if file is seekable. */
+	(void)lseek(fd, 0, SEEK_SET);
 	rv = read(fd, buf, sizeof(buf));
 	assert((0 <= rv && rv <= sizeof(buf)) || rv == -1);
 	close(fd);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-save-loc-in-__xlate_proc_name.patch
proc-mandate-proc_lseek-in-struct-proc_ops.patch
proc-delete-redundant-subset=pid-check.patch
proc-test-subset=pid.patch

