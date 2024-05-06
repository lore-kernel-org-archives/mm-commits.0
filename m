Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC00E38F96
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957139; cv=none; b=jeZMt9FNwXS+u32dlPIIyBahafg+GN4Az5J6VVA3inwKefUCPJQoAlbFif+hnDvR2bc7Q6ow77k8twIRk3ngGlaPWBPK8VHhf84xsVoIZrApbw6JTqS56FIyVaOkFdQQic7cj6R2tzbu5WssOXi7/YQC4ID6S9ie6LkXWp3v4Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957139; c=relaxed/simple;
	bh=n42DulaSvJou2z5Bh7ongVta7cnIW/DG4TmC958LhkA=;
	h=Date:To:From:Subject:Message-Id; b=AHJ9iR4DFcz93ex1+D8SSDRqFuyTrGZ1LdAzp9V5sAB1LdD9MevCexG0adGAKiCDGlE150nMwIOOBewLTU7WqzhiaNSKexHvF/KpBnA8SyE3NC+SCphabLtX92ihAP8j4Wev8FiaScz1/qDGWhFxJHQsbLbIAKn8h1VpAnS77UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ukwzfgy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ukwzfgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F94C113CC;
	Mon,  6 May 2024 00:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957139;
	bh=n42DulaSvJou2z5Bh7ongVta7cnIW/DG4TmC958LhkA=;
	h=Date:To:From:Subject:From;
	b=0ukwzfgyTL1DWY2tVVtsfV924QIOYGRQQSA5oL5O5j/wf1emBtsT/LBu2jCtLQdWO
	 2Ec0G7MG0BtOhf+D4ZyYv7iN3fgyuJ/Dtjeozbc09aLZ+XAUyDPRzp1kPr+BR32HwC
	 vXj07d7vwILcrXVnUq2H/+0KjJGwowzvVLKpEGvE=
Date: Sun, 05 May 2024 17:58:59 -0700
To: mm-commits@vger.kernel.org,lilinke99@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfile-mark-racy-access-on-si-highest_bit.patch removed from -mm tree
Message-Id: <20240506005859.90F94C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile: mark racy access on si->highest_bit
has been removed from the -mm tree.  Its filename was
     mm-swapfile-mark-racy-access-on-si-highest_bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: linke li <lilinke99@qq.com>
Subject: mm/swapfile: mark racy access on si->highest_bit
Date: Sat, 27 Apr 2024 14:29:56 +0800

In scan_swap_map_slots(), si->highest_bit can by changed by
swap_range_alloc() concurrently.  All reads on si->highest_bit except one
is either protected by lock or read using READ_ONCE.  So mark the one racy
read on si->highest_bit as benign using READ_ONCE.

This patch is aimed at reducing the number of benign races reported by
KCSAN in order to focus future debugging effort on harmful races.

Link: https://lkml.kernel.org/r/tencent_912BC3E8B0291DA4A0028AB424076375DA07@qq.com
Signed-off-by: linke li <lilinke99@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-mark-racy-access-on-si-highest_bit
+++ a/mm/swapfile.c
@@ -902,7 +902,7 @@ static int scan_swap_map_slots(struct sw
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
-		for (; last_in_cluster <= si->highest_bit; offset++) {
+		for (; last_in_cluster <= READ_ONCE(si->highest_bit); offset++) {
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
_

Patches currently in -mm which might be from lilinke99@qq.com are


