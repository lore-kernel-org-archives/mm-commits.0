From: akpm@linux-foundation.org
Subject: + lib-traceevent-clean-up-clang-build-warning.patch added to -mm
 tree
Date: Mon, 06 Nov 2017 15:55:30 -0800
Message-ID: <5a00f672.nyil8g+DslNxPDwW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932746AbdKFXzc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2017 18:55:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cj.chengjian@huawei.com, huawei.libin@huawei.com, kstewart@linuxfoundation.org, rostedt@goodmis.org, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/lib/traceevent/parse-filter.c: clean up clang build warning
has been added to the -mm tree.  Its filename is
     lib-traceevent-clean-up-clang-build-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-traceevent-clean-up-clang-build-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-traceevent-clean-up-clang-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from cj.chengjian@huawei.com are

lib-traceevent-clean-up-clang-build-warning.patch

