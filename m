From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch added
 to -mm tree
Date: Sun, 07 Jun 2020 17:21:03 -0700
Message-ID: <20200608002103.Zx6H0ejvH%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbgFHAVE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 7 Jun 2020 20:21:04 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mhiramat@kernel.org, mm-commits@vger.kernel.org, svens@linux.ibm.com


The patch titled
     Subject: kprobes: use strncpy_from_kernel_nofault() in fetch_store_string()
has been added to the -mm tree.  Its filename is
     tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

tracing-kprobes-handle-mixed-kernel-userspace-probes-better-fix.patch
