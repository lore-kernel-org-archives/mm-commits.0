From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 30/93] sh: remove needless printk()
Date: Mon, 08 Jun 2020 21:31:27 -0700
Message-ID: <20200609043127.Lf6aX9jfp%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgFIEb3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 00:31:29 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dalias@libc.org, dima@arista.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, ysato@users.sourceforge.jp

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
