From: akpm@linux-foundation.org
Subject: - 9p-handle-kstrdup-and-match_strdup-failure.patch removed from -mm tree
Date: Fri, 07 Mar 2008 15:00:49 -0800
Message-ID: <200803072300.m27N0nQf021723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757613AbYCGXC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 18:02:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jim@meyering.net, ericvh@gmail.com, lucho@ionkov.net, meyering@redhat.com, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     9p: handle kstrdup and match_strdup failure
has been removed from the -mm tree.  Its filename was
     9p-handle-kstrdup-and-match_strdup-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 9p: handle kstrdup and match_strdup failure
From: Jim Meyering <jim@meyering.net>

fs/9p/v9fs.c (v9fs_parse_options): Handle kstrdup and match_strdup failure. 
Now that this function can fail, return an int, diagnose other option-parsing
failures, and adjust the sole caller: (v9fs_session_init): Handle kstrdup
failure.  Propagate any new v9fs_parse_options failure "up".

Signed-off-by: Jim Meyering <meyering@redhat.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs.c |   40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff -puN fs/9p/v9fs.c~9p-handle-kstrdup-and-match_strdup-failure fs/9p/v9fs.c
--- a/fs/9p/v9fs.c~9p-handle-kstrdup-and-match_strdup-failure
+++ a/fs/9p/v9fs.c
@@ -74,16 +74,17 @@ static match_table_t tokens = {
  * @options: options string passed from mount
  * @v9ses: existing v9fs session information
  *
+ * Return 0 upon success, -ERRNO upon failure.
  */
 
-static void v9fs_parse_options(struct v9fs_session_info *v9ses)
+static int v9fs_parse_options(struct v9fs_session_info *v9ses)
 {
 	char *options;
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
 	char *s, *e;
-	int ret;
+	int ret = 0;
 
 	/* setup defaults */
 	v9ses->afid = ~0;
@@ -91,19 +92,26 @@ static void v9fs_parse_options(struct v9
 	v9ses->cache = 0;
 
 	if (!v9ses->options)
-		return;
+		return 0;
 
 	options = kstrdup(v9ses->options, GFP_KERNEL);
+	if (!options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		return -ENOMEM;
+	}
+
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
 		if (token < Opt_uname) {
-			ret = match_int(&args[0], &option);
-			if (ret < 0) {
+			int r = match_int(&args[0], &option);
+			if (r < 0) {
 				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
+				ret = r;
 				continue;
 			}
 		}
@@ -139,6 +147,13 @@ static void v9fs_parse_options(struct v9
 
 		case Opt_access:
 			s = match_strdup(&args[0]);
+			if (!s) {
+				P9_DPRINTK(P9_DEBUG_ERROR,
+					   "failed to allocate copy"
+					   " of option argument\n");
+				ret = -ENOMEM;
+				break;
+			}
 			v9ses->flags &= ~V9FS_ACCESS_MASK;
 			if (strcmp(s, "user") == 0)
 				v9ses->flags |= V9FS_ACCESS_USER;
@@ -158,6 +173,7 @@ static void v9fs_parse_options(struct v9
 		}
 	}
 	kfree(options);
+	return ret;
 }
 
 /**
@@ -173,6 +189,7 @@ struct p9_fid *v9fs_session_init(struct 
 {
 	int retval = -EINVAL;
 	struct p9_fid *fid;
+	int rc;
 
 	v9ses->uname = __getname();
 	if (!v9ses->uname)
@@ -191,7 +208,18 @@ struct p9_fid *v9fs_session_init(struct 
 	v9ses->dfltuid = V9FS_DEFUID;
 	v9ses->dfltgid = V9FS_DEFGID;
 	v9ses->options = kstrdup(data, GFP_KERNEL);
-	v9fs_parse_options(v9ses);
+	if (!v9ses->options) {
+		P9_DPRINTK(P9_DEBUG_ERROR,
+			   "failed to allocate copy of option string\n");
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	rc = v9fs_parse_options(v9ses);
+	if (rc < 0) {
+		retval = rc;
+		goto error;
+	}
 
 	v9ses->clnt = p9_client_create(dev_name, v9ses->options);
 
_

Patches currently in -mm which might be from jim@meyering.net are

git-v9fs.patch
alpha-handle-kcalloc-failure.patch
affs-handle-match_strdup-failure.patch
hfs-handle-match_strdup-failure.patch
hfsplus-handle-match_strdup-failure.patch
lib-inflatec-handle-failed-malloc.patch

