Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB921578B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188280; cv=none; b=NMBmvf9NVptxsCTBvIY8RwN8yV3bzDCgB4rcvpw3mJ4cidjKbdBLdgVUDY5DeOWOAZApjhcCe439xdTLbrbgDuM7KdHXDJ9+CAf3H9VHwU0bNTqlluBDexXOvchlzkECnQiTiD6HMdxl9lg4EVVDARBEN4Ti4/7BXRFUSb/3u3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188280; c=relaxed/simple;
	bh=/QLS2LM42yEV0K4HMrI/QI4HFM/nD5hz798o1wA+GNc=;
	h=Date:To:From:Subject:Message-Id; b=kO81CgdN1by6mPq6zvwDxEWInnWrngUSs/DvpdwpnEs2ATvyJ71lasGVcj4DzA2WN2nFxOppJCelRoqCWKtbOYQ1Yq+ceNq5e/U1F6aDuD2apJ8gg/h5rJyHjRqLso5Quy23DOXYM71xfZMDanXgZ7lV/CA6f2oktBKAVlyG0wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fgjpGT/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fgjpGT/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B14C4CEEC;
	Mon, 17 Mar 2025 05:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188280;
	bh=/QLS2LM42yEV0K4HMrI/QI4HFM/nD5hz798o1wA+GNc=;
	h=Date:To:From:Subject:From;
	b=fgjpGT/jxta2JdAv63E7dGRl7NqurlvDlE7tVzlPEnXDGGJFD9UCNn2Z3hYVmpBih
	 vZvemr0aKHRGLzD17vjAyKgma0t4WWh1obTTNm9JAAbVOShUYejPq/jq9ZCT5UZUsY
	 YRglsP5L77FjVtxTZncgc4KlVSmpwDns6y9NhofQ=
Date: Sun, 16 Mar 2025 22:11:20 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,Liam.Howlett@Oracle.com,jserv@ccns.ncku.edu.tw,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-use-ma_dead_node-in-mte_dead_node.patch removed from -mm tree
Message-Id: <20250317051120.72B14C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: use ma_dead_node() in mte_dead_node()
has been removed from the -mm tree.  Its filename was
     maple_tree-use-ma_dead_node-in-mte_dead_node.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: I Hsin Cheng <richard120310@gmail.com>
Subject: maple_tree: use ma_dead_node() in mte_dead_node()
Date: Tue, 11 Feb 2025 15:18:50 +0800

Utilize ma_dead_node() in mte_dead_node().  It can prevent decoding the
maple enode for a second time.  Use the "node" to find parent for
comparison.

Link: https://lkml.kernel.org/r/20250211071850.330632-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Shuah khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple_tree-use-ma_dead_node-in-mte_dead_node
+++ a/lib/maple_tree.c
@@ -584,13 +584,10 @@ static __always_inline bool ma_dead_node
  */
 static __always_inline bool mte_dead_node(const struct maple_enode *enode)
 {
-	struct maple_node *parent, *node;
+	struct maple_node *node;
 
 	node = mte_to_node(enode);
-	/* Do not reorder reads from the node prior to the parent check */
-	smp_rmb();
-	parent = mte_parent(enode);
-	return (parent == node);
+	return ma_dead_node(node);
 }
 
 /*
_

Patches currently in -mm which might be from richard120310@gmail.com are

lib-plistc-add-shortcut-for-plist_requeue.patch

