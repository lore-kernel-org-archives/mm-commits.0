From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-optimize-bad-declarations-and-redundant-assignment.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:31:26 -0800
Message-ID: <5699733e.x73IzDASQYKWbzjK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbcAOWb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: norton.zhu@huawei.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: optimize bad declarations and redundant assignment
has been removed from the -mm tree.  Its filename was
     ocfs2-optimize-bad-declarations-and-redundant-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Norton.Zhu" <norton.zhu@huawei.com>
Subject: ocfs2: optimize bad declarations and redundant assignment

In ocfs2_parse_options,

a) it's better to declare variables(small size) outside of while loop;

b) 'option' will be set by match_int, 'option = 0;' makes no sense, if
   match_int failed, it just goto bail and return.

Signed-off-by: Norton.Zhu <norton.zhu@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-optimize-bad-declarations-and-redundant-assignment fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-optimize-bad-declarations-and-redundant-assignment
+++ a/fs/ocfs2/super.c
@@ -1280,6 +1280,8 @@ static int ocfs2_parse_options(struct su
 	int status, user_stack = 0;
 	char *p;
 	u32 tmp;
+	int token, option;
+	substring_t args[MAX_OPT_ARGS];
 
 	trace_ocfs2_parse_options(is_remount, options ? options : "(none)");
 
@@ -1298,9 +1300,6 @@ static int ocfs2_parse_options(struct su
 	}
 
 	while ((p = strsep(&options, ",")) != NULL) {
-		int token, option;
-		substring_t args[MAX_OPT_ARGS];
-
 		if (!*p)
 			continue;
 
@@ -1367,7 +1366,6 @@ static int ocfs2_parse_options(struct su
 				mopt->atime_quantum = option;
 			break;
 		case Opt_slot:
-			option = 0;
 			if (match_int(&args[0], &option)) {
 				status = 0;
 				goto bail;
@@ -1376,7 +1374,6 @@ static int ocfs2_parse_options(struct su
 				mopt->slot = (s16)option;
 			break;
 		case Opt_commit:
-			option = 0;
 			if (match_int(&args[0], &option)) {
 				status = 0;
 				goto bail;
@@ -1388,7 +1385,6 @@ static int ocfs2_parse_options(struct su
 			mopt->commit_interval = HZ * option;
 			break;
 		case Opt_localalloc:
-			option = 0;
 			if (match_int(&args[0], &option)) {
 				status = 0;
 				goto bail;
_

Patches currently in -mm which might be from norton.zhu@huawei.com are


