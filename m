Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6BA3BB57
	for <mm-commits@vger.kernel.org>; Tue, 28 Jul 2026 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199329; cv=none; b=kqmOq3epEzZRmbhcTzzshiBJjdUWL3x1iY9W+kXCD7KfZD2FQgeHnbl/sm/nRf6JoOg6GMGVIewYl+z7EwPnWAI0uDl+3wz1gGxOQ2V8Ss+WPPghfi38VJ+64vyIWtH4AGcTMBEsmv73/078Uy9YATt3sBqiJ+zeYCBHG30IWb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199329; c=relaxed/simple;
	bh=mARYC3ogmxrjl3UyaYIIgGvcek7ygda5/auo0WIufNw=;
	h=Date:To:From:Subject:Message-Id; b=dVzWOYnYI6omC+dxsw/RaAjJgvySgvBraofcwnKrmwxtHx7Q0RKUdI73hiqVKMM4Q7zM3MJIpxVxj2WXGPfU+q3soG67+qaGRUTRPMxMviW94A40q/7mIRJmmoO4K2XcV4HmF9gc4WHzSNTdrvj219IqIg7zyWxB30LGppRbH2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vs478bA5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vs478bA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D681F000E9;
	Tue, 28 Jul 2026 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785199328;
	bh=5+oefEMwVpCb0EsO0E6YM/m1gN4mnNpJTLFxilzrkM8=;
	h=Date:To:From:Subject;
	b=Vs478bA5j04PQOYeGPhx331Qj/Vtzqm4laNyD6j+6fB+D1nFzCj7q7T2bYdlpSEgh
	 qyyFXogMJXFRYsZWS0MqfCHub9iAmf2kh8VYEZCBWdt27DKyMFYNRncRM/CNrfv1Qt
	 NMfPMVqEucUit2zCdgKmCGbh9Hr6w4kH4DVIQ03c=
Date: Mon, 27 Jul 2026 17:42:07 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,david@kernel.org,chengming.zhou@linux.dev,wsw9603@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch added to mm-new branch
Message-Id: <20260728004208.11D681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ksm: stop iterating VMAs when ksm_test_exit returns true
has been added to the -mm mm-new branch.  Its filename is
     ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch

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
@@ -2701,7 +2701,7 @@ next_mm:
 			struct folio *folio;
 
 			if (ksm_test_exit(mm))
-				break;
+				goto no_vmas;
 
 			int found;
 
_

Patches currently in -mm which might be from wsw9603@163.com are

ksm-stop-iterating-vmas-when-ksm_test_exit-returns-true.patch

