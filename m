Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E818A92D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854835; cv=none; b=r+pAeh6UdL0cLNFUTNgyy492vDpV1IrbLjMxXj7NDszeecUjDoQQUjls+B/90Xi9ugvshPIv8maHoO6n4CftmTTVP73XhiczHcYF/iF5AQeIghpnIKOz/GZIz5L3HDBzA45hNhS/sIXiOIq+negDzwdqaQSg/Wur407O1RX2cEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854835; c=relaxed/simple;
	bh=7g0+93MV/ZxtKT1QMzchY1fgh8woF9OnjfBk93Nhis8=;
	h=Date:To:From:Subject:Message-Id; b=K5Ru40bepy1dRUCkob+vjB99AoLhacHXoIA2OxrARjaZDbKZFXiXgJaxd8B5/kzhr4fx04kSbYdCtOf+poUmUDiVmt04sOQbjVvbPT3fi7FkAnHwijGOH0QfhKAfaQ8Yjr/AFIXvVcNXnKvTBkMpywc5Ja47U2Px+zx5yzk9VnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eGb5DBkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eGb5DBkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B714DC4CECF;
	Wed,  6 Nov 2024 01:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854834;
	bh=7g0+93MV/ZxtKT1QMzchY1fgh8woF9OnjfBk93Nhis8=;
	h=Date:To:From:Subject:From;
	b=eGb5DBkPNUpp6Ujxlvw+p17tGeHN26md5n5j4PqQM2fSA87i5xMZaQpOnTA9vf8do
	 i7NJJqK7Cw72wAftz7COhtKMl9zUUixrogv/dFUDjOQsiyy5FsJeALML5toeR/vtHy
	 YGk6qlpwH/NPrucTGO3XFwTOVSlnTxSjsICaCEFo=
Date: Tue, 05 Nov 2024 17:00:34 -0800
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@Oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-outdated-flag-name-in-comment.patch removed from -mm tree
Message-Id: <20241106010034.B714DC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix outdated flag name in comment
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-outdated-flag-name-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: maple_tree: fix outdated flag name in comment
Date: Mon, 07 Oct 2024 23:47:45 +0200

MAPLE_USE_RCU was renamed to MT_FLAGS_USE_RCU at some point, fix up the
comment.

Link: https://lkml.kernel.org/r/20241007-maple-tree-doc-fix-v1-1-6bbf89c1153d@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-outdated-flag-name-in-comment
+++ a/include/linux/maple_tree.h
@@ -224,7 +224,7 @@ typedef struct { /* nothing */ } lockdep
  * (set at tree creation time) and dynamic information set under the spinlock.
  *
  * Another use of flags are to indicate global states of the tree.  This is the
- * case with the MAPLE_USE_RCU flag, which indicates the tree is currently in
+ * case with the MT_FLAGS_USE_RCU flag, which indicates the tree is currently in
  * RCU mode.  This mode was added to allow the tree to reuse nodes instead of
  * re-allocating and RCU freeing nodes when there is a single user.
  */
_

Patches currently in -mm which might be from jannh@google.com are


