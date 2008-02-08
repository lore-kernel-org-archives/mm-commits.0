From: akpm@linux-foundation.org
Subject: - vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:51 -0800
Message-ID: <200802080806.m1886Wg1014460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761955AbYBHIUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     vmcoreinfo: add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
has been removed from the -mm tree.  Its filename was
     vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcoreinfo: add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

For readability, all the calls to vmcoreinfo_append_str() are changed to macros
having a prefix "VMCOREINFO_".

This discussion is the following:
http://www.ussg.iu.edu/hypermail/linux/kernel/0709.3/0584.html

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |    4 ++++
 kernel/kexec.c        |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/kexec.h~vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str include/linux/kexec.h
--- a/include/linux/kexec.h~vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str
+++ a/include/linux/kexec.h
@@ -127,6 +127,10 @@ void vmcoreinfo_append_str(const char *f
 	__attribute__ ((format (printf, 1, 2)));
 unsigned long paddr_vmcoreinfo_note(void);
 
+#define VMCOREINFO_OSRELEASE(name) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", #name)
+#define VMCOREINFO_PAGESIZE(value) \
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
 #define VMCOREINFO_SYMBOL(name) \
 	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
 #define VMCOREINFO_SIZE(name) \
diff -puN kernel/kexec.c~vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str kernel/kexec.c
--- a/kernel/kexec.c~vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str
+++ a/kernel/kexec.c
@@ -1361,8 +1361,8 @@ unsigned long __attribute__ ((weak)) pad
 
 static int __init crash_save_vmcoreinfo_init(void)
 {
-	vmcoreinfo_append_str("OSRELEASE=%s\n", init_uts_ns.name.release);
-	vmcoreinfo_append_str("PAGESIZE=%ld\n", PAGE_SIZE);
+	VMCOREINFO_OSRELEASE(init_uts_ns.name.release);
+	VMCOREINFO_PAGESIZE(PAGE_SIZE);
 
 	VMCOREINFO_SYMBOL(init_uts_ns);
 	VMCOREINFO_SYMBOL(node_online_map);
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

origin.patch
