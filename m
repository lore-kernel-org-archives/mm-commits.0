From: akpm@linux-foundation.org
Subject: + fix-utrace-utrace-ptrace-compat.patch added to -mm tree
Date: Wed, 07 Feb 2007 16:03:33 -0800
Message-ID: <200702080004.l1804epK032032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46721 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423045AbXBHAE5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:04:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, roland@redhat.com


The patch titled
     fix utrace-utrace-ptrace-compat
has been added to the -mm tree.  Its filename is
     fix-utrace-utrace-ptrace-compat.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix utrace-utrace-ptrace-compat
From: Andrew Morton <akpm@linux-foundation.org>

kernel/ptrace.c: In function 'compat_sys_ptrace':
kernel/ptrace.c:955: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'compat_long_t'

Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/ptrace.c~fix-utrace-utrace-ptrace-compat kernel/ptrace.c
--- a/kernel/ptrace.c~fix-utrace-utrace-ptrace-compat
+++ a/kernel/ptrace.c
@@ -952,7 +952,7 @@ asmlinkage long compat_sys_ptrace(compat
 out_tsk:
 	put_task_struct(child);
 out:
-	pr_debug("%d ptrace -> %lx\n", current->pid, ret);
+	pr_debug("%d ptrace -> %lx\n", current->pid, (long)ret);
 	return ret;
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-warning-in-device_add_attrs.patch
git-dvb.patch
kthread-api-conversion-for-dvb_frontend-and-av7110-fix.patch
git-libata-all.patch
sis-warning-fixes.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
git-sh.patch
git-block.patch
git-cryptodev-fixup.patch
mm-vm_insert_pfn-tidy.patch
swiotlb-uninlinings.patch
spi-filesystem-api-tweaks.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
fix-utrace-utrace-ptrace-compat.patch
