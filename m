Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729D8369D4F
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783284067; cv=none; b=RAi2HFS+/IYKVLSgsP445jKtclp9UABmUcRWveiiiadm+mdwgDTtqJ0LgIR6epENrMZgY/vj6gqBevWM2dCORtuyW4kbd5WiDilAHHXT7IpCq2jlVoGL8SbB41r8I4TSCdCi7bxX65alFjXjwqJS8TUsZluE5C4T1WBAjyWr1zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783284067; c=relaxed/simple;
	bh=O5gCZU1OYWYl6CD4wIJlZUAJ4c1zBr7Vof5vtmlPMnk=;
	h=Date:To:From:Subject:Message-Id; b=nBn38rz17rF8n38GlQyuvVdNKVg1oa7M+G+xh77Kd/WHfledCjJ2uDJLeC//NHKU4XHhZhBAyabQsJGF6jkO0EBDhXkJVRhaTxxrJTp9nDo3RvFaOUD+dEvQL2p3nlonDrQfKgxpBDF5vziaVzhdy3z7UVqNEmY829D/sBMPUdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mjcMdQlc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mjcMdQlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E6A1F000E9;
	Sun,  5 Jul 2026 20:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783284064;
	bh=qB+g5Of5ftFPJ7UdJxCCAh8G6N75F+kBHzkigusKALw=;
	h=Date:To:From:Subject;
	b=mjcMdQlcRkOvFzjffuimLR+hL6ZdRho2Ap7IAZ/oMHNlJqcq6W5rSQ2ofdl55hEHs
	 18wqeQuHFLWIWWMNyOHw7uUfble4oVSSeogTMn9eMvAwObLjrTOJqSPh/aTVBOQYHH
	 Tn2N5QvW0HdBUCkHuxYBR8HPnjv3V4RdWzGQ8aug=
Date: Sun, 05 Jul 2026 13:41:04 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-abi-docs-and-selftests-to-zram-entry.patch added to mm-new branch
Message-Id: <20260705204104.98E6A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add ABI docs and selftests to ZRAM entry
has been added to the -mm mm-new branch.  Its filename is
     maintainers-add-abi-docs-and-selftests-to-zram-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-abi-docs-and-selftests-to-zram-entry.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: MAINTAINERS: add ABI docs and selftests to ZRAM entry
Date: Thu, 2 Jul 2026 16:56:55 +0800

Ensure updates to these files get sent to the right place.

Link: https://lore.kernel.org/20260702085655.51858-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

--- a/MAINTAINERS~maintainers-add-abi-docs-and-selftests-to-zram-entry
+++ a/MAINTAINERS
@@ -29780,8 +29780,11 @@ M:	Minchan Kim <minchan@kernel.org>
 M:	Sergey Senozhatsky <senozhatsky@chromium.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-block-zram
+F:	Documentation/ABI/testing/sysfs-class-zram
 F:	Documentation/admin-guide/blockdev/zram.rst
 F:	drivers/block/zram/
+F:	tools/testing/selftests/zram/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 M:	"Maciej W. Rozycki" <macro@orcam.me.uk>
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

tools-mm-add-thp_swap_allocator_test-binary-to-gitignore.patch
maintainers-add-abi-docs-and-selftests-to-zram-entry.patch

