From: akpm@linux-foundation.org
Subject: [patch 021/114] fs/proc/kcore.c: use probe_kernel_read()
 instead of memcpy()
Date: Tue, 06 Feb 2018 15:37:13 -0800
Message-ID: <20180206233713.O7PKX5ODz%akpm__29610.6833885007$1517960119$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXhQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:37:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, heiko.carstens@de.ibm.com, jolsa@kernel.org, keescook@chromium.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: fs/proc/kcore.c: use probe_kernel_read() instead of memcpy()

df04abfd181a ("fs/proc/kcore.c: Add bounce buffer for ktext data") added a
bounce buffer to avoid hardened usercopy checks.  Copying to the bounce
buffer was implemented with a simple memcpy() assuming that it is always
valid to read from kernel memory iff the kern_addr_valid() check passed.

A simple, but pointless, test case like "dd if=/proc/kcore of=/dev/null"
now can easily crash the kernel, since the former execption handling on
invalid kernel addresses now doesn't work anymore.

Also adding a kern_addr_valid() implementation wouldn't help here.  Most
architectures simply return 1 here, while a couple implemented a page
table walk to figure out if something is mapped at the address in
question.

With DEBUG_PAGEALLOC active mappings are established and removed all the
time, so that relying on the result of kern_addr_valid() before executing
the memcpy() also doesn't work.

Therefore simply use probe_kernel_read() to copy to the bounce buffer. 
This also allows to simplify read_kcore().

At least on s390 this fixes the observed crashes and doesn't introduce
warnings that were removed with df04abfd181a ("fs/proc/kcore.c: Add bounce
buffer for ktext data"), even though the generic probe_kernel_read()
implementation uses uaccess functions.

While looking into this I'm also wondering if kern_addr_valid() could be
completely removed...(?)

Link: http://lkml.kernel.org/r/20171202132739.99971-1-heiko.carstens@de.ibm.com
Fixes: df04abfd181a ("fs/proc/kcore.c: Add bounce buffer for ktext data")
Fixes: f5509cc18daa ("mm: Hardened usercopy")
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -puN fs/proc/kcore.c~fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy fs/proc/kcore.c
--- a/fs/proc/kcore.c~fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy
+++ a/fs/proc/kcore.c
@@ -512,23 +512,15 @@ read_kcore(struct file *file, char __use
 				return -EFAULT;
 		} else {
 			if (kern_addr_valid(start)) {
-				unsigned long n;
