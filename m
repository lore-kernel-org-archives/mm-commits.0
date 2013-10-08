From: akpm@linux-foundation.org
Subject: +
 kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch added to
 -mm tree
Date: Mon, 07 Oct 2013 17:27:53 -0700
Message-ID: <52535189.dbA8uiFj39PuJpJk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3JHA1y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 20:27:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 17:27:53 -0700


The patch titled
     Subject: kernel/panic.c: reduce 1 byte usage for print tainted buffer
has been added to the -mm tree.  Its filename is
     kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/panic.c: reduce 1 byte usage for print tainted buffer

sizeof("Tainted: ") already counts '\0', and after first sprintf(), 's'
will start from the current string end (its' value is '\0').

So need not add additional 1 byte for maximized usage of 'buf' in
print_tainted().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer
+++ a/kernel/panic.c
@@ -233,7 +233,7 @@ static const struct tnt tnts[] = {
  */
 const char *print_tainted(void)
 {
-	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ") + 1];
+	static char buf[ARRAY_SIZE(tnts) + sizeof("Tainted: ")];
 
 	if (tainted_mask) {
 		char *s;
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
mm-readaheadc-return-the-value-which-force_page_cache_readahead-returns.patch
mm-mempolicy-make-mpol_to_str-robust-and-always-succeed.patch
kernel-delayacctc-remove-redundant-checking-in-__delayacct_add_tsk.patch
kernel-sysctlc-check-return-value-after-call-proc_put_char-in-__do_proc_doulongvec_minmax.patch
kernel-taskstatsc-add-nla_nest_cancel-for-failure-processing-between-nla_nest_start-and-nla_nest_end.patch
kernel-panicc-reduce-1-byte-usage-for-print-tainted-buffer.patch
linux-next.patch

