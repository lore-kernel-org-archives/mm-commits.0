Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B43BED7A
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789166227; cv=none; b=SbXcwO+kaozxJs2f11qXgmdyZ0wSVdJuKRs848PgXxWA+e8ZcXpsHKZ7QiJ0VQti+2uEhrgPv9giYl34d3IS5i3lgYxyAQuQ9h2dmkxdCHBnaElU6HyNYH/6cC+W+cJ4owdUPd0e9U6YEUUD1f5zKJSPuPk/soGDSjhvoU9jtNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789166227; c=relaxed/simple;
	bh=cxNkycHzqSn4yJhx60yQwtu/qeIsHfhgA+rHSUCaJyQ=;
	h=Date:To:From:Subject:Message-Id; b=npgHJoiv1t0P6E5SO3nqgZP7d+/QaZmTlejrzdChuySDWGc6jDr8LWAYGcAw/LYHj/XI2aqt6p7Pqw/AF6wWU+93LYlGZrwTFUPmAwLiuwkBW4xyOflpGxS7yq3ToBcOYQUzCR/nF5yQQoX5qb5AyvxDAfviOa6LaoGAJDU5XDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ti7sPN9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ti7sPN9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9980C1F000FF;
	Fri, 11 Sep 2026 22:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789166225;
	bh=onuRUMj6rR6A26Vq932+kxG2KeFfEqM7yl+IOkej1L8=;
	h=Date:To:From:Subject;
	b=Ti7sPN9U1PlsNKB0GEtozOPtWWgtSvJh3Obdc4BeL+vWomkQN5a45rYvAHQBSKWdg
	 maN29b6555Z39C1jHNDIwZ+laerR7vw9IGmbYANE6SzfBqwePBfPteuWFwK0S2pw8A
	 +ac0vPzGD5DgSZTEEyhL+/0e7gkUScv0++BRS7Gk=
Date: Fri, 11 Sep 2026 15:37:05 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch removed from -mm tree
Message-Id: <20260911223705.9980C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: skip internal tree sanity checks in kernel
has been removed from the -mm tree.  Its filename was
     bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
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

tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

