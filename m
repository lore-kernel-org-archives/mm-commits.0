Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E83D2907
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 02:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718420161; cv=none; b=UD4mvRKB+n0dNvrcDtfxK4RsEqX3OnmB8LLIGskbcp2knMdV3mgpTF8Ebpq1zh6X7pvCf4DBIP1LDX84K2T68r7d+5Nl8tIhRD/1KokpjrPeegj2zuFIq6eel1FhxCpzAACedGXnxNuir2YUvos4NHzm4EJC7w2butBqldaJvqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718420161; c=relaxed/simple;
	bh=SbYdBb8aS3+Qki6JyPbEN5ENKzwZTFH4L2yck2E8c8E=;
	h=Date:To:From:Subject:Message-Id; b=D1AVxszOEq7Ako9cpIXTOYlLUmdAUlFbWTcaASRsev2vVnXlnxEK3pxwVVW8VAfVJR7Q8DD/bxa4kxG0tK1Cwr6cCchSgvaf20Qk/drd2N7qVQBeFox69t0gPVSE4sVqsB4HJlyZYoAVFZAd5YXt8kmgIfLWU1REFEalQYCNXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1mxQ4+KI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1mxQ4+KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5EEC2BD10;
	Sat, 15 Jun 2024 02:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718420161;
	bh=SbYdBb8aS3+Qki6JyPbEN5ENKzwZTFH4L2yck2E8c8E=;
	h=Date:To:From:Subject:From;
	b=1mxQ4+KIzO4jZZSEFBb5P98VSLR+qb+PVdjWuWhYVv65Eoq+JIYfKfNH0KmfF/rN+
	 kv8BVVfSb9GdZvN4bxC79ud5s2EarCVSzMwsfIjihDQDw5u2qQpej+WNfU22AP/UiO
	 YU+rcy6b84NxO5H5tGcTHAAYhtmOtL0wyt4CclLo=
Date: Fri, 14 Jun 2024 19:56:00 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-constify-struct-ocfs2_stack_operations.patch added to mm-nonmm-unstable branch
Message-Id: <20240615025600.EC5EEC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: constify struct ocfs2_stack_operations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-constify-struct-ocfs2_stack_operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-constify-struct-ocfs2_stack_operations.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: ocfs2: constify struct ocfs2_stack_operations
Date: Fri, 14 Jun 2024 22:57:09 +0200

"struct ocfs2_stack_operations" are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increase overall security.

In order to do it, "struct ocfs2_stack_plugin" also needs to be adjusted
to this new const qualifier.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
   6241	    644	      0	   6885	   1ae5	fs/ocfs2/stack_o2cb.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
   6337	    548	      0	   6885	   1ae5	fs/ocfs2/stack_o2cb.o

Link: https://lkml.kernel.org/r/f52dab89ee0049ec6271de29183a781efbb275ab.1718398605.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/stack_o2cb.c |    2 +-
 fs/ocfs2/stack_user.c |    2 +-
 fs/ocfs2/stackglue.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/stackglue.h~ocfs2-constify-struct-ocfs2_stack_operations
+++ a/fs/ocfs2/stackglue.h
@@ -223,7 +223,7 @@ struct ocfs2_stack_operations {
  */
 struct ocfs2_stack_plugin {
 	char *sp_name;
-	struct ocfs2_stack_operations *sp_ops;
+	const struct ocfs2_stack_operations *sp_ops;
 	struct module *sp_owner;
 
 	/* These are managed by the stackglue code. */
--- a/fs/ocfs2/stack_o2cb.c~ocfs2-constify-struct-ocfs2_stack_operations
+++ a/fs/ocfs2/stack_o2cb.c
@@ -404,7 +404,7 @@ static int o2cb_cluster_this_node(struct
 	return 0;
 }
 
-static struct ocfs2_stack_operations o2cb_stack_ops = {
+static const struct ocfs2_stack_operations o2cb_stack_ops = {
 	.connect	= o2cb_cluster_connect,
 	.disconnect	= o2cb_cluster_disconnect,
 	.this_node	= o2cb_cluster_this_node,
--- a/fs/ocfs2/stack_user.c~ocfs2-constify-struct-ocfs2_stack_operations
+++ a/fs/ocfs2/stack_user.c
@@ -1065,7 +1065,7 @@ static int user_cluster_this_node(struct
 	return 0;
 }
 
-static struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
+static const struct ocfs2_stack_operations ocfs2_user_plugin_ops = {
 	.connect	= user_cluster_connect,
 	.disconnect	= user_cluster_disconnect,
 	.this_node	= user_cluster_this_node,
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

fsi-occ-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
most-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
proc-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
ocfs2-constify-struct-ocfs2_lock_res_ops.patch
ocfs2-constify-struct-ocfs2_stack_operations.patch

