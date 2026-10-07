Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75752357D19
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338705; cv=none; b=adFaz0MICuFWB2NMte2x1MtHoFbIrJapFHRAU3FusQ5HC9sgf7qQsFPhA76i/mm01llZJBTG6D/1X0Tec5t1FTmQSneiwfdXUAU6UwHrqQLt5eDWYMoGNmxzLGjeHOfbu0N/cauzLetNGQyhZdSEsui8jdXgu313JTJbnIe6Ac8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338705; c=relaxed/simple;
	bh=VEI3uoqwX95XWsySbbXeJAQIsWaCtE6yaDz83weC4Oo=;
	h=Date:To:From:Subject:Message-Id; b=Bh9/9//FNuWiwneCA6gBBh+GFQ4Q7koHsoE87u4MZOAP04PEy6HNPkdRLNLVdCQJ99Rke1j3sCIy7m3eKkGZn2+v5QhCkc+dhZJpiK9ujssLRU835kA0Ddbza/HjK6F3u2oOPKLiLKXqFgI1DZcGKODftNDv6j7UMoSz9to+/C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xwanei+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xwanei+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039701F0089C;
	Wed,  7 Oct 2026 02:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338704;
	bh=GyewIJzch+zthHpr7No20khAzAsiwn4fWGTqsFwyvKk=;
	h=Date:To:From:Subject;
	b=xwanei+sQFXFMkptCe/V/acPVkRgkjlVGlRBK07wVqV3BgyqZLdx0v/U4gc4DVcNS
	 Kv8Omsori8yRZvjSbjxPPakJXM/tsbrUYhX98uewxAsEUaZQ2mJrGDk1ZewmhzEAt5
	 zkL38G+XOBj5fF1na9zq372JpM6OqmWRznH8xpfk=
Date: Tue, 06 Oct 2026 19:05:03 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch removed from -mm tree
Message-Id: <20261007020504.039701F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: skip internal tree sanity checks in kernel
has been removed from the -mm tree.  Its filename was
     bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: bootconfig: skip internal tree sanity checks in kernel
Date: Fri, 11 Sep 2026 23:13:24 +0900

In xbc_verify_tree(), the loop iterating through all nodes to check that
xbc_nodes[i].next < xbc_node_num and xbc_nodes[i].child < xbc_node_num is
a defensive sanity check against implementation regressions (such an
out-of-bounds index cannot be produced by malformed input).

Running this check in the kernel adds unnecessary boot-time overhead. 
Split this check out into xbc_sanity_check_tree() for userspace, so that
it continues to run during userspace bootconfig validation (e.g.  when
applying or testing bootconfig with tools/bootconfig), but is omitted in
the kernel to speed up initialization.

Link: https://lore.kernel.org/178913600409.248794.12941798680046327623.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Closes: https://lore.kernel.org/all/20260905141637.1547429-1-ekffu200098@gmail.com/
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---

 lib/bootconfig.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/lib/bootconfig.c~bootconfig-skip-internal-tree-sanity-checks-in-kernel
+++ a/lib/bootconfig.c
@@ -1002,9 +1002,30 @@ static int __init xbc_close_brace(char *
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
 
@@ -1021,17 +1042,6 @@ static int __init xbc_verify_tree(void)
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
@@ -1202,6 +1212,10 @@ int __init xbc_init(const char *data, si
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


