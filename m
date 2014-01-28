From: akpm@linux-foundation.org
Subject: [merged]
 kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:47 -0800
Message-ID: <52e8007b.2n19pG7R4c+xbM0f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbaA1TJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch removed from -mm tree
To: gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:47 -0800


The patch titled
     Subject: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcoreinfo_append_str()
has been removed from the -mm tree.  Its filename was
     kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcoreinfo_append_str()

vsnprintf() may let 'r' larger than sizeof(buf), in this case, if 'r' is
also less than "vmcoreinfo_max_size - vmcoreinfo_size" (left size of
destination buffer), next memcpy() will read the unexpected addresses.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kexec.c~kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str kernel/kexec.c
--- a/kernel/kexec.c~kernel-kexecc-use-vscnprintf-instead-of-vsnprintf-in-vmcoreinfo_append_str
+++ a/kernel/kexec.c
@@ -1537,7 +1537,7 @@ void vmcoreinfo_append_str(const char *f
 	size_t r;
 
 	va_start(args, fmt);
-	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	r = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
 	r = min(r, vmcoreinfo_max_size - vmcoreinfo_size);
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch

