From: akpm@linux-foundation.org
Subject: + kprobe-increase-kprobe_hash_table-size.patch added to -mm tree
Date: Fri, 07 Nov 2008 17:04:19 -0800
Message-ID: <200811080104.mA814JQx011177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbYKHBFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 20:05:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com


The patch titled
     kprobes: increase kprobe_hash_table size
has been added to the -mm tree.  Its filename is
     kprobe-increase-kprobe_hash_table-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: increase kprobe_hash_table size
From: Masami Hiramatsu <mhiramat@redhat.com>

Increase the size of kprobe hash table to 512. It's useful when hundreds
of kprobes were used in the kernel because current size is just 64.

When probing enters and exits of syscall-related functions, we need more
than 500 probes.  In that case, each hlist would have 8 elements in
average.  With this patch, the hlist would have 1 element in average.


akpm: bloat alert:

   text    data     bss     dec     hex filename
   7036     744    9380   17160    4308 kernel/kprobes.o
   7048     744   73892   81684   13f14 kernel/kprobes.o

That's 64 kbytes more memory.  It is due to kretprobe_table_locks[], which
uses ____cacheline_aligned.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kprobes.c~kprobe-increase-kprobe_hash_table-size kernel/kprobes.c
--- a/kernel/kprobes.c~kprobe-increase-kprobe_hash_table-size
+++ a/kernel/kprobes.c
@@ -49,7 +49,7 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-#define KPROBE_HASH_BITS 6
+#define KPROBE_HASH_BITS 9
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
 
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-disable-preempt-for-module_text_address-and-kernel_text_address.patch
kprobe-increase-kprobe_hash_table-size.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch

