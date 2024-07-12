Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54EF12FB2F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 23:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720827616; cv=none; b=NgTZRoMPQh+7gUxMmp8dMzy2hXoHqP6WIf2BD6AyS52JERVMwPqhlxU6d9Q4ukZdJbBx+4zr7q2K+oGm/DJliDlQzL9WSG/6Cx/YlhhJEBOepd6jOyqzaqL6poV8Vy1QvAG4Zbeo/SPSpCU6Tkv0ud0WxZbigRFPYVluQ/q069s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720827616; c=relaxed/simple;
	bh=IkdS661llyf5LtaV7WhseCIxhqbCwDB4yHz8KrUKcOQ=;
	h=Date:To:From:Subject:Message-Id; b=FBe/F8chz0dU1XIbkR7wTMAX/saTgR4m1JZAogxUb3OOV9VyrlRA+ddF8918dGWtSOfOZl4BAJBaFKZE6tSV9027D8A7x363obscT+yJceQspBQ64n699bqvqGtoz6nSBR6GVcwXoKTrHk0q3oYk8zg/Rj0gcFRfvGIOPq5oqS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WvX/le0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WvX/le0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1C5C32782;
	Fri, 12 Jul 2024 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720827615;
	bh=IkdS661llyf5LtaV7WhseCIxhqbCwDB4yHz8KrUKcOQ=;
	h=Date:To:From:Subject:From;
	b=WvX/le0BKkt/uNHsUGfzVSn2PwsS9rf33A4JPqa9k2jFIv5nssoN0HUQZqLwz9G+m
	 Q8At1E7f6PmpusB0BqXeILb/n4+GWcGvjnWwcUiHfjGcCfoI5xSRAKfvQi3eoXqTK/
	 aT7BuVS0N9rEB3JJAFZKzE8+LLxTg2RAT87c05Ao=
Date: Fri, 12 Jul 2024 16:40:14 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-constify-struct-kobj_type.patch removed from -mm tree
Message-Id: <20240712234015.6E1C5C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: Constify struct kobj_type
has been removed from the -mm tree.  Its filename was
     nilfs2-constify-struct-kobj_type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: nilfs2: Constify struct kobj_type
Date: Mon, 8 Jul 2024 23:32:42 +0900

'struct kobj_type' is not modified in this driver. It is only used with
kobject_init_and_add() which takes a "const struct kobj_type *" parameter.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  22403	   4184	     24	  26611	   67f3	fs/nilfs2/sysfs.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  22723	   3928	     24	  26675	   6833	fs/nilfs2/sysfs.o

Link: https://lkml.kernel.org/r/20240708143242.3296-1-konishi.ryusuke@gmail.com
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/sysfs.c~nilfs2-constify-struct-kobj_type
+++ a/fs/nilfs2/sysfs.c
@@ -56,7 +56,7 @@ static void nilfs_##name##_attr_release(
 						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
-static struct kobj_type nilfs_##name##_ktype = { \
+static const struct kobj_type nilfs_##name##_ktype = { \
 	.default_groups	= nilfs_##name##_groups, \
 	.sysfs_ops	= &nilfs_##name##_attr_ops, \
 	.release	= nilfs_##name##_attr_release, \
@@ -166,7 +166,7 @@ static const struct sysfs_ops nilfs_snap
 	.store	= nilfs_snapshot_attr_store,
 };
 
-static struct kobj_type nilfs_snapshot_ktype = {
+static const struct kobj_type nilfs_snapshot_ktype = {
 	.default_groups	= nilfs_snapshot_groups,
 	.sysfs_ops	= &nilfs_snapshot_attr_ops,
 	.release	= nilfs_snapshot_attr_release,
@@ -967,7 +967,7 @@ static const struct sysfs_ops nilfs_dev_
 	.store	= nilfs_dev_attr_store,
 };
 
-static struct kobj_type nilfs_dev_ktype = {
+static const struct kobj_type nilfs_dev_ktype = {
 	.default_groups	= nilfs_dev_groups,
 	.sysfs_ops	= &nilfs_dev_attr_ops,
 	.release	= nilfs_dev_attr_release,
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


