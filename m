Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFD3587B0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967364; cv=none; b=k+zBh9iRxzcXJSzG87etez+MXwg8+hZOWOPAQt8RfzKvrtQY+jX1w2jt31IQgFqSkvnqRNiR98h5IaMuqu7AJdWstvRBtB49iktKA3q6qzV8SjREdRE43EgcDe18S74oihQS0AqnfAZMUrnsupf2rdc72uZrVcMjlX/eHSAi9Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967364; c=relaxed/simple;
	bh=reo5mQCMu6YxCJUycmNhF7HaGbIo/C3Gdbxr8GktSJU=;
	h=Date:To:From:Subject:Message-Id; b=efST7BX64NcB9k65kDQXSjUZ5yMqNBvbYS0DG9IY2TP/K6uYyviuWngkSl7dGuf1KxO84lp7OLHFo5t8YGAginuFp4S4vMaJkB2Xo1WA4kz6uGlxa127LW3WX9GJuMRqKtc1vLVxJb2ftBn91k+KKDq4STGAmGbxMLl/4bHJ8K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1797Ashb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1797Ashb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03B2C19424;
	Wed, 21 Jan 2026 03:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967363;
	bh=reo5mQCMu6YxCJUycmNhF7HaGbIo/C3Gdbxr8GktSJU=;
	h=Date:To:From:Subject:From;
	b=1797AshbXN+E3NQKNOVALiAo63ybE5+7rSvSiIRgFchFiiVJ0tsa8jFjIaRLR3rrW
	 UKVyyAJe5XIVindJEwWoYNWGidqX84FrVuKW1XYiJL5VH7jeBM7Ef12PPXWDv0FNrA
	 dwXUkQ7N/AgBqXluCdWl4ikQTAETl8x8K3o1mMXE=
Date: Tue, 20 Jan 2026 19:49:23 -0800
To: mm-commits@vger.kernel.org,mic@digikod.net,masahiroy@kernel.org,ihuguet@redhat.com,danny@kdrag0n.dev,corbet@lwn.net,kari.argillander@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] editorconfig-add-rst-extension.patch removed from -mm tree
Message-Id: <20260121034923.A03B2C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: editorconfig: add rst extension
has been removed from the -mm tree.  Its filename was
     editorconfig-add-rst-extension.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kari Argillander <kari.argillander@gmail.com>
Subject: editorconfig: add rst extension
Date: Fri, 19 Dec 2025 18:25:11 +0200

We have a lot of .rst documentation; use editorconfig rules for those. 
This sets the default tab width to 8, which makes indentation consistent
and avoids requiring developers to adjust editor settings manually.

Link: https://lkml.kernel.org/r/20251219-editorconfig-rst-v1-1-58d4fa397664@gmail.com
Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
Cc: Danny Lin <danny@kdrag0n.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mickael Salaun <mic@digikod.net>
Cc: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .editorconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.editorconfig~editorconfig-add-rst-extension
+++ a/.editorconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-[{*.{awk,c,dts,dtsi,dtso,h,mk,s,S},Kconfig,Makefile,Makefile.*}]
+[{*.{awk,c,dts,dtsi,dtso,h,mk,rst,s,S},Kconfig,Makefile,Makefile.*}]
 charset = utf-8
 end_of_line = lf
 insert_final_newline = true
_

Patches currently in -mm which might be from kari.argillander@gmail.com are


