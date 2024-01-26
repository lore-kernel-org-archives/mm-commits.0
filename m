Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65846FA8;
	Fri, 26 Jan 2024 07:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255737; cv=none; b=HGGLon5bzx5oKy4HBC7CmqyDw/G3OTSakbA1WCpPPDyBQRjyEVQaB6puqqxqeqP4Ect2/QegOo7HpMY8/1iLIdHQiGupW0y6mquC7W9U+o80OLOVRIKgamk9AYkgjX1JPkdLG/fB6U17lUsD15Mymi2uoSWIAvVol03qsZ+r6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255737; c=relaxed/simple;
	bh=NyGHhL/rwDqeHhyfZWGT//uKcVcjOZ7lNmrf87RREn0=;
	h=Date:To:From:Subject:Message-Id; b=owB+HtUZUn0N1LXxDSY6q9lf/kH+v0x6zAam32WSA35CNPSMpXlvtK3Z314rXuqxlpaRf/DzVmSetxS2hKv8ZEY/nqGsdnypq+AI08L7vWq43ZGPjVsFmQ2KDt2px6NmjgFH5Y0VRkvlGVL2UbLCn6WISmkzx7MAox0DO2wDORw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wUPel4H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wUPel4H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02B4C433F1;
	Fri, 26 Jan 2024 07:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255737;
	bh=NyGHhL/rwDqeHhyfZWGT//uKcVcjOZ7lNmrf87RREn0=;
	h=Date:To:From:Subject:From;
	b=wUPel4H8sGC4IvZf2FmCYk4mheVCEFWdexg8p5cxP/OC0hB2qOkrtLy6h9aHYbQhi
	 XSgF12bkEx5ugad9FHKAhUSNRYwM8YRLqTF9fHRvLcYZ/HLLOPtuJabXDVe+60yc6q
	 gNrDcnlH+ZlJwaN4Y1jURp9pBZ0cOUEyX+z6eigQ=
Date: Thu, 25 Jan 2024 23:55:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,MPatlasov@parallels.com,zokeefe@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch removed from -mm tree
Message-Id: <20240126075536.D02B4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
has been removed from the -mm tree.  Its filename was
     mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zach O'Keefe" <zokeefe@google.com>
Subject: mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again
Date: Thu, 18 Jan 2024 10:19:53 -0800

(struct dirty_throttle_control *)->thresh is an unsigned long, but is
passed as the u32 divisor argument to div_u64().  On architectures where
unsigned long is 64 bytes, the argument will be implicitly truncated.

Use div64_u64() instead of div_u64() so that the value used in the "is
this a safe division" check is the same as the divisor.

Also, remove redundant cast of the numerator to u64, as that should happen
implicitly.

This would be difficult to exploit in memcg domain, given the ratio-based
arithmetic domain_drity_limits() uses, but is much easier in global
writeback domain with a BDI_CAP_STRICTLIMIT-backing device, using e.g. 
vm.dirty_bytes=(1<<32)*PAGE_SIZE so that dtc->thresh == (1<<32)

Link: https://lkml.kernel.org/r/20240118181954.1415197-1-zokeefe@google.com
Fixes: f6789593d5ce ("mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()")
Signed-off-by: Zach O'Keefe <zokeefe@google.com>
Cc: Maxim Patlasov <MPatlasov@parallels.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c~mm-writeback-fix-possible-divide-by-zero-in-wb_dirty_limits-again
+++ a/mm/page-writeback.c
@@ -1638,7 +1638,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need
_

Patches currently in -mm which might be from zokeefe@google.com are


