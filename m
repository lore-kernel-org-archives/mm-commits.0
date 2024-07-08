Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F85145B06
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720474628; cv=none; b=qhys48jZPjkPCHFmIlOERoC/ez2M0POOsDyCq+RQITqUI3pUNAnXmDjfmZp3W7UatbmFtIqhMbCTjiw+QHsdDJ1vSFogN/zfSaYrpMpy65D9fWehqkOhKaAVeUJZGOO33v/KdPjG/kGSdV88wDHcdk+1PGtlqdHSLQ9Bc9y4Bac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720474628; c=relaxed/simple;
	bh=HSn4KjrfI6qMmf6AyvSlPvTs9fkMT1Yi4o5cZQAk3tM=;
	h=Date:To:From:Subject:Message-Id; b=PWugX5WzHjvK99K6/j4qx6EDNOR/wx7XXJOmIFsLiD+qWHHv43p3FuO2aqe2XFs6Y03DgZ40f/A3Vmv252e9TnnAw8PnyCDJd8Zj3U6E5t1opTyoFesX47/1WxNdF9s/0VC8Kwscyo/1ZWaWrJ8wxZHRHh2Rz0u859NbjOJNo4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IU9dA81j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IU9dA81j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EE1C116B1;
	Mon,  8 Jul 2024 21:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720474628;
	bh=HSn4KjrfI6qMmf6AyvSlPvTs9fkMT1Yi4o5cZQAk3tM=;
	h=Date:To:From:Subject:From;
	b=IU9dA81jD/E+CEM7U/9UvZxfW2+9dVbNDYSde2mgmPFJejuvy0eeYbyXdmri99G4d
	 ZPELxYil56yxZQFHNJyBm5zJzOxjdICVxztzx905TYNxohoctFqXTOb34dqOjsXNbW
	 5C0OKmb/hM6/tqwHsUrpXB5gI4EIrY0tjKsIV97g=
Date: Mon, 08 Jul 2024 14:37:07 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-constify-struct-kobj_type.patch added to mm-nonmm-unstable branch
Message-Id: <20240708213708.13EE1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: Constify struct kobj_type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-constify-struct-kobj_type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-constify-struct-kobj_type.patch

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

nilfs2-constify-struct-kobj_type.patch

