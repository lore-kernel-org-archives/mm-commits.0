Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341D43264E9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334363; cv=none; b=LK4pB/bJE/aKdLHceldwscPMb3BxN+sUbisiXFbZA4vkWT7BjMI4UTYDnKXCXv9svEKxO7G789f7ibFNsFtY2m+PWFYmr0WqZ02ZlkToXF6qat/RPZ/5TIwpc3Jb7wx9w/ioj+JeYjc+tPkY1g7ewoTwjGkjs3tUjfbNUB5ajoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334363; c=relaxed/simple;
	bh=K4N6I+vco60guwG2Zzsa3nRidBXYjbUevJ7/cPjhgcU=;
	h=Date:To:From:Subject:Message-Id; b=ZsCd7nzjXsJSGyHEDPAnLdFezSvMQU8hIzhWFuW070W7iyXnOg1HMJVPqANpbTZMlBYDRqIPNg4Zf2jjuxoKYqrP78tpX2wDplH8MU66fnzZHlEdDdFqJv3g1NLsuVGuVdWUovpOMJANYqxEr19nSAE0vkPxjoKRinXepkHZcb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgiV8l24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgiV8l24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6D91F0089B;
	Wed,  7 Oct 2026 00:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334361;
	bh=IOtnitMBoAZpgwgsPQJMCu6o+SelVvxcQnXPftdcfsk=;
	h=Date:To:From:Subject;
	b=IgiV8l24B3YYBmwNT3SGHy6TbBkr5pqiHqVJP/biBuqySAagCy4MWXYTxyuEXy4cf
	 pSiT4qjTmhOpk5ahEs/fG0HB6BOaI21HjzXzsdee18SsfakrKaXfZ6jpN+GId/mUa5
	 7414oNJiQA6vNm1HFQ43jGxki9GDkL4Nd7Lr77xY=
Date: Tue, 06 Oct 2026 17:52:41 -0700
To: mm-commits@vger.kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-unreachable-kernel_read_file_from_path-return-check.patch removed from -mm tree
Message-Id: <20261007005241.CD6D91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: remove unreachable kernel_read_file_from_path() return check
has been removed from the -mm tree.  Its filename was
     zram-remove-unreachable-kernel_read_file_from_path-return-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove unreachable kernel_read_file_from_path() return check
Date: Tue, 1 Sep 2026 14:13:05 +0900

Sashiko reported that:
kernel_read_file_from_path() returns negative error for zero-sized
files, so we cannot have "sz == 0" return, remove it and use a
generic error message instead.

Link: https://lore.kernel.org/20260901051335.2202390-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
---

 drivers/block/zram/zram_drv.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-unreachable-kernel_read_file_from_path-return-check
+++ a/drivers/block/zram/zram_drv.c
@@ -1722,11 +1722,6 @@ static int comp_params_store(struct zram
 			       dict_path, sz);
 			return sz;
 		}
-		if (sz == 0) {
-			pr_err("failed to load dictionary %s (empty file)\n",
-			       dict_path);
-			return -EINVAL;
-		}
 	}
 
 	zram->params[prio].dict_sz = sz;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-convert-to-sg-list-zsmalloc-object-read-api.patch
zsmalloc-remove-old-object-read-api.patch

