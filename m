Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F5274C14
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714101290; cv=none; b=Ta9z9kcFLkLudg+gcG7FKOYfMXBma1yQZk2nvg6TZBmLCyoeWqauDTxCrrcPXb0o/ENkVOaqyEZgBh+xHjPn+Lp6rH1Z22j+3MCxRZEzP6deG8png8lnbei+2K4IeNjY4tGHOkYY+1vvIY8OJkZrlBHzGV2BG6m6ckBryVnozmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714101290; c=relaxed/simple;
	bh=zo1jKd/0YR0Vqdm8IcdAIXDBAQAOr3tJFLOs+h2vb6Y=;
	h=Date:To:From:Subject:Message-Id; b=nqaSZMZf7zV2T5vTDvwI3h7VQ84oTVXVYLE+SSq8QkQ2a8yjTcLXhB61M3av2JYEjlm3ImAg6G1L50k1g3XmawJhTBn82jeHkbvDA/dFwRomhTd+MdHvQd8G8HLbI+xrd4YJ0HKVwMVm0AlRK5RVDPXJHAv+uxACEyN2pOMhbEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iG5+i+6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iG5+i+6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A3C113CD;
	Fri, 26 Apr 2024 03:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714101289;
	bh=zo1jKd/0YR0Vqdm8IcdAIXDBAQAOr3tJFLOs+h2vb6Y=;
	h=Date:To:From:Subject:From;
	b=iG5+i+6Gr3e6fOoK5WqDOSqi1RhTMK3TvPBmKGBboZwMwJR2gGDAl5H0rs+3SlZxN
	 Hi3CiNdPSHostYs6I3/e7gOgVE6I/1RFwLZaxoJOA//3uK91Qa2gef/CsWOPBe221b
	 JNT9FTvMX1tJitWsmMJwAJ385FD605D06AXut8r4=
Date: Thu, 25 Apr 2024 20:14:49 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,lukas.bulwahn@redhat.com,kent.overstreet@linux.dev,keescook@chromium.org,lbulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch removed from -mm tree
Message-Id: <20240426031449.C33A3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: improve entries in CODE TAGGING and MEMORY ALLOCATION PROFILING
has been removed from the -mm tree.  Its filename was
     maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch

This patch was dropped because it was folded into maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch

------------------------------------------------------
From: Lukas Bulwahn <lbulwahn@redhat.com>
Subject: MAINTAINERS: improve entries in CODE TAGGING and MEMORY ALLOCATION PROFILING
Date: Thu, 11 Apr 2024 08:47:17 +0200

Commit 5acf2502db99 ("MAINTAINERS: add entries for code tagging and memory
allocation profiling") adds the two new sections CODE TAGGING and MEMORY
ALLOCATION PROFILING.  The files in these sections however do not match
with the files added in the corresponding patch series.

Improve the two entries to refer to all files added with that series and
drop the entries to non-existing files.

Link: https://lkml.kernel.org/r/20240411064717.51140-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Kent Overstreet <kent.overstreet@linux.dev>
Tested-by: Kees Cook <keescook@chromium.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix
+++ a/MAINTAINERS
@@ -5256,6 +5256,7 @@ CODE TAGGING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 S:	Maintained
+F:	include/asm-generic/codetag.lds.h
 F:	include/linux/codetag.h
 F:	lib/codetag.c
 
@@ -14164,10 +14165,10 @@ M:	Suren Baghdasaryan <surenb@google.com
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
-F:	include/linux/codetag_ctx.h
+F:	include/linux/pgalloc_tag.h
 F:	lib/alloc_tag.c
-F:	lib/pgalloc_tag.c
 
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzk@kernel.org>
_

Patches currently in -mm which might be from lbulwahn@redhat.com are

maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch

