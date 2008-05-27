From: akpm@linux-foundation.org
Subject: + hrtimer-remove-unused-variables-in-ktime_divns.patch added to -mm tree
Date: Tue, 27 May 2008 15:59:39 -0700
Message-ID: <200805272259.m4RMxdCe017402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYE0W7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 18:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crmafra2@gmail.com, crmafra@gmail.com


The patch titled
     hrtimer: remove unused variables in ktime_divns()
has been added to the -mm tree.  Its filename is
     hrtimer-remove-unused-variables-in-ktime_divns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hrtimer: remove unused variables in ktime_divns()
From: "Carlos R. Mafra" <crmafra2@gmail.com>

The variables dns and inc are not used, remove them.

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-remove-unused-variables-in-ktime_divns kernel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-remove-unused-variables-in-ktime_divns
+++ a/kernel/hrtimer.c
@@ -300,11 +300,10 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
  */
 u64 ktime_divns(const ktime_t kt, s64 div)
 {
-	u64 dclc, inc, dns;
+	u64 dclc;
 	int sft = 0;
 
-	dclc = dns = ktime_to_ns(kt);
-	inc = div;
+	dclc = ktime_to_ns(kt);
 	/* Make sure the divisor is less than 2^32: */
 	while (div >> 32) {
 		sft++;
_

Patches currently in -mm which might be from crmafra2@gmail.com are

linux-next.patch
hrtimer-remove-unused-variables-in-ktime_divns.patch
remove-argument-from-open_softirq-which-is-always-null.patch

