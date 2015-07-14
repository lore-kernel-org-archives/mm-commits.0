From: akpm@linux-foundation.org
Subject: + proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch added to
 -mm tree
Date: Tue, 14 Jul 2015 15:40:02 -0700
Message-ID: <55a58fc2.ZgGKupFlN/cFXAtS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbGNWkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 18:40:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/$PID/cmdline: fixup empty ARGV case
has been added to the -mm tree.  Its filename is
     proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: /proc/$PID/cmdline: fixup empty ARGV case

/proc/*/cmdline code checks if it should look at ENVP area by checking
last byte of ARGV area:

	rv = access_remote_vm(mm, arg_end - 1, &c, 1, 0);
	if (rv <= 0)
		goto out_free_page;

If ARGV is somehow made empty (by doing execve(..., NULL, ...) or
manually setting ->arg_start and ->arg_end to equal values), the decision
will be based on byte which doesn't even belong to ARGV/ENVP.

So, quickly check if ARGV area is empty and report 0 to match previous
behaviour.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/proc/base.c~proc-fixup-empty-argv-case-for-proc-pid-cmdline fs/proc/base.c
--- a/fs/proc/base.c~proc-fixup-empty-argv-case-for-proc-pid-cmdline
+++ a/fs/proc/base.c
@@ -243,6 +243,11 @@ static ssize_t proc_pid_cmdline_read(str
 	len1 = arg_end - arg_start;
 	len2 = env_end - env_start;
 
+	/* Empty ARGV. */
+	if (len1 == 0) {
+		rv = 0;
+		goto out_free_page;
+	}
 	/*
 	 * Inherently racy -- command line shares address space
 	 * with code and data.
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-fixup-empty-argv-case-for-proc-pid-cmdline.patch
kstrto-accept-0-for-signed-conversion.patch
add-parse_integer-replacement-for-simple_strto.patch
parse_integer-add-runtime-testsuite.patch
parse-integer-rewrite-kstrto.patch
parse_integer-convert-scanf.patch
scanf-fix-type-range-overflow.patch
parse_integer-convert-lib.patch
parse_integer-convert-mm.patch
parse_integer-convert-fs.patch
parse_integer-convert-fs-cachefiles.patch
parse_integer-convert-ext2-ext3-ext4.patch
parse_integer-convert-fs-ocfs2.patch
parse_integer-add-checkpatchpl-notice.patch

