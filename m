From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-sysc-fix-stack-memory-content-leak-via-uname26.patch removed from -mm tree
Date: Thu, 11 Oct 2012 14:06:31 -0700
Message-ID: <20121011210632.7D8415C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:58636 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab2JKVGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 17:06:36 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so141020lah.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 14:06:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ak@linux.intel.com, pageexec@freemail.hu, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c:uname(): fix stack memory content leak via UNAME26
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-stack-memory-content-leak-via-uname26.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: kernel/sys.c:uname(): fix stack memory content leak via UNAME26

Calling uname() with the UNAME26 personality set allows a leak of kernel
stack contents.  This fixes it by initializing the stack buffer to zero,
defensively calculating the length of copy_to_user() call, and making the
len argument unsigned.

CVE-2012-0957

Reported-by: PaX Team <pageexec@freemail.hu>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-fix-stack-memory-content-leak-via-uname26 kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-stack-memory-content-leak-via-uname26
+++ a/kernel/sys.c
@@ -1265,13 +1265,13 @@ DECLARE_RWSEM(uts_sem);
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
 
@@ -1283,7 +1283,9 @@ static int override_release(char __user 
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		snprintf(buf, len, "2.6.%u%s", v, rest);
+		snprintf(buf, sizeof(buf), "2.6.%u%s", v, rest);
+		if (sizeof(buf) < len)
+			len = sizeof(buf);
 		ret = copy_to_user(release, buf, len);
 	}
 	return ret;
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
proc-dont-show-nonexistent-capabilities.patch

