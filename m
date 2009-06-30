From: akpm@linux-foundation.org
Subject: + kprobes-fix-kprobe-selftest-configuration-dependency.patch added to -mm tree
Date: Tue, 30 Jun 2009 14:38:38 -0700
Message-ID: <200906302138.n5ULccbf000638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbZF3Viq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 17:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com


The patch titled
     kprobes: fix kprobe selftest configuration dependency
has been added to the -mm tree.  Its filename is
     kprobes-fix-kprobe-selftest-configuration-dependency.patch

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
Subject: kprobes: fix kprobe selftest configuration dependency
From: Masami Hiramatsu <mhiramat@redhat.com>

Select CONFIG_KALLSYMS_ALL when CONFIG_KPROBES_SANITY_TEST=y.  Kprobe
selftest always fail without CONFIG_KALLSYMS_ALL=y, because kallsyms
doesn't list up the target functions which are probed in this test.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~kprobes-fix-kprobe-selftest-configuration-dependency lib/Kconfig.debug
--- a/lib/Kconfig.debug~kprobes-fix-kprobe-selftest-configuration-dependency
+++ a/lib/Kconfig.debug
@@ -748,6 +748,7 @@ config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	select KALLSYMS_ALL
 	default n
 	help
 	  This option provides for testing basic kprobes functionality on
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-fix-kprobe-selftest-configuration-dependency.patch

