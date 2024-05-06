Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233752CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958100; cv=none; b=ZzLG7WqZcmtJqE+D/NVVqS93PrbTCucf/gxT+b20omOZZ/UxH8KpMh6pwkjPrGhd5dXMWMLi23ic2E2o47bwg4PnDanrutzNZtJedMD8/JxTzzIYTYV9dOQJL5H9DGJvSyNWflhp0x+KtFxV0CSsoiwapZGXQD6gErqnAfUksgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958100; c=relaxed/simple;
	bh=fnZT0gB1EATlBatm/hofQrs0S+ca+KxyvyAEPQNtBB8=;
	h=Date:To:From:Subject:Message-Id; b=K2f2v9xgsBJdFJq7jZBGFdjqEDQ+I0YSO7F0F9Gz24p1akHvsjtkSoa4n5fHa5SmQqyLu67mZcEH+rpYPiZiZnFWeyqMJYBZP7ebCcALwZilDNw1hsWzp4nyZsm3Z2nCYQm0QExGQdYSH2pmvjibTxvGLI7AbX9xyTSa+Ry+RGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BYwur/U3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BYwur/U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19DAC4AF18;
	Mon,  6 May 2024 01:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958100;
	bh=fnZT0gB1EATlBatm/hofQrs0S+ca+KxyvyAEPQNtBB8=;
	h=Date:To:From:Subject:From;
	b=BYwur/U3B/UQRwzDXUhvPD0Y2s7JysKL+wayLANqIKhtzbtvgQoxlflexTBq5kdX7
	 VDXqSRm7SfWHKb7Mq1B0fEsBsFRTY3yGID5JH/iTOVqZL9Krty1VPu5J4BD/Gtt+LM
	 njYSb0DqECG+sdbg6aGjOS70q09ljsJKYIqf4M18=
Date: Sun, 05 May 2024 18:14:59 -0700
To: mm-commits@vger.kernel.org,namhyung@kernel.org,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,goldstein.w.n@gmail.com,adrian.hunter@intel.com,acme@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch removed from -mm tree
Message-Id: <20240506011459.E19DAC4AF18@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools lib rbtree: pick some improvements from the kernel rbtree code
has been removed from the -mm tree.  Its filename was
     tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: tools lib rbtree: pick some improvements from the kernel rbtree code
Date: Tue, 23 Apr 2024 17:27:57 -0300

The tools/lib/rbtree.c code came from the kernel.  Remove the
EXPORT_SYMBOL() that make sense only there.  Unfortunately it is not being
checked with tools/perf/check_headers.sh.  Will try to remedy this.  Until
then pick the improvements from:

  b0687c1119b4e8c8 ("lib/rbtree: use '+' instead of '|' for setting color.")

That I noticed by doing:

  diff -u tools/lib/rbtree.c lib/rbtree.c
  diff -u tools/include/linux/rbtree_augmented.h include/linux/rbtree_augmented.h

There is one other cases, but lets pick it in separate patches.

Link: https://lkml.kernel.org/r/ZigZzeFoukzRKG1Q@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Noah Goldstein <goldstein.w.n@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/rbtree_augmented.h |    4 ++--
 tools/lib/rbtree.c                     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/include/linux/rbtree_augmented.h~tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code
+++ a/tools/include/linux/rbtree_augmented.h
@@ -158,13 +158,13 @@ RB_DECLARE_CALLBACKS(RBSTATIC, RBNAME,
 
 static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
-	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
+	rb->__rb_parent_color = rb_color(rb) + (unsigned long)p;
 }
 
 static inline void rb_set_parent_color(struct rb_node *rb,
 				       struct rb_node *p, int color)
 {
-	rb->__rb_parent_color = (unsigned long)p | color;
+	rb->__rb_parent_color = (unsigned long)p + color;
 }
 
 static inline void
--- a/tools/lib/rbtree.c~tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code
+++ a/tools/lib/rbtree.c
@@ -58,7 +58,7 @@
 
 static inline void rb_set_black(struct rb_node *rb)
 {
-	rb->__rb_parent_color |= RB_BLACK;
+	rb->__rb_parent_color += RB_BLACK;
 }
 
 static inline struct rb_node *rb_red_parent(struct rb_node *red)
_

Patches currently in -mm which might be from acme@redhat.com are


