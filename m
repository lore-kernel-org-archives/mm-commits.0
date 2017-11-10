From: akpm@linux-foundation.org
Subject: +
 dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch added to -mm tree
Date: Fri, 10 Nov 2017 14:25:05 -0800
Message-ID: <5a062741.umOdEHKKYARW4WMt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbdKJWZH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2017 17:25:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, jbaron@akamai.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic-debug-howto: fix optional/omitted ending line number to be LARGE instead of 0
has been added to the -mm tree.  Its filename is
     dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

dynamic_debug-fix-optional-omitted-ending-line-number-to-be-large-instead-of-0.patch
dynamic_debug-minor-fixes-to-documentation.patch
expert-kconfig-menu-fix-broken-expert-menu.patch

