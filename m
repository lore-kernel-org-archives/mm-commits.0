Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DA84779F;
	Mon, 18 Mar 2024 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788365; cv=none; b=XUhV7ifDAiX+I6rFVNnIsPg50MbWGZgItDKy5SKD6drcYRhKwHIjdN+4trqzl7KjbrBPb7nT5MHTYdLS90CQ5AXn2vi4+pSaqB2Hf6iRhzZ9ZJVX2TJRU5XTmDGbz0mViGvdq8igAox50ZBuyOcA/nFInlR0ht+DhG/pqDgCOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788365; c=relaxed/simple;
	bh=EOSK9+d6Z6SoUhmBAxBB5Nvd49G/ugfyRqD9hnMsSyI=;
	h=Date:To:From:Subject:Message-Id; b=gESN1PKwT2i+gK250/nosJ08GPFUbPAtEYizUIbIizs8nb9uimW+Sjf9eZdm5o5g1Bwc9Qr+MENTR67by1YjU7FTR7W6TWC6BanV7jqcRMxk/fMgdB3NX5vXqKutBHXq6ptXTHBv2tQ3RXxKES8qa5FcAEvaMywGwPjLzb9ibR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Kg36UOEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kg36UOEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3B9C433C7;
	Mon, 18 Mar 2024 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788364;
	bh=EOSK9+d6Z6SoUhmBAxBB5Nvd49G/ugfyRqD9hnMsSyI=;
	h=Date:To:From:Subject:From;
	b=Kg36UOEIZB6WaO4RzOKBgrkSNCukGBR/OSplOj8Gk2hFCqJUlo/q4/dL2HHzi0zhw
	 CkPTYamUj4y/3kIKqhFZVPRII/U43dbhpbanNJZN0fG7chrXXVnxbEtl2qqs5HgnyF
	 VvQPMikV6RVlyPuct7QkasftD0KLl/3rLUR47H88=
Date: Mon, 18 Mar 2024 11:59:24 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,ndesaulniers@google.com,axboe@kernel.dk,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-open-initrdimage-with-o_largefile.patch added to mm-hotfixes-unstable branch
Message-Id: <20240318185924.BC3B9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: open /initrd.image with O_LARGEFILE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     init-open-initrdimage-with-o_largefile.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-open-initrdimage-with-o_largefile.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Sperbeck <jsperbeck@google.com>
Subject: init: open /initrd.image with O_LARGEFILE
Date: Sun, 17 Mar 2024 15:15:22 -0700

If initrd data is larger than 2Gb, we'll eventually fail to write to the
/initrd.image file when we hit that limit, unless O_LARGEFILE is set.

Link: https://lkml.kernel.org/r/20240317221522.896040-1-jsperbeck@google.com
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/initramfs.c~init-open-initrdimage-with-o_largefile
+++ a/init/initramfs.c
@@ -682,7 +682,7 @@ static void __init populate_initrd_image
 
 	printk(KERN_INFO "rootfs image is not initramfs (%s); looks like an initrd\n",
 			err);
-	file = filp_open("/initrd.image", O_WRONLY | O_CREAT, 0700);
+	file = filp_open("/initrd.image", O_WRONLY|O_CREAT|O_LARGEFILE, 0700);
 	if (IS_ERR(file))
 		return;
 
_

Patches currently in -mm which might be from jsperbeck@google.com are

init-open-initrdimage-with-o_largefile.patch

