From: akpm@linux-foundation.org
Subject: [merged]
 livepatching-handle-ancient-compilers-with-more-grace.patch removed from
 -mm tree
Date: Mon, 12 Jan 2015 11:33:34 -0800
Message-ID: <54b4218e.9VtlctwXzIaV+azu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbbALTde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: livepatching: handle ancient compilers with more grace
has been removed from the -mm tree.  Its filename was
     livepatching-handle-ancient-compilers-with-more-grace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: livepatching: handle ancient compilers with more grace

We are aborting a build in case when gcc doesn't support fentry on x86_64
(regs->ip modification can't really reliably work with mcount).

This however breaks allmodconfig for people with older gccs that don't
support -mfentry.

Turn the build-time failure into runtime failure, resulting in the whole
infrastructure not being initialized if CC_USING_FENTRY is unset.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/livepatch.h |    6 +++++-
 kernel/livepatch/core.c          |    6 ++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/livepatch.h~livepatching-handle-ancient-compilers-with-more-grace arch/x86/include/asm/livepatch.h
--- a/arch/x86/include/asm/livepatch.h~livepatching-handle-ancient-compilers-with-more-grace
+++ a/arch/x86/include/asm/livepatch.h
@@ -25,9 +25,13 @@
 #include <linux/ftrace.h>
 
 #ifdef CONFIG_LIVE_PATCHING
+static inline int klp_check_compiler_support(void)
+{
 #ifndef CC_USING_FENTRY
-#error Your compiler must support -mfentry for live patching to work
+	        return 1;
 #endif
+	        return 0;
+}
 extern int klp_write_module_reloc(struct module *mod, unsigned long type,
 				  unsigned long loc, unsigned long value);
 
diff -puN kernel/livepatch/core.c~livepatching-handle-ancient-compilers-with-more-grace kernel/livepatch/core.c
--- a/kernel/livepatch/core.c~livepatching-handle-ancient-compilers-with-more-grace
+++ a/kernel/livepatch/core.c
@@ -911,6 +911,12 @@ static int klp_init(void)
 {
 	int ret;
 
+	ret = klp_check_compiler_support();
+	if (ret) {
+		pr_info("Your compiler is too old; turning off.\n");
+		return -EINVAL;
+	}
+
 	ret = register_module_notifier(&klp_module_nb);
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from jkosina@suse.cz are

lib-vsprintfc-consume-p-in-format_decode.patch
lib-vsprintfc-improve-sanity-check-in-vsnprintf.patch
lib-vsprintfc-dont-try-to-fix-pointer-wrap-around.patch
lib-vsprintfc-replace-while-with-do-while-in-skip_atoi.patch
linux-next.patch

