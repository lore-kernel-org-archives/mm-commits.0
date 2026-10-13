Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0022E57EDBC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 22:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791931957; cv=none; b=MVRKxN1hVwgq2ksmxYAGYlvcyv7Sj4vfY2qNXRWX6gH6GtBeMT4bTPccMyk6WnAvbrgofFZ51gVjUFhAQq9JufwBEOq0Qz14XPrTe3TCizfNeonn3kq/SMPxMzh22zAI68PeOxVzjCiqDk1hoZURGI2ygkW6cmASceaRnwTrrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791931957; c=relaxed/simple;
	bh=g0UBzu6MvDIgp1myzit8nIB/FbfgMbgb5Ql6xOW8TkY=;
	h=Date:To:From:Subject:Message-Id; b=floy49FLsCIEO3ZmcAbO2h/ZCjOmcGp4WCGEW758/m1v02Pdo5oFAUHABlh4DE+JLbpashHZD+KFkIrPaR3wNs7G11RLQyWOclBCPyB08bVWTDZzosOfXDFW/EW9SSpD+9JCqatfPAP752JWofeqJG9qcm4kGywNBn3BipV5wxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bM4ztuWn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bM4ztuWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9FB1F000FF;
	Tue, 13 Oct 2026 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791931952;
	bh=zJfeaKzb3X+KVV8ex1E48l8bGIPKGuaccfXnH6Oy/zo=;
	h=Date:To:From:Subject;
	b=bM4ztuWnpAp8Qg42paPs25ybb4QwrOXJT7PZ2FCgFMBebqKTml+6LbO6KjESeZzog
	 lOjKeqMpuYYUPjVcevx2vihoiAwX0aCRqdecMXmu2wHpMWOiA4+Dn8r6nM9Pri8lhz
	 6l771tjT9Sqilo0+n2lG4AsWlMcSpGAgjsAPhVQg=
Date: Tue, 13 Oct 2026 15:52:31 -0700
To: mm-commits@vger.kernel.org,teczm@foxmail.com,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261013225232.3E9FB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
Date: Tue Oct 13 03:50:35 PM PDT 2026

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: zhoumin <teczm@foxmail.com>
---

 fs/fat/misc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fat/misc.c~fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix
+++ a/fs/fat/misc.c
@@ -62,6 +62,7 @@ void _fat_msg(struct super_block *sb, co
 	_printk(FAT_PRINTK_PREFIX "%pV\n", level, sb->s_id, &vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL_GPL(_fat_msg);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
fat-roll-back-the-new-entry-when-create-mkdir-fails-to-build-the-inode-fix.patch

