Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35111BF40
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712196538; cv=none; b=IulHxlkKfsdrRh5ab4frsY8N5GjWltBMkHYxbCkdt6yHFiUmjRaiaTpk/mbETDeeoryrDuZr39s/rM4P5UCO3ySsAFIGKW6yvOp+3hW9SHfbV7V211pnFh1zhQVMVYGcr0Sldwd8Jjc3gF/PN+9Agwn6oSL3QyYGojJgTyASqFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712196538; c=relaxed/simple;
	bh=kbrONDpc0vgkBeLoflUOjVNlnlBbO8ME7HowZVRKHL0=;
	h=Date:To:From:Subject:Message-Id; b=Ry1ayXhlGXv1m75jbLKWXaZKlTdNI2CkMWOEV+qY4BAuJCqedwAZFu4WVnTHLDAqNNAOm/gCCXtzExDr1S6FCoXplj4Ai8plbyOPr+UdK2kL00YjKwHZpN6ST34kd66vAnSCd8Jti17zcaX40wwqvh9K/+QP/WTr1nudhYVPDTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t1OhUZsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t1OhUZsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CC7C433C7;
	Thu,  4 Apr 2024 02:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712196538;
	bh=kbrONDpc0vgkBeLoflUOjVNlnlBbO8ME7HowZVRKHL0=;
	h=Date:To:From:Subject:From;
	b=t1OhUZsvBhHHPCtlCJhU+SGsJY25v7cN/MVDIXcod678j18iIGuZO8UWitVoAn4ny
	 WoIzB0bZA33sG6e3YUl8UOVrNO3UwzsufxysSYzfL/31ipNgrJ+U2BT8bdrNUx0zXi
	 ZGEKask5pinBrMLYadYlTYZcUWZgKJnUnrkCSlUI=
Date: Wed, 03 Apr 2024 19:08:57 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@toblux.com,pstanner@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,konishi.ryusuke@gmail.com,justinstitt@google.com,jlayton@kernel.org,brauner@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] nilfs2-fix-out-of-range-warning.patch removed from -mm tree
Message-Id: <20240404020858.50CC7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix out-of-range warning
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-out-of-range-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: nilfs2: fix out-of-range warning
Date: Thu, 28 Mar 2024 15:30:44 +0100

clang-14 points out that v_size is always smaller than a 64KB page size if
that is configured by the CPU architecture:

fs/nilfs2/ioctl.c:63:19: error: result of comparison of constant 65536 with expression of type '__u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (argv->v_size > PAGE_SIZE)
            ~~~~~~~~~~~~ ^ ~~~~~~~~~

This is ok, so just shut up that warning with a cast.

Link: https://lkml.kernel.org/r/20240328143051.1069575-7-arnd@kernel.org
Fixes: 3358b4aaa84f ("nilfs2: fix problems of memory allocation in ioctl")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Philipp Stanner <pstanner@redhat.com>
Cc: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/ioctl.c~nilfs2-fix-out-of-range-warning
+++ a/fs/nilfs2/ioctl.c
@@ -60,7 +60,7 @@ static int nilfs_ioctl_wrap_copy(struct
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	if (argv->v_size > PAGE_SIZE)
+	if ((size_t)argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
 	/*
_

Patches currently in -mm which might be from arnd@arndb.de are

kcov-avoid-clang-out-of-range-warning.patch

