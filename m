Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0D92BDC3F
	for <mm-commits@vger.kernel.org>; Sun, 14 Dec 2025 23:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765754822; cv=none; b=HVjhIu/9+2YbFfDa6uYi/y1ip4moKMLzc4cPmiifizeChhRv7972XpOfsiTfpp2HiaaFa+dsHkiDHwOZ9cGK1SAERgtEM5usm0zZKM5JSZjPadgKKKqr5SUEy0LqdRmqqUiYg6BN5cNvpbOus54FE9VMIl87ShpsZTlRRd847Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765754822; c=relaxed/simple;
	bh=pUdLeT93wwfTE1MfIASbBhCtqplakFGb1FXTOkOv1ac=;
	h=Date:To:From:Subject:Message-Id; b=kSn3ag+uCQSYTq8jpsilpDIJzX7oknoNgeS2i4QKjomu4BNDvpvrcgN3+/uBKyTOAzFaZNRNqTa6A5BNQnJCuFMj4usvzuNbdtY4jE132dDzm+ceVaFJGmwj/lLv7+rXfnsPWFwUkMQIsNLxrYeTXaVoGXvMXnYj5qtSZGmKGy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KQ2pA6Hc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KQ2pA6Hc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69CBC4CEF1;
	Sun, 14 Dec 2025 23:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765754820;
	bh=pUdLeT93wwfTE1MfIASbBhCtqplakFGb1FXTOkOv1ac=;
	h=Date:To:From:Subject:From;
	b=KQ2pA6HcN7YrYeUoRqx24blDAmNzBbLkNjUYmLvH/sVz3/S2GxfriNLI9vZCCpqFC
	 k2xV3L5y6Sfz4CN+HxLIi1jZOSJEeO1yVo6s+NmxMsHljvLYxXEpmeDEp+fxav02gK
	 iPd7MG/X+FOPqPFfbFfDsa5VfiBxQQKdNVQVz2Dg=
Date: Sun, 14 Dec 2025 15:27:00 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch added to mm-nonmm-unstable branch
Message-Id: <20251214232700.D69CBC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: constify struct configfs_item_operations and configfs_group_operations
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

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

crash_dump-constify-struct-configfs_item_operations-and-configfs_group_operations.patch

