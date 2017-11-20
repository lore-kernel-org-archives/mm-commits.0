From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?dynamic=5Fdebug-fix-optional-omitted-ending-line-number-to?=
 =?US-ASCII?Q?-be-large-instead-of-0.patch?= removed from -mm tree
Date: Mon, 20 Nov 2017 13:23:44 -0800
Message-ID: <20171120212344.y3DcYsw_-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752882AbdKTVXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: dynamic-debug-howto: fix optional/omitted ending line number to be LARGE instead of 0
has been removed from the -mm tree.  Its filename was
     dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: dynamic-debug-howto: fix optional/omitted ending line number to be LARGE instead of 0

line-range is supposed to treat "1-" as "1-endoffile", so
handle the special case by setting last_lineno to UINT_MAX.

Fixes this error:

dynamic_debug:ddebug_parse_query: last-line:0 < 1st-line:1
dynamic_debug:ddebug_exec_query: query parse failed

Link: http://lkml.kernel.org/r/10a6a101-e2be-209f-1f41-54637824788e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dynamic_debug.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/dynamic_debug.c~dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0 lib/dynamic_debug.c
--- a/lib/dynamic_debug.c~dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0
+++ a/lib/dynamic_debug.c
@@ -360,6 +360,10 @@ static int ddebug_parse_query(char *word
 				if (parse_lineno(last, &query->last_lineno) < 0)
 					return -EINVAL;
 
+				/* special case for last lineno not specified */
+				if (query->last_lineno == 0)
+					query->last_lineno = UINT_MAX;
+
 				if (query->last_lineno < query->first_lineno) {
 					pr_err("last-line:%d < 1st-line:%d\n",
 						query->last_lineno,
_

Patches currently in -mm which might be from rdunlap@infradead.org are


