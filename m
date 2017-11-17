From: akpm@linux-foundation.org
Subject: [patch 37/94] tools/lib/traceevent/parse-filter.c: clean
 up clang build warning
Date: Fri, 17 Nov 2017 15:28:23 -0800
Message-ID: <20171117232823.kXVyUTaLB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964924AbdKQX2Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cj.chengjian@huawei.com, huawei.libin@huawei.com, kstewart@linuxfoundation.org, mm-commits@vger.kernel.org, rostedt@goodmis.org, torvalds@linux-foundation.org, xiexiuqi@huawei.com

From: Cheng Jian <cj.chengjian@huawei.com>
Subject: tools/lib/traceevent/parse-filter.c: clean up clang build warning

The uniform structure filter_arg sets its union based on the difference of
enum filter_arg_type, However, some functions use implicit type conversion
obviously.

warning: implicit conversion from enumeration type 'enum filter_exp_type'
	 to different enumeration type 'enum filter_op_type'

warning: implicit conversion from enumeration type 'enum filter_cmp_type'
	 to different enumeration type 'enum filter_exp_type'

Link: http://lkml.kernel.org/r/1509938415-113825-1-git-send-email-cj.chengjian@huawei.com
Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/traceevent/parse-filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN tools/lib/traceevent/parse-filter.c~lib-traceevent-clean-up-clang-build-warning tools/lib/traceevent/parse-filter.c
--- a/tools/lib/traceevent/parse-filter.c~lib-traceevent-clean-up-clang-build-warning
+++ a/tools/lib/traceevent/parse-filter.c
@@ -436,13 +436,13 @@ create_arg_exp(enum filter_exp_type etyp
 		return NULL;
 
 	arg->type = FILTER_ARG_EXP;
-	arg->op.type = etype;
+	arg->exp.type = etype;
 
 	return arg;
 }
 
 static struct filter_arg *
-create_arg_cmp(enum filter_exp_type etype)
+create_arg_cmp(enum filter_cmp_type ctype)
 {
 	struct filter_arg *arg;
 
@@ -452,7 +452,7 @@ create_arg_cmp(enum filter_exp_type etyp
 
 	/* Use NUM and change if necessary */
 	arg->type = FILTER_ARG_NUM;
-	arg->op.type = etype;
+	arg->num.type = ctype;
 
 	return arg;
 }
_
