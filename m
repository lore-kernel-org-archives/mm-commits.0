Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DA8524C
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 20:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712867599; cv=none; b=TdubkWKK3xD3zQMe6yIB1pbVazoDyyCS8YjUjrFb34hMQ0s24wt9qUweQ3VCNYZEru5kfSc2NCqfdatw0uuYOCKFooW34cIuytNNhl3+hhSV28Zuw7L1tmn0rPrh+MOxsuuYtSV6/hQI+1HF8kBsR4krEZEgxPAcepZe8JnoY+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712867599; c=relaxed/simple;
	bh=pMk0mRmvRleQKTsnOswhQHJhhyPSeENF9BHsmjCscLU=;
	h=Date:To:From:Subject:Message-Id; b=mh4M6V0LR0Ee9C9nxHJ4hP4ZLaiF+UM1MbjUL1PybFjaLCDx80AywQkOqovEUI0sGoauc0gnkXVXnXUeEXq43ktez+N8sIUiObDqjZ5OO2itX2HFnVKviW4jFIeSW6o+hakDc6yS9njHzTVxJN7r+f7lIvFnCGNm+eWE5MS9CyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ec/G7+GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ec/G7+GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FF7C072AA;
	Thu, 11 Apr 2024 20:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712867599;
	bh=pMk0mRmvRleQKTsnOswhQHJhhyPSeENF9BHsmjCscLU=;
	h=Date:To:From:Subject:From;
	b=ec/G7+GS+mmwNjjKEJ97BngshhTnwDGVc6BtSBWkZhiruuPcUgGLoXyH0LtugggF5
	 55QHu104IAU6x7/P/SsTl7CjxkuEK+4l7wQJVij5TNejkQ5NNR1NWXJdoQF2MWUxjH
	 4H6WcIJ2rmI3UFQqCoUh1l1oxDrG9VUtxDBCCj3Q=
Date: Thu, 11 Apr 2024 13:33:18 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,lukas.bulwahn@redhat.com,kent.overstreet@linux.dev,lbulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch added to mm-unstable branch
Message-Id: <20240411203319.11FF7C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: improve entries in CODE TAGGING and MEMORY ALLOCATION PROFILING
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix
+++ a/MAINTAINERS
@@ -5258,6 +5258,7 @@ CODE TAGGING
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Kent Overstreet <kent.overstreet@linux.dev>
 S:	Maintained
+F:	include/asm-generic/codetag.lds.h
 F:	include/linux/codetag.h
 F:	lib/codetag.c
 
@@ -14167,10 +14168,10 @@ M:	Suren Baghdasaryan <surenb@google.com
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
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
_

Patches currently in -mm which might be from lbulwahn@redhat.com are

maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling-fix.patch

