From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 47/93] kdb: don't play with console_loglevel
Date: Mon, 08 Jun 2020 21:32:19 -0700
Message-ID: <20200609043219.kF0LCzg-q%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEcV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:32:21 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.thompson@linaro.org, dianders@chromium.org, dima@arista.com, jason.wessel@windriver.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Dmitry Safonov <dima@arista.com>
Subject: kdb: don't play with console_loglevel

Print the stack trace with KERN_EMERG - it should be always visible.

Playing with console_loglevel is a bad idea as there may be more messages
printed than wanted.  Also the stack trace might be not printed at all if
printk() was deferred and console_loglevel was raised back before the
trace got flushed.

Unfortunately, after rebasing on commit 2277b492582d ("kdb: Fix stack
crawling on 'running' CPUs that aren't the master"), kdb_show_stack() uses
now kdb_dump_stack_on_cpu(), which for now won't be converted as it uses
dump_stack() instead of show_stack().

Convert for now the branch that uses show_stack() and remove
console_loglevel exercise from that case.

Link: http://lkml.kernel.org/r/20200418201944.482088-48-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/debug/kdb/kdb_bt.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/kernel/debug/kdb/kdb_bt.c~kdb-dont-play-with-console_loglevel
+++ a/kernel/debug/kdb/kdb_bt.c
@@ -21,17 +21,18 @@
 
 static void kdb_show_stack(struct task_struct *p, void *addr)
 {
-	int old_lvl = console_loglevel;
