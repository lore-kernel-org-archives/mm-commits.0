From: akpm@linux-foundation.org
Subject: [merged] cmdline-fix-style-issues.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:33 -0800
Message-ID: <52e2b88d.oBByXN4Wu6koU/lJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaAXTBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, felipe.contreras@gmail.com

Subject: [merged] cmdline-fix-style-issues.patch removed from -mm tree
To: felipe.contreras@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:33 -0800


The patch titled
     Subject: lib/cmdline.c: fix style issues
has been removed from the -mm tree.  Its filename was
     cmdline-fix-style-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: lib/cmdline.c: fix style issues

WARNING: space prohibited between function name and open parenthesis '('
+int get_option (char **str, int *pint)

WARNING: space prohibited between function name and open parenthesis '('
+	*pint = simple_strtol (cur, str, 0);

ERROR: trailing whitespace
+ $

WARNING: please, no spaces at the start of a line
+ $

WARNING: space prohibited between function name and open parenthesis '('
+		res = get_option ((char **)&str, ints + i);

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN lib/cmdline.c~cmdline-fix-style-issues lib/cmdline.c
--- a/lib/cmdline.c~cmdline-fix-style-issues
+++ a/lib/cmdline.c
@@ -49,13 +49,13 @@ static int get_range(char **str, int *pi
  *	3 - hyphen found to denote a range
  */
 
-int get_option (char **str, int *pint)
+int get_option(char **str, int *pint)
 {
 	char *cur = *str;
 
 	if (!cur || !(*cur))
 		return 0;
-	*pint = simple_strtol (cur, str, 0);
+	*pint = simple_strtol(cur, str, 0);
 	if (cur == *str)
 		return 0;
 	if (**str == ',') {
@@ -84,13 +84,13 @@ int get_option (char **str, int *pint)
  *	the parse to end (typically a null terminator, if @str is
  *	completely parseable).
  */
- 
+
 char *get_options(const char *str, int nints, int *ints)
 {
 	int res, i = 1;
 
 	while (i < nints) {
-		res = get_option ((char **)&str, ints + i);
+		res = get_option((char **)&str, ints + i);
 		if (res == 0)
 			break;
 		if (res == 3) {
@@ -153,7 +153,6 @@ unsigned long long memparse(const char *
 	return ret;
 }
 
