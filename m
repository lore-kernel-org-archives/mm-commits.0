Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C40026FA6F
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744919; cv=none; b=WZwVKV2S4C6he7pWHsOa8jFxl32uoO++qZKGHarwSoO2kd9nXVLGyxn6vp1NZy36kWdCUwduphf4+W+Oy9zKgUp2eJAbHvRfwWoNuFf3PevA6CZR0qTe33nCkyUIdsbHjCzxSkP546mKui4j5fi3hKwWanE/W6jfld1/3L+7p7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744919; c=relaxed/simple;
	bh=+HJO7QDvMwY5yspYmOjIhDxYxOKoUpcflSKX5iCm5L0=;
	h=Date:To:From:Subject:Message-Id; b=aAwJ1EzesaojqLj0wB6+pp31Xz+ip5Nv3QLpsJy9vKcUkR+LyGa4N0Mf6GeqDRRG6NF8xBD3pvBNryf7JZpioXgCjqgMg2rY4MyyIXWMviEo6c/4ODZEjEGJqjk/Y10ZEYXlcsiWWgKJnlFy5dI01XoskemOHaBhO0HehYHUTYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H5x+Gdhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H5x+Gdhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043BCC4CEF7;
	Sun, 29 Mar 2026 00:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744919;
	bh=+HJO7QDvMwY5yspYmOjIhDxYxOKoUpcflSKX5iCm5L0=;
	h=Date:To:From:Subject:From;
	b=H5x+Gdhzvjm/DX4VRyCgeCgIo6SABmEmyqaJnJDJEbuu7Xkj17eU8/OZixlZWjHff
	 QAuZrRk/ajuzwx8NBkXBALh6DL0Nsrlm8ZeSJVxJiXGlsJtL8MSjDbxmuMWUE4zWqA
	 a2UsLP42t+eJDcfXBjNFPOIfgYTwIsC/LHoP4yB4=
Date: Sat, 28 Mar 2026 17:41:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,nichen@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-remove-duplicate-include-of-swap_tableh.patch removed from -mm tree
Message-Id: <20260329004159.043BCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: remove duplicate include of swap_table.h
has been removed from the -mm tree.  Its filename was
     mm-swapfile-remove-duplicate-include-of-swap_tableh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chen Ni <nichen@iscas.ac.cn>
Subject: mm/swapfile: remove duplicate include of swap_table.h
Date: Wed, 18 Mar 2026 12:38:49 +0800

Remove duplicate inclusion of swap_table.h in swapfile.c to clean up
redundant code.

Link: https://lkml.kernel.org/r/20260318043849.399266-1-nichen@iscas.ac.cn
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-remove-duplicate-include-of-swap_tableh
+++ a/mm/swapfile.c
@@ -48,7 +48,6 @@
 #include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
-#include "swap_table.h"
 #include "swap.h"
 
 static void swap_range_alloc(struct swap_info_struct *si,
_

Patches currently in -mm which might be from nichen@iscas.ac.cn are


