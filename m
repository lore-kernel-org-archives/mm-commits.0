From: akpm@linux-foundation.org
Subject: + kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix.patch added to -mm tree
Date: Wed, 14 Jan 2009 10:29:55 -0800
Message-ID: <200901141829.n0EITt32024773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034AbZANSby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 13:31:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com


The patch titled
     kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix
has been added to the -mm tree.  Its filename is
     kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix.patch

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
Subject: kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix
From: Masami Hiramatsu <mhiramat@redhat.com>

Add dummy definitions of kprobe_opcode_t and arch_specific_insn
when CONFIG_KPROBES=n.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix
+++ a/include/linux/kprobes.h
@@ -50,6 +50,10 @@
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text"))) notrace
 #else /* CONFIG_KPROBES */
+typedef int kprobe_opcode_t;
+struct arch_specific_insn {
+	int dummy;
+};
 #define __kprobes	notrace
 #endif /* CONFIG_KPROBES */
 
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-fix-module-compilation-error-with-config_kprobes=n.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix-fix.patch
linux-next.patch
kprobes-cleanup-aggr_kprobe-related-code.patch
kprobes-move-export_symbol_gpl-just-after-function-definitions.patch
kprobes-cleanup-comment-style-in-kprobesh.patch
kprobes-rename-kprobe_enabled-to-kprobes_all_disarmed.patch
kprobes-support-per-kprobe-disabling.patch
kprobes-support-kretprobe-and-jprobe-per-probe-disabling.patch

