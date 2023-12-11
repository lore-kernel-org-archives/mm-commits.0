Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091747493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S8CsZ+r0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7590C433C7;
	Mon, 11 Dec 2023 01:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257790;
	bh=N6ivMekfX3pI117YR24nfWhnSYFERTYTSddU80xeMo8=;
	h=Date:To:From:Subject:From;
	b=S8CsZ+r0otu4AG+ti51IgvWydFwOKSKCobxuDLtPzjkGXX09oZ2J+YeUZLBZlcAix
	 cOYYm5gUQ++tUzHhCXapsgM29KNenglA92z748UwcXUs8jm6mz0vICkKGL3QEFqB8/
	 vkxtPd9BPsoTr+YZI5oAhR78awPlIvPOt7C1GdVk=
Date: Sun, 10 Dec 2023 17:23:10 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-uaccess-remove-clear_user_hexagon.patch removed from -mm tree
Message-Id: <20231211012310.C7590C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: uaccess: remove clear_user_hexagon()
has been removed from the -mm tree.  Its filename was
     hexagon-uaccess-remove-clear_user_hexagon.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: uaccess: remove clear_user_hexagon()
Date: Thu, 30 Nov 2023 15:58:14 -0700

Patch series "hexagon: Fix up instances of -Wmissing-prototypes".

This series fixes all the instances of -Wmissing-prototypes in
arch/hexagon, as it is about to be enabled globally in a default build.


This patch (of 19):

Clang warns:

  arch/hexagon/mm/uaccess.c:39:15: warning: no previous prototype for function 'clear_user_hexagon' [-Wmissing-prototypes]
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        |               ^
  arch/hexagon/mm/uaccess.c:39:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     39 | unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
        | ^
        | static
  1 warning generated.

This function appears to have been unused since it was introduced in
commit 7567746e1c0d ("Hexagon: Add user access functions"), so remove it.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-0-5c34714afe9e@kernel.org
Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-1-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/uaccess.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/hexagon/mm/uaccess.c~hexagon-uaccess-remove-clear_user_hexagon
+++ a/arch/hexagon/mm/uaccess.c
@@ -35,11 +35,3 @@ __kernel_size_t __clear_user_hexagon(voi
 
 	return count;
 }
-
-unsigned long clear_user_hexagon(void __user *dest, unsigned long count)
-{
-	if (!access_ok(dest, count))
-		return count;
-	else
-		return __clear_user_hexagon(dest, count);
-}
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

