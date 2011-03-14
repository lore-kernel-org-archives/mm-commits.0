From: akpm@linux-foundation.org
Subject: + proc-protect-mm-start_code-end_code-in-proc-pid-stat.patch added to -mm tree
Date: Mon, 14 Mar 2011 14:37:24 -0700
Message-ID: <201103142137.p2ELbOew012285@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756020Ab1CNViT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Mar 2011 17:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees.cook@canonical.com, adobriyan@gmail.com, dhowells@redhat.com, eugeneteo@kernel.sg, schwidefsky@de.ibm.com, spender@grsecurity.net, stable@kernel.org


The patch titled
     proc: protect mm start_code/end_code in /proc/pid/stat
has been added to the -mm tree.  Its filename is
     proc-protect-mm-start_code-end_code-in-proc-pid-stat.patch

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
Subject: proc: protect mm start_code/end_code in /proc/pid/stat
From: Kees Cook <kees.cook@canonical.com>

While mm->start_stack was protected from cross-uid viewing (commit
f83ce3e6b02d5 ("proc: avoid information leaks to non-privileged
processes")), the start_code and end_code values were not.  This would
allow the text location of a PIE binary to leak, defeating ASLR.

Note that the value "1" is used instead of "0" for a protected value since
"ps", "killall", and likely other readers of /proc/pid/stat, take
start_code of "0" to mean a kernel thread and will misbehave.  Thanks to
Brad Spengler for pointing this out.

Addresses CVE-2011-0726

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Cc: <stable@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/array.c~proc-protect-mm-start_code-end_code-in-proc-pid-stat fs/proc/array.c
--- a/fs/proc/array.c~proc-protect-mm-start_code-end_code-in-proc-pid-stat
+++ a/fs/proc/array.c
@@ -489,8 +489,8 @@ static int do_task_stat(struct seq_file 
 		vsize,
 		mm ? get_mm_rss(mm) : 0,
 		rsslim,
-		mm ? mm->start_code : 0,
-		mm ? mm->end_code : 0,
+		mm ? (permitted ? mm->start_code : 1) : 0,
+		mm ? (permitted ? mm->end_code : 1) : 0,
 		(permitted && mm) ? mm->start_stack : 0,
 		esp,
 		eip,
_

Patches currently in -mm which might be from kees.cook@canonical.com are

origin.patch
linux-next.patch
net-convert-%p-usage-to-%pk.patch
printk-use-%pk-for-proc-kallsyms-and-proc-modules.patch
proc-hide-kernel-addresses-via-%pk-in-proc-pid-stack.patch
proc-protect-mm-start_code-end_code-in-proc-pid-stat.patch

