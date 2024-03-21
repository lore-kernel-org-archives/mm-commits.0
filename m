Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC3134CD2
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060161; cv=none; b=J5ZcErLCZZ0Qo2Ee1uOZT0He6mKJDbaVYBzSVvqdjIuU5usjrY6xhJAHNu5dFdSw31IMtzamw6lDvyuXXT3G0Msbh25BMwMlKccmU/0PIf6mhykjDURsYoQXd1/IxrSxMe9ukYpT2cEYP9+f3KOD+8r1jj203ri9QVC8bM8ofaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060161; c=relaxed/simple;
	bh=WTcbzbZUoH3sKdansLY62tlNKAoGmJp42uNHkc23G8A=;
	h=Date:To:From:Subject:Message-Id; b=IqVfAd+5N+9WEl93TYVGGwWqHBQl+XLWx5OM2N+msjn9Fe2qcGg0vgrUFfoncnfNVzij3Py9Qe2A+3PDvB5T7kPWKcOUNeL7fdMSE4gW0wYyUuaDmwIeNEhwqWGqBsO5tNb/UVwTJToLn2jryD42yqXfFE8AJHutnuybI+fQ8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V80byNL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V80byNL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C0AC433C7;
	Thu, 21 Mar 2024 22:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060161;
	bh=WTcbzbZUoH3sKdansLY62tlNKAoGmJp42uNHkc23G8A=;
	h=Date:To:From:Subject:From;
	b=V80byNL9pKard0lJOwJEMRwZTSMZzN31yyiT/gmJGC/5Mqf0JGI9eELRaQBGX7rOp
	 Rmw/nmyM7jYG79m/UL95ioPAGdh1BSpQTJX85P+LpaG2VTtHoywJeTeqg8VdfMsNqO
	 Ad+dYvg0BmYz5xtiIpTiLeAJXw7Xjee3ojz3yAXE=
Date: Thu, 21 Mar 2024 15:29:20 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + licenses-add-0bsd-license-text.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222921.71C0AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LICENSES: add 0BSD license text
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     licenses-add-0bsd-license-text.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/licenses-add-0bsd-license-text.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: LICENSES: add 0BSD license text
Date: Wed, 20 Mar 2024 20:38:35 +0200

The license text was copied from:

    https://spdx.org/licenses/0BSD.html

Link: https://lkml.kernel.org/r/20240320183846.19475-3-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 LICENSES/deprecated/0BSD |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- /dev/null
+++ a/LICENSES/deprecated/0BSD
@@ -0,0 +1,23 @@
+Valid-License-Identifier: 0BSD
+SPDX-URL: https://spdx.org/licenses/0BSD.html
+Usage-Guide:
+  To use the BSD Zero Clause License put the following SPDX tag/value
+  pair into a comment according to the placement guidelines in the
+  licensing rules documentation:
+    SPDX-License-Identifier: 0BSD
+License-Text:
+
+BSD Zero Clause License
+
+Copyright (c) <year> <copyright holders>
+
+Permission to use, copy, modify, and/or distribute this software for any
+purpose with or without fee is hereby granted.
+
+THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch

