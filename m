From: akpm@linux-foundation.org
Subject: [merged] sysctl-enable-strict-writes.patch removed from -mm tree
Date: Thu, 21 Jan 2016 15:28:13 -0800
Message-ID: <56a1698d.JIYap5vSn4Lp1mKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcAUX2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:28:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: enable strict writes
has been removed from the -mm tree.  Its filename was
     sysctl-enable-strict-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: sysctl: enable strict writes

SYSCTL_WRITES_WARN was added in f4aacea2f5d1a ("sysctl: allow for strict
write position handling"), and released in v3.16 in August of 2014.  Since
then I can find only 1 instance of non-zero offset writing[1], and it was
fixed immediately in CRIU[2].  As such, it appears safe to flip this to
the strict state now.

[1] https://www.google.com/search?q="when%20file%20position%20was%20not%200"
[2] http://lists.openvz.org/pipermail/criu/2015-April/019819.html

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   15 +++++++--------
 kernel/sysctl.c                 |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~sysctl-enable-strict-writes Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sysctl-enable-strict-writes
+++ a/Documentation/sysctl/kernel.txt
@@ -825,14 +825,13 @@ via the /proc/sys interface:
        Each write syscall must fully contain the sysctl value to be
        written, and multiple writes on the same sysctl file descriptor
        will rewrite the sysctl value, regardless of file position.
-   0 - (default) Same behavior as above, but warn about processes that
-       perform writes to a sysctl file descriptor when the file position
-       is not 0.
-   1 - Respect file position when writing sysctl strings. Multiple writes
-       will append to the sysctl value buffer. Anything past the max length
-       of the sysctl value buffer will be ignored. Writes to numeric sysctl
-       entries must always be at file position 0 and the value must be
-       fully contained in the buffer sent in the write syscall.
+   0 - Same behavior as above, but warn about processes that perform writes
+       to a sysctl file descriptor when the file position is not 0.
+   1 - (default) Respect file position when writing sysctl strings. Multiple
+       writes will append to the sysctl value buffer. Anything past the max
+       length of the sysctl value buffer will be ignored. Writes to numeric
+       sysctl entries must always be at file position 0 and the value must
+       be fully contained in the buffer sent in the write syscall.
 
 ==============================================================
 
diff -puN kernel/sysctl.c~sysctl-enable-strict-writes kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-enable-strict-writes
+++ a/kernel/sysctl.c
@@ -173,7 +173,7 @@ extern int no_unaligned_warning;
 #define SYSCTL_WRITES_WARN	 0
 #define SYSCTL_WRITES_STRICT	 1
 
-static int sysctl_writes_strict = SYSCTL_WRITES_WARN;
+static int sysctl_writes_strict = SYSCTL_WRITES_STRICT;
 
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
_

Patches currently in -mm which might be from keescook@chromium.org are


