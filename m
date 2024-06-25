Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0A1459E6
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293224; cv=none; b=jRv8yZ5OCxG/IIBulSPuFwD2kiAX1Lxho20Ui+qqffghbOdKr7Mayl2+s0s+iOALoEFlpcSAaHCP4XuGJ1A6DHfPAlWQGuXBJapIO3jEgJL8PTcyS5KGRgeFgCxWOEMV02xD4uOukw9JcqKy+PyW1Ogft78ddn88bQv/fgmVFsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293224; c=relaxed/simple;
	bh=f8fYqflUNTIoYMAZgPokvHOKmZKt/UejA7qprl16kq0=;
	h=Date:To:From:Subject:Message-Id; b=lihGcMWlazvqqCn1OQ3PcjjfgVriUQfMaHsJMEmgqoaguH7JdcvN4MjK2gsY8DtcJHQN5t8ZV4qjq43ppA1Qeo3b7e0AUJZqkcME2/3mVijvOKGrGsN/SOxazL7G7KvGqrruD6pbJ+hn41ppcqjvPt5j1qr3uBt8S9PNxMyEPJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C56TZEMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C56TZEMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B128C32782;
	Tue, 25 Jun 2024 05:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293224;
	bh=f8fYqflUNTIoYMAZgPokvHOKmZKt/UejA7qprl16kq0=;
	h=Date:To:From:Subject:From;
	b=C56TZEMF5rTNu2nW/OYcdEQgcw9D26GFxuCb9SoSrX5ohdiDodpHiJ/NMI1Y48RHR
	 /zfnp60EmEyVZDfVhQy3tTb3bdQUyEg4V3p0EohVSvSJxiGJeLDRZznowI/mO07BdE
	 q4LKGUNwaS1vXt2O+fdgC2rpyDvt1yJvSPZDCKHc=
Date: Mon, 24 Jun 2024 22:27:03 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,jiangqi903@gmail.com,ghe@suse.com,gechangwei@live.cn,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-constify-struct-ocfs2_stack_operations.patch removed from -mm tree
Message-Id: <20240625052704.2B128C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: constify struct ocfs2_stack_operations
has been removed from the -mm tree.  Its filename was
     ocfs2-constify-struct-ocfs2_stack_operations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


