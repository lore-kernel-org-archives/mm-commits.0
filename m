From: akpm@linux-foundation.org
Subject: + fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy.patch
 added to -mm tree
Date: Wed, 06 Dec 2017 16:44:03 -0800
Message-ID: <5a288ed3.KsDVHpMHBkQxpTg3%akpm__31548.8765285865$1512607445$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdLGAoE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2017 19:44:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, jolsa@kernel.org, keescook@chromium.org, stable@vger.kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore.c: use probe_kernel_read() instead of memcpy()
has been added to the -mm tree.  Its filename is
     fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
-
 				/*
 				 * Using bounce buffer to bypass the
 				 * hardened user copy kernel text checks.
 				 */
-				memcpy(buf, (char *) start, tsz);
-				n = copy_to_user(buffer, buf, tsz);
-				/*
-				 * We cannot distinguish between fault on source
-				 * and fault on destination. When this happens
-				 * we clear too and hope it will trigger the
-				 * EFAULT again.
-				 */
-				if (n) { 
-					if (clear_user(buffer + tsz - n,
-								n))
+				if (probe_kernel_read(buf, (void *) start, tsz)) {
+					if (clear_user(buffer, tsz))
+						return -EFAULT;
+				} else {
+					if (copy_to_user(buffer, buf, tsz))
 						return -EFAULT;
 				}
 			} else {
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

fs-proc-kcorec-use-probe_kernel_read-instead-of-memcpy.patch

