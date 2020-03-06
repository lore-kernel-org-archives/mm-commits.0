From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 7/7] arch/Kconfig: update HAVE_RELIABLE_STACKTRACE
 description
Date: Thu, 05 Mar 2020 22:28:45 -0800
Message-ID: <20200306062845.YlxErhyCr%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgCFG2q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:46 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jpoimboe@redhat.com, linux-mm@kvack.org, mbenes@suse.cz, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Miroslav Benes <mbenes@suse.cz>
Subject: arch/Kconfig: update HAVE_RELIABLE_STACKTRACE description

save_stack_trace_tsk_reliable() is not the only function providing the
reliable stack traces anymore.  Architecture might define ARCH_STACKWALK
which provides a newer stack walking interface and has
arch_stack_walk_reliable() function.  Update the description accordingly.

Link: http://lkml.kernel.org/r/20200120154042.9934-1-mbenes@suse.cz
Signed-off-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/Kconfig~arch-kconfig-update-have_reliable_stacktrace-description
+++ a/arch/Kconfig
@@ -738,8 +738,9 @@ config HAVE_STACK_VALIDATION
 config HAVE_RELIABLE_STACKTRACE
 	bool
 	help
-	  Architecture has a save_stack_trace_tsk_reliable() function which
-	  only returns a stack trace if it can guarantee the trace is reliable.
+	  Architecture has either save_stack_trace_tsk_reliable() or
+	  arch_stack_walk_reliable() function which only returns a stack trace
+	  if it can guarantee the trace is reliable.
 
 config HAVE_ARCH_HASH
 	bool
_
