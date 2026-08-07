Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908FE3B6363
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068162; cv=none; b=TyfMAjTRFye+1UgBjLFjgkUumnSowbNTQNKhObDW9w93HG9yHjQRWZu2gWAhcq5KjD6rh7CnwvADTZdWhStqHyi7+mVpO9ntTviUsnQAz98ZxlswofaDpRJ4ySYAdO0G2LpcOjvASiLpmHGVyxtYQ3CsxBRuAz1GOAT7kAjSqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068162; c=relaxed/simple;
	bh=a97CpfzJRDYemJVbkvOC+qr53ZQL3jn2Ys0cvuHIlcQ=;
	h=Date:To:From:Subject:Message-Id; b=X49SCeCTwh2pzn0PkdPK7R62E6I4xfHWKH6aWJ1FY4Nxlq08LSLRKqmueMsIeVm27Bx8BE5ruT7dNBqNQ4lMZCGvk/96+NkGAq51tLNEjRpCI5YXdQpwb+7tyxiplSWaS0Vdi4HvTG0CVozv01WD9B4cfLr9IFZpXzPjsmUWBSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjnZVTZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjnZVTZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658911F000E9;
	Fri,  7 Aug 2026 02:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068161;
	bh=AvDsXi+9OaP7UYOA7KoXkzuDT/wxXiYFSayLu73W6Wk=;
	h=Date:To:From:Subject;
	b=GjnZVTZ6KAi/FIPjg/zaFjf/r95aQxMWK0Phru1Xe/MI3KuZuA+W78SgufdaT06kw
	 +RoeE38F8rLwO1U/4HrB2XiQYCyrz7H2LZCU5K70gfpksieN/K+WNoOatL/b1X8O3/
	 VU0sIhZzsFTsE/WYLQCDBSAE0nOBW526m+EjJz9s=
Date: Thu, 06 Aug 2026 19:02:41 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@kernel.org,chengming.zhou@linux.dev,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch removed from -mm tree
Message-Id: <20260807020241.658911F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm: stop iterating VMAs when ksm_test_exit returns true
has been removed from the -mm tree.  Its filename was
     ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Wensheng <wsw9603@163.com>
Subject: ksm: stop iterating VMAs when ksm_test_exit returns true
Date: Sun, 26 Jul 2026 21:35:01 +0800

In scan_get_next_rmap_item() the break statement only exits the inner
while loop, leaving remaining VMAs to be iterated even if ksm_test_exit()
returns true.  Replace it with a goto statement to avoid the unnecessary
work.

Link: https://lore.kernel.org/20260726133501.504048-1-wsw9603@163.com
Signed-off-by: Wang Wensheng <wsw9603@163.com>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true
+++ a/mm/ksm.c
@@ -2700,7 +2700,7 @@ next_mm:
 			struct folio *folio;
 
 			if (ksm_test_exit(mm))
-				break;
+				goto no_vmas;
 
 			int found;
 
_

Patches currently in -mm which might be from wsw9603@163.com are


