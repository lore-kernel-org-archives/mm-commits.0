Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C130C164
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219124; cv=none; b=F5khr8gtccam60rivYI/Zt8lGaqJP8I22iB8pPVukulCvJ0zg+LMdjKrJtXBKnCbgnwfumSuCWQqNiHQnApd07Cs4l2Y79xsWXzeo5vpsJo9ehUmh34aGoSRJIi2Bj/HwSGUAlodLCvD/ccwaGi9t/SQjZtsC2/EkC6qjWmJ7TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219124; c=relaxed/simple;
	bh=VcK4UcVs+bFeyDvZhywl9mCU4Z8/PjjqWr4ySczCfvg=;
	h=Date:To:From:Subject:Message-Id; b=YL40bk67wQtM0ZryMldWlpyNvWyIjB6ka885j/c17lKh6VdPyxbV1OsMWQblsHAkvEA6VufOns97nsHrnO381Hzo7+3cEZjOdEJe2zL+crfu05VZWnIzLWp3okMLdSEH0d6jwy1HqjpReqblQNa93AWlcu3ksdY52O6r9Q6MUCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oBz054Cb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oBz054Cb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A87C1F000E9;
	Mon, 31 Aug 2026 23:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219120;
	bh=Xx/AG01IZih+2PR5V9HTH/6dgN6/4hrMSwMONvG0704=;
	h=Date:To:From:Subject;
	b=oBz054CbXO3SZLTPrkC+Ls2vtJBAGIiGX1ksWx7qAD/4EyKlAzuRE+Pb6n+5xjc67
	 BuaF9Q4lQ6YvUICuEW+QrZxc2XyZU8VlPLbUKPjza5DCl5EAL12AJCNdjLphLKypCt
	 3bFzFbNxOAcOVZlBFNMTxQmcr+DOPFs8mOYFl+f4=
Date: Mon, 31 Aug 2026 16:31:59 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,jaeyeon.lee.dev@gmail.com,harimishal1@gmail.com,gregkh@linuxfoundation.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-mtier-add-comment-for-struct-region_range.patch added to mm-new branch
Message-Id: <20260831233200.5A87C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/mtier: add comment for struct region_range
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-mtier-add-comment-for-struct-region_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-mtier-add-comment-for-struct-region_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Enze Li <lienze@kylinos.cn>
Subject: samples/damon/mtier: add comment for struct region_range
Date: Mon, 31 Aug 2026 07:26:09 -0700

The mtier sample defines a local struct region_range using phys_addr_t
instead of damon_addr_range which uses unsigned long.  Add a comment
explaining the rationale: on 32-bit systems with more than 4GiB memory,
phys_addr_t will be 64-bit while unsigned long is 32-bit.

Link: https://lore.kernel.org/20260831142611.77572-8-sj@kernel.org
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-add-comment-for-struct-region_range
+++ a/samples/damon/mtier.c
@@ -52,6 +52,11 @@ module_param(detect_node_addresses, bool
 
 static struct damon_ctx *ctxs[2];
 
+/*
+ * Use phys_addr_t instead of damon_addr_range (unsigned long) for physical
+ * addresses.  On 32-bit systems with more than 4GB memory, phys_addr_t will
+ * be 64-bit while unsigned long is 32-bit.
+ */
 struct region_range {
 	phys_addr_t start;
 	phys_addr_t end;
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-introduce-damon_set_target_pid.patch
samples-damon-mtier-add-comment-for-struct-region_range.patch

