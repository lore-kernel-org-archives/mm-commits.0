Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F047A38FB9
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762907248; cv=none; b=pRTHr0GgNeNrby584aj8oDQbJmcuGTjQ5qQ3ScmNu7ikmy9ZrT97nnYBOQ1xbHU0MEL6+77+KSf6T/3p26X/Db2SG1MlCZPQV19agQ4ZYt7YJYso87SaJKR1990nsc8ylDxjlJMjFoX2up6gG6CvxQiHaKKl7c2TBAp2h+1Ft1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762907248; c=relaxed/simple;
	bh=iNRRGa6ntyPBtjWleUo0HbmSRiAMQdMykFbRYmBBgMI=;
	h=Date:To:From:Subject:Message-Id; b=qMYl47F0uCrbYYdTXXQjWotbExMlohPEzyB/pbXhbBbEWZqXdDwv+vaat6/i04L3kbmiWEYokRtdXiAO6VdSuGxLILzq1a+qqXBBZw5daDU0XA6qz3vk+SGmYQyvE0PJRrh/0qUQFSS0L/vF2xHFZXAmn/hDjbQu8JTMoNJlY2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L++qL14K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L++qL14K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815D2C4CEF5;
	Wed, 12 Nov 2025 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762907247;
	bh=iNRRGa6ntyPBtjWleUo0HbmSRiAMQdMykFbRYmBBgMI=;
	h=Date:To:From:Subject:From;
	b=L++qL14KPHT25pacWwVcdnKHMQTN0jjKRayu4gricayPFV9JQCPI0ruYF4vMVSDbF
	 +/wQAu2A95fEkQAmi1rZiuWTnzNBma3n7WXodOE9Tp3lJx0FViZwGMJ7/Wgz4zWFnP
	 pKBl6b0rXnpWYDnTdpqnpcdnQ6T/eYvwemhkzwd4=
Date: Tue, 11 Nov 2025 16:27:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch removed from -mm tree
Message-Id: <20251112002727.815D2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
has been removed from the -mm tree.  Its filename was
     drivers-base-node-fold-unregister_node-into-unregister_one_node-fix.patch

This patch was dropped because it was folded into drivers-base-node-fold-unregister_node-into-unregister_one_node.patch

------------------------------------------------------
From: Donet Tom<donettom@linux.ibm.com>
Subject: drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
Date: Fri, 17 Oct 2025 10:27:54 +0530

removes extra spaces before @nid and "All".

Link: https://lkml.kernel.org/r/cff01514-9074-4c97-bcf1-d4e3594e48b0@linux.ibm.com
Signed-off-by: Donet Tom<donettom@linux.ibm.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/node.c~drivers-base-node-fold-unregister_node-into-unregister_one_node-fix
+++ a/drivers/base/node.c
@@ -911,7 +911,7 @@ int register_node(int nid)
  * unregister_node - unregister a node device
  * @nid: nid of the node going away
  *
- * Unregisters the node device at node id  @nid.  All the devices on the
+ * Unregisters the node device at node id @nid. All the devices on the
  * node must be unregistered before calling this function.
  */
 void unregister_node(int nid)
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

drivers-base-node-fold-register_node-into-register_one_node.patch
drivers-base-node-fold-unregister_node-into-unregister_one_node.patch

