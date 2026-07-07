Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2E843F4AB
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783449017; cv=none; b=i3PfJ0S/bT9DHq3zmhY4+wtRxbonir+Tbetr+PwVWnasZfntELrDlzDHrZDX4S+3Fv811FbdjtW7QG24pXa0wVSi+UBeocSW8JhkFFfH4eYacV9x+jr7Wp12SaVNGTs8t4iz6bGG8Mpa7i5EQXWNWIHNxuGmasbl3VktGEgQPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783449017; c=relaxed/simple;
	bh=B/1Cz5sj8e3AEv9J/nVFmLhcwwAdW4iS2DnlLtFz11A=;
	h=Date:To:From:Subject:Message-Id; b=AT/1YSKKMkdkhqECHQMBeoIJir8oYlZYoO/HmSz7t6TKtEwthPVlCDJRA0V/9IvYJfn5BpKbbu2R+YGBjqkVlxPGVFmpzS4mtF/SM2Uqdz7a4k/qmOVjFXlCUuGsf2Ra7Bfj5yHv3lWzLEYUw1JusYkNwLe82NoMqZAL+gZQ110=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ny9eT6EA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ny9eT6EA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DAD1F000E9;
	Tue,  7 Jul 2026 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783449016;
	bh=55wbg91u1k6xzI+RuaMUVq0KT3WjSvgipeYTNigSCic=;
	h=Date:To:From:Subject;
	b=ny9eT6EAjGKI/pG1fKkn+hyqGdfAWvxb6Jo9yfn/J+fxJ969AzQcd9lvev/uJ5wDr
	 bb84e6RgUT9gQ3gBIt8+UtlDUre5oTrgNtFn4c+zGOtNp4/3yIWTayUEFOLFKsRall
	 yIV4bZdDG4nLFjfmgyUS2HxKJH4EkR7uKtXVITho=
Date: Tue, 07 Jul 2026 11:30:15 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,richardycc@google.com,minchan@kernel.org,corbet@lwn.net,rahularukonda2@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-zram-fix-spelling-mistakes.patch added to mm-unstable branch
Message-Id: <20260707183016.15DAD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: ABI: zram: fix spelling mistakes
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-zram-fix-spelling-mistakes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-zram-fix-spelling-mistakes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Arukonda Rahul <rahularukonda2@gmail.com>
Subject: docs: ABI: zram: fix spelling mistakes
Date: Tue, 7 Jul 2026 22:21:31 +0530

Fix spelling mistakes in the zram sysfs ABI documentation.

Link: https://lore.kernel.org/20260707165131.4408-1-rahularukonda2@gmail.com
Signed-off-by: Arukonda Rahul <rahularukonda2@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/ABI/testing/sysfs-block-zram~docs-abi-zram-fix-spelling-mistakes
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -152,15 +152,15 @@ Description:
 		compression algorithm parameters.
 
 What:		/sys/block/zram<id>/compressed_writeback
-Date:		Decemeber 2025
+Date:		December 2025
 Contact:	Richard Chang <richardycc@google.com>
 Description:
-		The compressed_writeback device atrribute toggles compressed
+		The compressed_writeback device attribute toggles compressed
 		writeback feature.
 
 What:		/sys/block/zram<id>/writeback_batch_size
 Date:		November 2025
 Contact:	Sergey Senozhatsky <senozhatsky@chromium.org>
 Description:
-		The writeback_batch_size device atrribute sets the maximum
+		The writeback_batch_size device attribute sets the maximum
 		number of in-flight writeback operations.
_

Patches currently in -mm which might be from rahularukonda2@gmail.com are

docs-abi-zram-fix-spelling-mistakes.patch

