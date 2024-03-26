Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0F380050;
	Tue, 26 Mar 2024 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476490; cv=none; b=gOiGoTdPAlpvnSJCWOsq735NV0BPL6tHA4zLmhqIniE6uaeo9lmvSpDG9MBWIlGTda067p6Xc3S4ZrHvCPe0G54J0rv2hQMbYxeWOEF50m5BzsIgWcC0kcsejzQ6bs98bH130hc9WjszIfc1nWqjC07Y3AAuivC2Vkv0oJ6WeM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476490; c=relaxed/simple;
	bh=Jz5mkQBA/c4jmu92lv1c/tkY4hCwH7Jh6dS+ecfq78E=;
	h=Date:To:From:Subject:Message-Id; b=LlKc7pPA9hZaBgogYdZhasI9nlsBjnIwdInaPgKav+0BxF2xb+M4nRtmHjvruhKVRaXl3lTDVjAJ3XL3rjXIzsnixpPjAOs6j2O52Wd25P9j+ypwhEOFBim58BkZNP0Y1kiicweFaRZg+1fLG9FRYgLkUsrj8rcNDRDoVPvfRsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kBw/u1PQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kBw/u1PQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AC6C43390;
	Tue, 26 Mar 2024 18:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476489;
	bh=Jz5mkQBA/c4jmu92lv1c/tkY4hCwH7Jh6dS+ecfq78E=;
	h=Date:To:From:Subject:From;
	b=kBw/u1PQJuEHsee2KjWHZTHQPXEL67IaCbPBCn6M36Pbjf4HOfcv0JVtgcOLRzgFa
	 qIQ1RhhnYCDU1VkTvV981/MBM/4y+FYkRUsW7rqjKQAZuZr71CyA5hlQz3urYPEEms
	 5pbjILgp+MelyB9BXJIlLMjLFLtQGPmp+pgN+Bjg=
Date: Tue, 26 Mar 2024 11:08:09 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,ndesaulniers@google.com,axboe@kernel.dk,jsperbeck@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] init-open-initrdimage-with-o_largefile.patch removed from -mm tree
Message-Id: <20240326180809.C2AC6C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init: open /initrd.image with O_LARGEFILE
has been removed from the -mm tree.  Its filename was
     init-open-initrdimage-with-o_largefile.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


