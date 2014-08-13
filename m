From: akpm@linux-foundation.org
Subject: + lib-turn-config_stacktrace-into-an-actual-option.patch added to -mm tree
Date: Wed, 13 Aug 2014 13:02:36 -0700
Message-ID: <53ebc45c.g2/CS/6e8hg7xzz+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:62413 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaHMUCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:02:37 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so67350obb.0
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:02:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: turn CONFIG_STACKTRACE into an actual option.
has been added to the -mm tree.  Its filename is
     lib-turn-config_stacktrace-into-an-actual-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-turn-config_stacktrace-into-an-actual-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-turn-config_stacktrace-into-an-actual-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: lib: turn CONFIG_STACKTRACE into an actual option.

I was puzzled why /proc/$$/stack had disappeared, until I figured out I
had disabled the last debug option that did a 'select STACKTRACE'.  This
patch makes the option show up at config time, so it can be enabled
without enabling any of the more heavyweight debug options.

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-turn-config_stacktrace-into-an-actual-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-turn-config_stacktrace-into-an-actual-option
+++ a/lib/Kconfig.debug
@@ -1008,8 +1008,13 @@ config TRACE_IRQFLAGS
 	  either tracing or lock debugging.
 
 config STACKTRACE
-	bool
+	bool "Stack backtrace support"
 	depends on STACKTRACE_SUPPORT
+	help
+	  This option causes the kernel to create a /proc/pid/stack for
+	  every process, showing its current stack trace.
+	  It is also used by various kernel debugging features that require
+	  stack trace generation.
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
lib-turn-config_stacktrace-into-an-actual-option.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

