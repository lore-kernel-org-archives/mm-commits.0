Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC391494D6;
	Tue, 23 Jul 2024 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721778041; cv=none; b=AWSiQ0B+2YJRT4f/yzpEBlJQLURdH2dwW1wyt21V9d2gLUQAFX7CZ7b6BO1nf03mnoZkopxVb4GYy8QzWLAl/Jn6AyNBqzPDoJgn/rStFybfxO7/asBgXEwfj4G5icqyT9/2uctV8M32eirb8mDSD5F/WfHhlf+dOnGbeHU/4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721778041; c=relaxed/simple;
	bh=IEG+rSejPvj/5KmDInvFAnnoR9hffTVUc+GLZco/5W0=;
	h=Date:To:From:Subject:Message-Id; b=UcGaHy2qTMG4xzNlhNJZTvsZP0vXAdGw6L0UJwd5xAo1zeN856k9acTJs2ibNzWWqyH66CBfpDYzhf0pB++bjUmURAFT2MeVUFPWhVN/xxGFCmOaJmO3+dZE1I8ZzNLWGC9TAvInyCD/JNXnjOwGJnT3xobfE5gl/WS0HORNZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qii3mLOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qii3mLOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD654C4AF09;
	Tue, 23 Jul 2024 23:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721778040;
	bh=IEG+rSejPvj/5KmDInvFAnnoR9hffTVUc+GLZco/5W0=;
	h=Date:To:From:Subject:From;
	b=Qii3mLOrzF4m8R9gwjG9G2wCs6/c1NxgPs3lOrGbrKCz3ewtmqNVdN/Ab69AcNaYJ
	 G68DvM42urieNGsuXZk6r3+OQeYfbiUvhwfqycrtmC9q2yDz1nFJRbhil0YhOuYZcL
	 PatfrfwaKT/pD+XHbqP8o1g7OjwfiJBp1dqy2S5A=
Date: Tue, 23 Jul 2024 16:40:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-add-iteration-function-for-rbtree.patch added to mm-nonmm-unstable branch
Message-Id: <20240723234040.CD654C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: add iteration function for rbtree
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-add-iteration-function-for-rbtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-add-iteration-function-for-rbtree.patch

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
From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Subject: scripts/gdb: add iteration function for rbtree
Date: Tue, 23 Jul 2024 14:48:58 +0800

Add inorder iteration function for rbtree usage.

This is a preparation patch for the next patch to fix the gdb mounts
issue.

Link: https://lkml.kernel.org/r/20240723064902.124154-3-kuan-ying.lee@canonical.com
Fixes: 2eea9ce4310d ("mounts: keep list of mounts in an rbtree")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/rbtree.py |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/scripts/gdb/linux/rbtree.py~scripts-gdb-add-iteration-function-for-rbtree
+++ a/scripts/gdb/linux/rbtree.py
@@ -9,6 +9,18 @@ from linux import utils
 rb_root_type = utils.CachedType("struct rb_root")
 rb_node_type = utils.CachedType("struct rb_node")
 
+def rb_inorder_for_each(root):
+    def inorder(node):
+        if node:
+            yield from inorder(node['rb_left'])
+            yield node
+            yield from inorder(node['rb_right'])
+
+    yield from inorder(root['rb_node'])
+
+def rb_inorder_for_each_entry(root, gdbtype, member):
+    for node in rb_inorder_for_each(root):
+        yield utils.container_of(node, gdbtype, member)
 
 def rb_first(root):
     if root.type == rb_root_type.get_type():
_

Patches currently in -mm which might be from kuan-ying.lee@canonical.com are

scripts-gdb-fix-timerlist-parsing-issue.patch
scripts-gdb-add-iteration-function-for-rbtree.patch
scripts-gdb-fix-lx-mounts-command-error.patch
scripts-gdb-add-lx-stack_depot_lookup-command.patch
scripts-gdb-add-lx-kasan_mem_to_shadow-command.patch

