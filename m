Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F133345A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967338; cv=none; b=blhevm3Gj8aAjMV07q2kHaWjGMMfOV5CvPmrI0uD6e4XT8GsSWPC5fGwRG3y3W+XaXuWuvymuvv4nNyC+ctpJey3ZsLvSjaA4Fd0MTNtESmiZq3ixwIehMz8TO5Kx5ijhaaBbgjbTo9o397KdMHnsfxRVVex+IE39UqOafVfVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967338; c=relaxed/simple;
	bh=lUKc7l4fxEyEcX2Y49mY4ENnfdCJG4sUXNUCaoc77dU=;
	h=Date:To:From:Subject:Message-Id; b=KR7AT9MQfAI5e0PMRB3MMh04RdKwwDPH9Hf6q+/TlZBKXmVwr/WPD7wOkdoJjMpuVXp2RKnU5WGiHid1ZHmRlw+3YFVxZYutthkcM4Zo9nOowcmZNqL1poqr/jSOMH6Ll3BRUkFJHETvEmNY5OybhGuYeHpcyQ9kyTjwmTu1H0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8JQSnwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8JQSnwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ABCC16AAE;
	Wed, 21 Jan 2026 03:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967337;
	bh=lUKc7l4fxEyEcX2Y49mY4ENnfdCJG4sUXNUCaoc77dU=;
	h=Date:To:From:Subject:From;
	b=M8JQSnwCJY9XdDKH9qRz+U10P2if7bLxTBxLN6UPETlBAB3ipqrDtMRXLdJ51sbnq
	 Z2p858c2dPETUp836p9Ft0xDn9UZjKdwQvxHq2/mrxNqL/U1u1ahWkV54RAig3bfIY
	 J8AvDFzH8sCzjw0S52MrxyxvnkWlOImrMrwKe0mA=
Date: Tue, 20 Jan 2026 19:48:56 -0800
To: mm-commits@vger.kernel.org,mic@digikod.net,masahiroy@kernel.org,ihuguet@redhat.com,danny@kdrag0n.dev,haokexin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] editorconfig-respect-editorconfig-settings-from-parent-directories.patch removed from -mm tree
Message-Id: <20260121034857.14ABCC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .editorconfig: respect .editorconfig settings from parent directories
has been removed from the -mm tree.  Its filename was
     editorconfig-respect-editorconfig-settings-from-parent-directories.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: .editorconfig: respect .editorconfig settings from parent directories
Date: Wed, 17 Dec 2025 12:23:27 +0800

Setting 'root' to 'true' prevents the editor from searching for other
.editorconfig files in parent directories.  However, a common workflow
involves generating a patch with 'git format-patch' and opening it in an
editor within the kernel source directory.  In such cases, we want any
specific settings for patch files defined in an .editorconfig located
above the kernel source directory to remain effective.  Therefore, remove
the 'root' setting from the kernel .editorconfig.

Link: https://lkml.kernel.org/r/20251217-editconfig-v1-1-883e6dd6dbfa@gmail.com
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Cc: Íñigo Huguet <ihuguet@redhat.com>
Cc: Danny Lin <danny@kdrag0n.dev>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .editorconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/.editorconfig~editorconfig-respect-editorconfig-settings-from-parent-directories
+++ a/.editorconfig
@@ -1,7 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-root = true
-
 [{*.{awk,c,dts,dtsi,dtso,h,mk,s,S},Kconfig,Makefile,Makefile.*}]
 charset = utf-8
 end_of_line = lf
_

Patches currently in -mm which might be from haokexin@gmail.com are


