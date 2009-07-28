From: akpm@linux-foundation.org
Subject: + ppsh-needs-linux-typesh.patch added to -mm tree
Date: Tue, 28 Jul 2009 14:26:27 -0700
Message-ID: <200907282126.n6SLQRtq018730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbZG1V0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 17:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, giometti@linux.it


The patch titled
     pps.h needs <linux/types.h>
has been added to the -mm tree.  Its filename is
     ppsh-needs-linux-typesh.patch

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
Subject: pps.h needs <linux/types.h>
From: Dave Jones <davej@redhat.com>

Found with make headers_check

/usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pps.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pps.h~ppsh-needs-linux-typesh include/linux/pps.h
--- a/include/linux/pps.h~ppsh-needs-linux-typesh
+++ a/include/linux/pps.h
@@ -22,6 +22,8 @@
 #ifndef _PPS_H_
 #define _PPS_H_
 
+#include <linux/types.h>
+
 #define PPS_VERSION		"5.3.6"
 #define PPS_MAX_SOURCES		16		/* should be enough... */
 
_

Patches currently in -mm which might be from davej@redhat.com are

ppsh-needs-linux-typesh.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
kernel-core-add-smp_call_function_any-update.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
qla2xxx-fix-__little_endian-definition-warnings.patch

