Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B265C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9AF861179
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 04:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIEum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhDIEum (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 00:50:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F30261165;
        Fri,  9 Apr 2021 04:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617943829;
        bh=UA2qzqY5TnkEirRQ5ghXqHSnO9rR3smlgFMQ/izpxCg=;
        h=Date:From:To:Subject:From;
        b=QsuNWTx3flRAp666vBPvd2yvYBfMtlWeVdQNqnS1j8ndzWtSbnKGaRDFz2Opz9r87
         Pd3QScf3c1KI7exEPsv3tHA4TQhKN6I4RUr62vRFA2tC9p4bFeMEQA/pkc3CnuNpIv
         Q9PpfwtlkQVtXh234nGBm15eygtY+sdNtqTHqj9c=
Date:   Thu, 08 Apr 2021 21:50:28 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch
 added to -mm tree
Message-ID: <20210409045028.eIil5nb8E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: smoke test lseek()
has been added to the -mm tree.  Its filename is
     proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch

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
proc-mandate-proc_lseek-in-struct-proc_ops-fix.patch
proc-delete-redundant-subset=pid-check.patch
proc-test-subset=pid.patch

