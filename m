Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EF452E07B
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997567; cv=none; b=t/cjQGHCQwPhAAaj2AwK+RZcSfsH8Q96MkC1rNlxuT0IUNHOUayPi0TkretIxSafEYeTOi6QgZtLwqgien/JiOLkQq1VpLtKFqgN5bFm+6f8lflyWCtAijBiaBm40lxHuf6YsEsLBoBN0peWFAYyHtxwxnNtyEtBxGQz57qDBio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997567; c=relaxed/simple;
	bh=cfbPPQaGeBftXALrNlksr1YbyenAFqfYCzjzPv06G3k=;
	h=Date:To:From:Subject:Message-Id; b=rnrhXTF7GH+sqxeotyt/lxHQDi3/jxwb8rxbYTzUBfmo5fVWGQ79OVd21SOuegfiPawnOjsoIqZxIZDPQSWvPtEzHKtQGTFLtkfZeF4oD2lFXSExDy1KEpEUo6KmutfnjCfQOWmLmk0ygVFcF09nuYkZJ+yJbi1PtvnLyzXOuS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJkDcNAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJkDcNAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B83A1F000FF;
	Wed,  9 Sep 2026 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997566;
	bh=g9RIaZA2gDZfwTBoZjzz/rMt18ASvDP6V6WzoFDjG1w=;
	h=Date:To:From:Subject;
	b=DJkDcNAdRVohZa79oPR0IOcBlafl+XFUOXwaTWntKFUz1vJj8gmDMlv5hwi/nYIbT
	 5td9lmov5vyxwEeilB83sujNZHiliGpTcD7cC7fxgk6A1JFwwLsZ9yCM1mUYi1XMU6
	 kTKZXNPqh428Yzrb/cvYaZv8AFdHfV/h8p4S4P6M=
Date: Wed, 09 Sep 2026 16:46:05 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch added to mm-nonmm-unstable branch
Message-Id: <20260909234606.0B83A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: skip internal tree sanity checks in kernel
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: bootconfig: skip internal tree sanity checks in kernel
Date: Thu, 10 Sep 2026 00:54:02 +0900

In xbc_verify_tree(), the loop iterating through all nodes to check that
xbc_nodes[i].next < xbc_node_num and xbc_nodes[i].child < xbc_node_num is
a defensive sanity check against implementation regressions (such an
out-of-bounds index cannot be produced by malformed input).

Running this check in the kernel adds unnecessary boot-time overhead. 
Split this check out into xbc_sanity_check_tree() for userspace, so that
it continues to run during userspace bootconfig validation (e.g.  when
applying or testing bootconfig with tools/bootconfig), but is omitted in
the kernel to speed up initialization.

Link: https://lore.kernel.org/178896924262.177508.71609739247457811.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Closes: https://lore.kernel.org/all/20260905141637.1547429-1-ekffu200098@gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/lib/bootconfig.c~bootconfig-skip-internal-tree-sanity-checks-in-kernel
+++ a/lib/bootconfig.c
@@ -1003,9 +1003,30 @@ static int __init xbc_close_brace(char *
 	return __xbc_close_brace(n - 1);
 }
 
+#ifndef __KERNEL__
+/* Sanity check for regression: node indices must be within bounds */
+static int __init xbc_sanity_check_tree(void)
+{
+	int i;
+
+	for (i = 0; i < xbc_node_num; i++) {
+		if (xbc_nodes[i].next >= xbc_node_num) {
+			return xbc_parse_error("No closing brace",
+				xbc_node_get_data(xbc_nodes + i));
+		}
+		if (xbc_nodes[i].child >= xbc_node_num) {
+			return xbc_parse_error("Broken child node",
+				xbc_node_get_data(xbc_nodes + i));
+		}
+	}
+
+	return 0;
+}
+#endif
+
 static int __init xbc_verify_tree(void)
 {
-	int i, depth;
+	int depth;
 	size_t len, wlen;
 	struct xbc_node *n, *m;
 
@@ -1022,17 +1043,6 @@ static int __init xbc_verify_tree(void)
 		return -ENOENT;
 	}
 
-	for (i = 0; i < xbc_node_num; i++) {
-		if (xbc_nodes[i].next >= xbc_node_num) {
-			return xbc_parse_error("No closing brace",
-				xbc_node_get_data(xbc_nodes + i));
-		}
-		if (xbc_nodes[i].child >= xbc_node_num) {
-			return xbc_parse_error("Broken child node",
-				xbc_node_get_data(xbc_nodes + i));
-		}
-	}
-
 	/* Key tree limitation check */
 	n = &xbc_nodes[0];
 	depth = 1;
@@ -1203,6 +1213,10 @@ int __init xbc_init(const char *data, si
 	ret = xbc_parse_tree();
 	if (!ret)
 		ret = xbc_verify_tree();
+#ifndef __KERNEL__
+	if (!ret)
+		ret = xbc_sanity_check_tree();
+#endif
 
 	if (ret < 0) {
 		if (epos)
_

Patches currently in -mm which might be from mhiramat@kernel.org are

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

