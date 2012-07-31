From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:57 -0700
Message-ID: <20120731184957.C28FA1E007E@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42024 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2GaSt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:59 -0400
Received: by obbwc20 with SMTP id wc20so4679387obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: drosenberg@vsecurity.com, dan.j.rosenberg@gmail.com, stable@vger.kernel.org, stevie.trujillo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-kptr_restrict-fix-pk-error-in-sysrq-show-all-timersq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from drosenberg@vsecurity.com are

origin.patch

