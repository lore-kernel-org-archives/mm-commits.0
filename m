From: akpm@linux-foundation.org
Subject: + panic-call-panic-handlers-before-kmsg_dump.patch added to -mm
 tree
Date: Fri, 19 Jul 2013 14:46:45 -0700
Message-ID: <51e9b3c5.tKR/T7reP03bhLdD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GSVqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 17:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, sboyd@codeaurora.org, rusty@rustcorp.com.au, peterz@infradead.org, markivx@codeaurora.org, ccross@android.com, anton@enomsg.org, keescook@chromium.org

Subject: + panic-call-panic-handlers-before-kmsg_dump.patch added to -mm tree
To: keescook@chromium.org,anton@enomsg.org,ccross@android.com,markivx@codeaurora.org,peterz@infradead.org,rusty@rustcorp.com.au,sboyd@codeaurora.org,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 14:46:45 -0700


The patch titled
     Subject: panic: call panic handlers before kmsg_dump
has been added to the -mm tree.  Its filename is
     panic-call-panic-handlers-before-kmsg_dump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-call-panic-handlers-before-kmsg_dump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-call-panic-handlers-before-kmsg_dump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: panic: call panic handlers before kmsg_dump

Since the panic handlers may produce additional information (via printk)
for the kernel log, it should be reported as part of the panic output
saved by kmsg_dump().  Without this re-ordering, nothing that adds
information to a panic will show up in pstore's view when kmsg_dump runs,
and is therefore not visible to crash reporting tools that examine pstore
output.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/panic.c~panic-call-panic-handlers-before-kmsg_dump kernel/panic.c
--- a/kernel/panic.c~panic-call-panic-handlers-before-kmsg_dump
+++ a/kernel/panic.c
@@ -123,10 +123,14 @@ void panic(const char *fmt, ...)
 	 */
 	smp_send_stop();
 
-	kmsg_dump(KMSG_DUMP_PANIC);
