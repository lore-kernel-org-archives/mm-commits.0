Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A703F1DEFD9;
	Wed, 16 Apr 2025 01:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744768790; cv=none; b=cgQ8iifmbfEC5t+A8SBB9+o02lCnE/d0RzmZ0kP+9ODKPqgM0Z335dxSCPh0UrGb6S5Y+HuZHRrsRU1NOu8ufunZkQi12tgwxnhO2GE+u3Pt64RvNDG8xLXMVgAgwXzgrUNNK/Jf+JDNSz0qnUKgCzW+OHXUcm5YXsuz5EiaaUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744768790; c=relaxed/simple;
	bh=T+JcDk+Nr8Wyri0eXCPOBFdIw6txoWoSZPGVnDvK9Ds=;
	h=Date:To:From:Subject:Message-Id; b=PDwr65aO1DBQrKVN80WW2O/LxR50Nx++UWOMQh/PipkMGQC4RVXXyJYG9n0l+A+ViKT3W7v3TrTDHYHkMkqSSCdWHucUAvh4n03a/9SMScd13KV4R6ZmX0aVMwE1JlG7QE+FEWndJXrvEKeXz9MqoGZwt7wOZp7BXZxsg4XEq3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XigM8p9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XigM8p9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14200C4CEE7;
	Wed, 16 Apr 2025 01:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744768790;
	bh=T+JcDk+Nr8Wyri0eXCPOBFdIw6txoWoSZPGVnDvK9Ds=;
	h=Date:To:From:Subject:From;
	b=XigM8p9dihVBWrQH7UM7wPg3ONTKlDHVQ30djiA4/yLwA+O9hRVV4DbD+3RVtHBuf
	 vxMn/BE6513qLImMk1LIR2fI9b8FK0oPlHKd9KOIUbA6xBJmeL+uMiTJ27vfaavgkj
	 i0vQcW3tW/itlpSZiVfdmKZK2LHYN/oHmVaz+0Uc=
Date: Tue, 15 Apr 2025 18:59:49 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,mengensun@tencent.com,fengguang.wu@intel.com,andrea@betterlinux.com,alexjlzheng@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-ratelimit_pages-update-error-in-dirty_ratio_handler.patch added to mm-hotfixes-unstable branch
Message-Id: <20250416015950.14200C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix ratelimit_pages update error in dirty_ratio_handler()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-ratelimit_pages-update-error-in-dirty_ratio_handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-ratelimit_pages-update-error-in-dirty_ratio_handler.patch

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
From: Jinliang Zheng <alexjlzheng@tencent.com>
Subject: mm: fix ratelimit_pages update error in dirty_ratio_handler()
Date: Tue, 15 Apr 2025 17:02:32 +0800

In dirty_ratio_handler(), vm_dirty_bytes must be set to zero before
calling writeback_set_ratelimit(), as global_dirty_limits() always
prioritizes the value of vm_dirty_bytes.

That causes ratelimit_pages to still use the value calculated based on
vm_dirty_bytes, which is wrong now.

Link: https://lkml.kernel.org/r/20250415090232.7544-1-alexjlzheng@tencent.com
Fixes: 9d823e8f6b1b ("writeback: per task dirty rate limit")
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: MengEn Sun <mengensun@tencent.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Fenggaung Wu <fengguang.wu@intel.com>
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-fix-ratelimit_pages-update-error-in-dirty_ratio_handler
+++ a/mm/page-writeback.c
@@ -520,8 +520,8 @@ static int dirty_ratio_handler(const str
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_ratio != old_ratio) {
-		writeback_set_ratelimit();
 		vm_dirty_bytes = 0;
+		writeback_set_ratelimit();
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from alexjlzheng@tencent.com are

mm-fix-ratelimit_pages-update-error-in-dirty_ratio_handler.patch

