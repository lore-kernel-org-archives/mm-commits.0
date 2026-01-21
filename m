Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A832AF1B
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967303; cv=none; b=vE6Vu2y6up8n3Mgtbh/JezyWayz9zZ9EYt+CHu2qf/JdU47nXdQ7mibfNMjTKgWxdWHjzgeadMvrt1JF4iI2Q4kH7U7X2r6CkfUSw23HmO4G+LVUr6hsyFo62zt/tj2O0c0YKhAJtuuDtgFPZe009VaihLYFZeArkq5RbRUVU3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967303; c=relaxed/simple;
	bh=5mCyn4gEsgOoWi+WlGQj8pgbZvZXNbUS+KaMIErQXYk=;
	h=Date:To:From:Subject:Message-Id; b=R8SgFjO3LxHVps4CRgiyRIeJ0H09cSPwol2Kaf6C6pELO8wbyIM0vgaGMdSS/DTfQcWty1Kcg8irFPP8W29dqgHHrbJt6wqJQr//p3zsugHn5eh+ewOGhtIvSLlOQZzuCT4CAt4QlVkDzrBFUMv0bg8K531MDQOkzlEUhRdUW9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZYdNTQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZYdNTQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594C5C16AAE;
	Wed, 21 Jan 2026 03:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967302;
	bh=5mCyn4gEsgOoWi+WlGQj8pgbZvZXNbUS+KaMIErQXYk=;
	h=Date:To:From:Subject:From;
	b=UZYdNTQNNolGC2vaAVjDr9y2AieMukrHKo9vwNUU1oGvZ5BMcMN65CiiCAGZfw0aE
	 RYr9uR2czFEzM8+aDq0qI0vsYbL02D5uoMGQhoFUslI5doNPcpXtwz8MbSdrnU+mIQ
	 vN1GrcNPdS75JeIoiJYXi/dYtR5s+vqa8zV5pZQM=
Date: Tue, 20 Jan 2026 19:48:21 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,coxu@redhat.com,bhe@redhat.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch removed from -mm tree
Message-Id: <20260121034822.594C5C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash_dump: constify struct configfs_item_operations and configfs_group_operations
has been removed from the -mm tree.  Its filename was
     crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: crash_dump: constify struct configfs_item_operations and configfs_group_operations
Date: Sun, 14 Dec 2025 18:57:30 +0100

'struct configfs_item_operations' and 'configfs_group_operations' are not
modified in this driver.

Constifying these structures moves some data to a read-only section, so
increases overall security, especially when the structure holds some
function pointers.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  16339	  11001	    384	  27724	   6c4c	kernel/crash_dump_dm_crypt.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  16499	  10841	    384	  27724	   6c4c	kernel/crash_dump_dm_crypt.o

Link: https://lkml.kernel.org/r/d046ee5666d2f6b1a48ca1a222dfbd2f7c44462f.1765735035.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Coiby Xu <coxu@redhat.com>
Tested-by: Coiby Xu <coxu@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations
+++ a/kernel/crash_dump_dm_crypt.c
@@ -223,7 +223,7 @@ static void config_key_release(struct co
 	key_count--;
 }
 
-static struct configfs_item_operations config_key_item_ops = {
+static const struct configfs_item_operations config_key_item_ops = {
 	.release = config_key_release,
 };
 
@@ -298,7 +298,7 @@ static struct configfs_attribute *config
  * Note that, since no extra work is required on ->drop_item(),
  * no ->drop_item() is provided.
  */
-static struct configfs_group_operations config_keys_group_ops = {
+static const struct configfs_group_operations config_keys_group_ops = {
 	.make_item = config_keys_make_item,
 };
 
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


