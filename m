Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A655D15250D
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 20:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714076620; cv=none; b=tocvdFzlIv/H41lS66iTNNo99p2AkOlAZXNAi3HGGEWi2xcPZCEBieKr0JtNpmZ+NRonxnYl16yVE0LOe2Bcu455jeTiA52zjN/hkTvm1TXCyZVQLjDmWb9EZ66fEP7eeBLk9XBpgDjjbH7TQMvAfyPG8dHg0yFg1bwtrz0zAeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714076620; c=relaxed/simple;
	bh=FppnvpE3yjvAkghCg/UtV1WWkHewDz4UJrINBSmHGA0=;
	h=Date:To:From:Subject:Message-Id; b=nrsPBuDo10VU3elYTrpDh6RaSDJVgpD570hondMUXBKzXXEEpN1DC1fQLLgvDtvUmJhNzS7ePSt6FLM4PNNlyRSsxhz50e/c/xCTT/72MomSAtM6yg5+T8FztRIB839OWHytg9MjgMaalZ82IJBLVOsFVkDhSVJsUrEbcZU8QuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrtgfQF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrtgfQF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296FBC113CC;
	Thu, 25 Apr 2024 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714076620;
	bh=FppnvpE3yjvAkghCg/UtV1WWkHewDz4UJrINBSmHGA0=;
	h=Date:To:From:Subject:From;
	b=VrtgfQF3Wb6aXT7WUlQgmQb0tMZT//e1Fcch69bELEyj7USM6fxBwCygUbN++THpr
	 fxQmrGJUXx6wXWz9tijm50cGbZ53HIcoI9QNbhJAQaLluzROzlsf3eTJfuUIsJNSev
	 MzKeibl5sK576t3MWAhE8ICyuPA6PByDvYx2FlmE=
Date: Thu, 25 Apr 2024 13:23:39 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,keescook@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-5.patch added to mm-unstable branch
Message-Id: <20240425202340.296FBC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-5.patch

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
From: Kees Cook <keescook@chromium.org>
Subject: alloc_tag: Tighten file permissions on /proc/allocinfo
Date: Thu, 25 Apr 2024 13:08:50 -0700

The /proc/allocinfo file exposes a tremendous about of information about
kernel build details, memory allocations (obviously), and potentially even
image layout (due to ordering).  As this is intended to be consumed by
system owners (like /proc/slabinfo), use the same file permissions as
there: 0400.

Link: https://lkml.kernel.org/r/20240425200844.work.184-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/alloc_tag.c~lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-5
+++ a/lib/alloc_tag.c
@@ -90,7 +90,7 @@ static const struct seq_operations alloc
 
 static void __init procfs_init(void)
 {
-	proc_create_seq("allocinfo", 0444, NULL, &allocinfo_seq_op);
+	proc_create_seq("allocinfo", 0400, NULL, &allocinfo_seq_op);
 }
 
 static bool alloc_tag_module_unload(struct codetag_type *cttype,
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-5.patch

