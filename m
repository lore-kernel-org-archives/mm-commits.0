From: akpm@linux-foundation.org
Subject: + parse_integer-convert-fs-cachefiles.patch added to -mm tree
Date: Thu, 09 Jul 2015 12:26:21 -0700
Message-ID: <559ecadd.mSykZSe09w+Un+8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbbGIT0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dhowells@redhat.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: parse_integer: convert fs/cachefiles/
has been added to the -mm tree.  Its filename is
     parse_integer-convert-fs-cachefiles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parse_integer-convert-fs-cachefiles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parse_integer-convert-fs-cachefiles.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: parse_integer: convert fs/cachefiles/

Convert away from deprecated simple_strto*() interfaces.

Switch "unsigned long" to "unsigned int" where possible.
kstrto*() functions can't be used because of trailing "%" sign. :^)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/daemon.c |   84 ++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

diff -puN fs/cachefiles/daemon.c~parse_integer-convert-fs-cachefiles fs/cachefiles/daemon.c
--- a/fs/cachefiles/daemon.c~parse_integer-convert-fs-cachefiles
+++ a/fs/cachefiles/daemon.c
@@ -326,14 +326,15 @@ static int cachefiles_daemon_range_error
  */
 static int cachefiles_daemon_frun(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long frun;
+	unsigned int frun;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	frun = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &frun);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -350,14 +351,15 @@ static int cachefiles_daemon_frun(struct
  */
 static int cachefiles_daemon_fcull(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long fcull;
+	unsigned int fcull;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	fcull = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &fcull);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -374,14 +376,15 @@ static int cachefiles_daemon_fcull(struc
  */
 static int cachefiles_daemon_fstop(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long fstop;
+	unsigned int fstop;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	fstop = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &fstop);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -398,14 +401,15 @@ static int cachefiles_daemon_fstop(struc
  */
 static int cachefiles_daemon_brun(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long brun;
+	unsigned int brun;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	brun = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &brun);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -422,14 +426,15 @@ static int cachefiles_daemon_brun(struct
  */
 static int cachefiles_daemon_bcull(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long bcull;
+	unsigned int bcull;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	bcull = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &bcull);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -446,14 +451,15 @@ static int cachefiles_daemon_bcull(struc
  */
 static int cachefiles_daemon_bstop(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long bstop;
+	unsigned int bstop;
+	int rv;
 
 	_enter(",%s", args);
 
-	if (!*args)
-		return -EINVAL;
-
-	bstop = simple_strtoul(args, &args, 10);
+	rv = parse_integer(args, 10, &bstop);
+	if (rv < 0)
+		return rv;
+	args += rv;
 	if (args[0] != '%' || args[1] != '\0')
 		return -EINVAL;
 
@@ -601,21 +607,21 @@ inval:
  */
 static int cachefiles_daemon_debug(struct cachefiles_cache *cache, char *args)
 {
-	unsigned long mask;
+	unsigned int mask;
+	int rv;
 
 	_enter(",%s", args);
 
-	mask = simple_strtoul(args, &args, 0);
-	if (args[0] != '\0')
-		goto inval;
-
+	rv = parse_integer(args, 0, &mask);
+	if (rv < 0)
+		return rv;
+	if (args[rv] != '\0') {
+		pr_err("debug command requires mask\n");
+		return -EINVAL;
+	}
 	cachefiles_debug = mask;
 	_leave(" = 0");
 	return 0;
