From: akpm@linux-foundation.org
Subject: + vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch added to -mm tree
Date: Sun, 25 Nov 2007 23:59:55 -0800
Message-ID: <200711260759.lAQ7xtiF023340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753333AbXKZIAK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:00:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, rientjes@google.com


The patch titled
     vmcoreinfo: add "VMCOREINFO_" to all the call for vmcoreinfo_append_str()
has been added to the -mm tree.  Its filename is
     vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

vmcoreinfo-rename-vmcoreinfos-macros-returning-the-size.patch
vmcoreinfo-use-the-existing-offsetof-for-vmcoreinfo_offset.patch
vmcoreinfo-add-vmcoreinfo_-to-all-the-call-for-vmcoreinfo_append_str.patch
vmcoreinfo-fix-the-configuration-dependencies.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
