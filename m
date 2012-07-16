From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq.patch added to -mm tree
Date: Mon, 16 Jul 2012 14:46:15 -0700
Message-ID: <20120716214616.14C475C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45091 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2GPVqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jul 2012 17:46:18 -0400
Received: by bkcjc3 with SMTP id jc3so329041bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Jul 2012 14:46:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, stable@vger.kernel.org, stevie.trujillo@gmail.com


The patch titled
     Subject: lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)

When using ALT+SysRq+Q all the pointers are replaced with "pK-error" like
this:

	[23153.208033]   .base:               pK-error

with echo h > /proc/sysrq-trigger it works:

	[23107.776363]   .base:       ffff88023e60d540

The intent behind this behavior was to return "pK-error" in cases where
the %pK format specifier was used in interrupt context, because the
CAP_SYSLOG check wouldn't be meaningful.  Clearly this should only apply
when kptr_restrict is actually enabled though.

Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq
+++ a/lib/vsprintf.c
@@ -1045,7 +1045,8 @@ char *pointer(const char *fmt, char *buf
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi()) {
+		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
+				      in_nmi())) {
 			if (spec.field_width == -1)
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);
_
Subject: Subject: lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)

Patches currently in -mm which might be from drosenberg@vsecurity.com are

lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq.patch

