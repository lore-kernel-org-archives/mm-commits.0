From: akpm@linux-foundation.org
Subject: [merged] sh-remove-needless-printk.patch removed from -mm
 tree
Date: Tue, 09 Jun 2020 17:37:56 -0700
Message-ID: <20200610003756.saXMFET68%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgFJAh4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 20:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, dima@arista.com, mm-commits@vger.kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: remove needless printk()
has been removed from the -mm tree.  Its filename was
     sh-remove-needless-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: sh: remove needless printk()

Currently `data' is always an empty line "".  No need for additional
printk() call.

Link: http://lkml.kernel.org/r/20200418201944.482088-31-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/dumpstack.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sh/kernel/dumpstack.c~sh-remove-needless-printk
+++ a/arch/sh/kernel/dumpstack.c
@@ -118,7 +118,6 @@ static int print_trace_stack(void *data,
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk("%s", (char *)data);
 	printk_address(addr, reliable);
 }
 
_

Patches currently in -mm which might be from dima@arista.com are
