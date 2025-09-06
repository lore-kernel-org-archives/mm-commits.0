Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E8715E97
	for <mm-commits@vger.kernel.org>; Sat,  6 Sep 2025 02:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757124924; cv=none; b=gT4JJmeygwOKroN6Uy7tP/dclvMpI2krQKfnbfPtVlK8RhsSI8uCuFfCYLkeNCvjNbViAVS+vmSWzNXayIff21r8oqMMtU/cYh/hyKmSFmgaOQpPru0jylLxLqCXwx5JQeQu8zfBeLLAIMIL9ZVgJuqepn/UnPp1031/OIZRGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757124924; c=relaxed/simple;
	bh=CwF5WT1BNjoMQ7bCEP5c+t449+9Cw5Ci4KiUwWH3MEs=;
	h=Date:To:From:Subject:Message-Id; b=V6U2ENwWaIsYQFMExo6wAZid5ecZsw+GREJMwtEJ5UA0k9WJLhk2cvd9zsKdI5BctASs4qzl9ZIliqZm/YCx6o8gdeVeWfIe2cHTiy6Yvmzkj5WQNa7B/tOM6GKZDdNW+qLnkqD3S4HqtTb9QcStf+kbDoQJZVBpIAT1+5mDyuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wExVGXhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wExVGXhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832CCC4CEF1;
	Sat,  6 Sep 2025 02:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757124923;
	bh=CwF5WT1BNjoMQ7bCEP5c+t449+9Cw5Ci4KiUwWH3MEs=;
	h=Date:To:From:Subject:From;
	b=wExVGXhn3bOprFjvp+0sokZ/QPF04Xfou3wBQhL4g/V3Fz1L+JJP2tXedAfUIZhod
	 kTkHBWdHcu4E+/7iQfRj8MfzZcw43PslilFFfG0wkgHjAWofbWRQm6+8MDsbxqn9UN
	 2S+EXTJWetyDPI1B+Pi+Vos9cL0YF4zxG7eBvEeM=
Date: Fri, 05 Sep 2025 19:15:22 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dakr@kernel.org,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-remove-lockdep_map_p-typedef.patch added to mm-new branch
Message-Id: <20250906021523.832CCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: remove lockdep_map_p typedef
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-remove-lockdep_map_p-typedef.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-remove-lockdep_map_p-typedef.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

rust-maple_tree-add-mapletree.patch
rust-maple_tree-add-lock-guard-for-maple-tree.patch
rust-maple_tree-add-mapletreealloc.patch
maple_tree-remove-lockdep_map_p-typedef.patch

