Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB398149003;
	Mon,  2 Sep 2024 03:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248784; cv=none; b=kOcKuBtJPUouolmFAC5mqk0Nn1N6a6NExLiiq/B4jJx6JxOkFSb1YkiAPShfR2Mr514OMi6FuocMr+ydpNQWFrjwqHmXGALD1sWUwbwoReFziAJ4nrEWHsoA6qJ1cO/hBC8OYUB/lEaCboMX0HCgVZkydWURVVQQm5xhzPEzuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248784; c=relaxed/simple;
	bh=yM4ZQvzz2lwWgRAe1/vcVKz91hXkWwyTxPqyojz2JNY=;
	h=Date:To:From:Subject:Message-Id; b=YH/Cm3zTiFnNNG4LIrh3B0+k1eXIOUUjtEMvIRuhS0n31kgtF2oUZKWOKbrgcWPI+iVA+3Kv7fuDV06FMz62KGdJt6+Z1FL4pwBCRmKu1y4MJoLzb07dlDMkLUz2RwVo0lM5KY0M/S14uCI+fLHmbjSJdujKWZg3/R5ojpcEo8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=znYDQo28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="znYDQo28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800FAC4CEC7;
	Mon,  2 Sep 2024 03:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248784;
	bh=yM4ZQvzz2lwWgRAe1/vcVKz91hXkWwyTxPqyojz2JNY=;
	h=Date:To:From:Subject:From;
	b=znYDQo28ZF3tOMjXlSpK+VA93OTxnF7qe3c9AvKr0AzJuXTIXfgGmoAYLWKCzAt9d
	 kQuLCFzN5wVKZomH8DDPImv8cvpp9m+OiFVeGm42SR0Y1v1ZnBTejvPdkJOvkwzyYo
	 Ssf3mF3WDlaSYyAV+eYfY4PW6EsYy9vZNwFgCOjA=
Date: Sun, 01 Sep 2024 20:46:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,kuan-ying.lee@canonical.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-add-iteration-function-for-rbtree.patch removed from -mm tree
Message-Id: <20240902034624.800FAC4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: add iteration function for rbtree
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-iteration-function-for-rbtree.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


