From: akpm@linux-foundation.org
Subject: [patch 24/94] dynamic-debug-howto: fix optional/omitted
 ending line number to be LARGE instead of 0
Date: Fri, 17 Nov 2017 15:27:35 -0800
Message-ID: <20171117232735.5TYT51Z1-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55402 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
