Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B8156999
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713994774; cv=none; b=PwnuMpEjDYMzDDbhDTCPoxeD+uvhwVg0iYVQlkC7OcZ/bexzxphgqZgGyuRdXyxgrQvqDCoeA0Ih2ANnOX3PswHRFJ5k2yvzW0qEFmnkZVAU5zynKkukFfM2GE7DL67xOBHeZMCh+vb/QTwuRDZn2iJN4Jc6bV48PvUfcvBIZ4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713994774; c=relaxed/simple;
	bh=574+9qTIG+xSGLH22Oy3LGiqBsU7ermyRdTvPgUm4zg=;
	h=Date:To:From:Subject:Message-Id; b=CMrMbyxLb/pV1CY0QeHyUC3ogE8bJ3MAqH7dYGvY7LnBT3M/Rm+tVTp6zJL4nMkd7BAmuM48rl0h8vpzQZ47+Dz9MpjZwGIXcT2R94oilb3ED0zTZTZLi+6T8zxuKx/rYYZelIKn0WLaTPFW7bPhmW2+vJrrqf8iwMO8lUN9IfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q+JRteTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q+JRteTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41746C113CD;
	Wed, 24 Apr 2024 21:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713994773;
	bh=574+9qTIG+xSGLH22Oy3LGiqBsU7ermyRdTvPgUm4zg=;
	h=Date:To:From:Subject:From;
	b=Q+JRteTOmq1y6+ZwjN38prZt3CmXpflEQNzPMzzj3g1ohrX+XUAPGw+7BgucLh87m
	 NrRUaKIU8br2ZcQRN5lsBTDhpepPpdsEUQmWHrP9EBsbsbf8IIyJN8WXePg1pdINAe
	 IZKJjxN57A+mighL6E7dcV3V1xm22NUg8ZlW2WUg=
Date: Wed, 24 Apr 2024 14:39:32 -0700
To: mm-commits@vger.kernel.org,namhyung@kernel.org,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,goldstein.w.n@gmail.com,adrian.hunter@intel.com,acme@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch added to mm-nonmm-unstable branch
Message-Id: <20240424213933.41746C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools lib rbtree: Pick some improvements from the kernel rbtree code
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: tools lib rbtree: Pick some improvements from the kernel rbtree code
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

tools-lib-rbtree-pick-some-improvements-from-the-kernel-rbtree-code.patch

