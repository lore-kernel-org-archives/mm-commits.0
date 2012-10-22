From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-fix-stack-memory-content-leak-via-uname26.patch removed from -mm tree
Date: Mon, 22 Oct 2012 12:13:24 -0700
Message-ID: <20121022191324.BB9F01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37918 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2JVTNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Oct 2012 15:13:25 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so378421yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Oct 2012 12:13:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ak@linux.intel.com, pageexec@freemail.hu, spender@grsecurity.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: fix stack memory content leak via UNAME26
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-stack-memory-content-leak-via-uname26.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kernel/sys.c: fix stack memory content leak via UNAME26

Calling uname() with the UNAME26 personality set allows a leak of kernel
stack contents.  This fixes it by defensively calculating the length of
copy_to_user() call, making the len argument unsigned, and initializing
the stack buffer to zero (now technically unneeded, but hey, overkill).

CVE-2012-0957

Reported-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-fix-stack-memory-content-leak-via-uname26 kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-stack-memory-content-leak-via-uname26
+++ a/kernel/sys.c
@@ -1265,15 +1265,16 @@ DECLARE_RWSEM(uts_sem);
  * Work around broken programs that cannot handle "Linux 3.0".
  * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
  */
-static int override_release(char __user *release, int len)
+static int override_release(char __user *release, size_t len)
 {
 	int ret = 0;
-	char buf[65];
 
 	if (current->personality & UNAME26) {
-		char *rest = UTS_RELEASE;
+		const char *rest = UTS_RELEASE;
+		char buf[65] = { 0 };
 		int ndots = 0;
 		unsigned v;
+		size_t copy;
 
 		while (*rest) {
 			if (*rest == '.' && ++ndots >= 3)
@@ -1283,8 +1284,9 @@ static int override_release(char __user 
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		snprintf(buf, len, "2.6.%u%s", v, rest);
-		ret = copy_to_user(release, buf, len);
+		copy = min(sizeof(buf), max_t(size_t, 1, len));
+		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
+		ret = copy_to_user(release, buf, copy + 1);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
proc-dont-show-nonexistent-capabilities.patch

