From: akpm@linux-foundation.org
Subject: [folded-merged]
 tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 20:23:15 -0700
Message-ID: <20200609032315.5hzLSIzeT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgFIDXQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 23:23:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org, svens@linux.ibm.com


The patch titled
     Subject: kprobes: use strncpy_from_kernel_nofault() in fetch_store_string()
has been removed from the -mm tree.  Its filename was
     tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch

This patch was dropped because it was folded into tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch

------------------------------------------------------
From: Sven Schnelle <svens@linux.ibm.com>
Subject: kprobes: use strncpy_from_kernel_nofault() in fetch_store_string()

With the latest linux-next i noticed that some tests in the ftrace test
suites are failing on s390, namely:

[FAIL] Kprobe event symbol argument
[FAIL] Kprobe event with comm arguments

The following doesn't work anymore:

cd /sys/kernel/tracing
echo 'p:testprobe _do_fork comm=$comm ' >kprobe_events
echo 1 >events/kprobes/testprobe/enable
cat trace

it will just show

test.sh-519   [012] ....    18.580625: testprobe: (_do_fork+0x0/0x3c8) comm=(fault)

Looking at the source i see that there are two helpers for reading strings:

fetch_store_string_user() -> read string from user space
fetch_store_string() -> read string from kernel space(?)

but in the end both are using strncpy_from_user_nofault(), but
fetch_store_string() should use strncpy_from_kernel_nofault().

Link: http://lkml.kernel.org/r/20200606181903.49384-1-svens@linux.ibm.com
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/trace/trace_kprobe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_kprobe.c~tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix
+++ a/kernel/trace/trace_kprobe.c
@@ -1278,7 +1278,7 @@ fetch_store_string(unsigned long addr, v
 	 * Try to get string again, since the string can be changed while
 	 * probing.
 	 */
-	ret = strncpy_from_user_nofault(__dest, (void *)addr, maxlen);
+	ret = strncpy_from_kernel_nofault(__dest, (void *)addr, maxlen);
 	if (ret >= 0)
 		*(u32 *)dest = make_data_loc(ret, __dest - base);
 
_

Patches currently in -mm which might be from svens@linux.ibm.com are

tracing-kprobes-handle-mixed-kernel-userspace-probes-better.patch
