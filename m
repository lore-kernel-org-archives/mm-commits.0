From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 111/118] init/main.c: log arguments and
 environment passed to init
Date: Thu, 30 Jan 2020 22:17:13 -0800
Message-ID: <20200131061713.CqwifCDBT%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:15 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, krzysiek@podlesie.net, linux-mm@kvack.org, mm-commits@vger.kernel.org, nivedita@alum.mit.edu, torvalds@linux-foundation.org

From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: init/main.c: log arguments and environment passed to init

Extend logging in `run_init_process` to also show the arguments and
environment that we are passing to init.

Link: http://lkml.kernel.org/r/20191212180023.24339-2-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/init/main.c~init-mainc-log-arguments-and-environment-passed-to-init
+++ a/init/main.c
@@ -1043,8 +1043,16 @@ static void __init do_pre_smp_initcalls(
 
 static int run_init_process(const char *init_filename)
 {
+	const char *const *p;
+
 	argv_init[0] = init_filename;
 	pr_info("Run %s as init process\n", init_filename);
+	pr_debug("  with arguments:\n");
+	for (p = argv_init; *p; p++)
+		pr_debug("    %s\n", *p);
+	pr_debug("  with environment:\n");
+	for (p = envp_init; *p; p++)
+		pr_debug("    %s\n", *p);
 	return do_execve(getname_kernel(init_filename),
 		(const char __user *const __user *)argv_init,
 		(const char __user *const __user *)envp_init);
_
