Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD90721D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489957; cv=none; b=sMWo5zcbpqupAMGXMSZ+obIZYra4MS+hwpbV/jOZQzOx/+pDMmF9ogTCcCmKFevx8HE/95mqZRlQjXLQkB+z3/b1/yVz65Ii2wE3AVLGyH9mZj+PsXwROle1IOuqTLL8nr5UWduzmvlZbRIMe4+uuDjWpK+Ymvvab9M6xleAv9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489957; c=relaxed/simple;
	bh=rTM/tzbA2oc9BC1wSKeVJHPDGMoZfANmGHR6c1qXB7o=;
	h=Date:To:From:Subject:Message-Id; b=IjyyC7taAFjF62cUZOatfpc1DYDRoCoYCP3Qwra0bg42btQbakLhJANb6AMuspalAKgFZQ64wpBTgoNXYPRRW2Yna3DpwrrmwygH7B3DSLmatphHFn+WTRxIH5Sf84nPjI+zNs47ST+LHVVsmSMP+t5yCPzJ1m1f1KY+R5jIO+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RMkMVeho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RMkMVeho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984A8C4CEE7;
	Sun, 21 Sep 2025 21:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489957;
	bh=rTM/tzbA2oc9BC1wSKeVJHPDGMoZfANmGHR6c1qXB7o=;
	h=Date:To:From:Subject:From;
	b=RMkMVehoYlHfbpLHLcMCT1vHAOXQ8pIhe8ka2WZXfhWpafDpbEcZvF71vCtQvjpSU
	 k55E7/+d7ls+UOXkPi92KIH9DRFLXDdTLNigew1EFmZBtF0PXYehXI6+k4EkIftrEY
	 NuqBxuMNduTR6WrrOpfdwBK60Inl1paFF7VsPAbA=
Date: Sun, 21 Sep 2025 14:25:57 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dakr@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-lockdep_map_p-typedef.patch removed from -mm tree
Message-Id: <20250921212557.984A8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove lockdep_map_p typedef
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-lockdep_map_p-typedef.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alice Ryhl <aliceryhl@google.com>
Subject: maple_tree: remove lockdep_map_p typedef
Date: Tue, 02 Sep 2025 08:36:11 +0000

Having the ma_external_lock field exist when CONFIG_LOCKDEP=n isn't used
anywhere, so just get rid of it.  This also avoids generating a typedef
called lockdep_map_p that could overlap with typedefs in other header
files.

Link: https://lkml.kernel.org/r/20250902-maple-lockdep-p-v1-1-3ae5a398a379@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/maple_tree.h~maple_tree-remove-lockdep_map_p-typedef
+++ a/include/linux/maple_tree.h
@@ -194,7 +194,6 @@ enum store_type {
 #define MAPLE_RESERVED_RANGE	4096
 
 #ifdef CONFIG_LOCKDEP
-typedef struct lockdep_map *lockdep_map_p;
 #define mt_lock_is_held(mt)                                             \
 	(!(mt)->ma_external_lock || lock_is_held((mt)->ma_external_lock))
 
@@ -207,7 +206,6 @@ typedef struct lockdep_map *lockdep_map_
 
 #define mt_on_stack(mt)			(mt).ma_external_lock = NULL
 #else
-typedef struct { /* nothing */ } lockdep_map_p;
 #define mt_lock_is_held(mt)		1
 #define mt_write_lock_is_held(mt)	1
 #define mt_set_external_lock(mt, lock)	do { } while (0)
@@ -230,8 +228,10 @@ typedef struct { /* nothing */ } lockdep
  */
 struct maple_tree {
 	union {
-		spinlock_t	ma_lock;
-		lockdep_map_p	ma_external_lock;
+		spinlock_t		ma_lock;
+#ifdef CONFIG_LOCKDEP
+		struct lockdep_map	*ma_external_lock;
+#endif
 	};
 	unsigned int	ma_flags;
 	void __rcu      *ma_root;
_

Patches currently in -mm which might be from aliceryhl@google.com are


