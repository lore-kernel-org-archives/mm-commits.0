Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E296322AE5D
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 23:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756249480; cv=none; b=CMe8Rb6yHGOPV7krex0+S6zWcXQzs9EqKBchkhVVBFQc/Wu6UAWj36S54DLbKqkLuArPI+qU4Elzubi0C8y1P6djODvqS9IvZBSqLjT77CU11YPeqaDjMjBXtcMTqVXRnCqC2bV/qcAJIaHfMusS7hqPyu2ZLg3rLywGiyrb3CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756249480; c=relaxed/simple;
	bh=UoVBYkMwGKWaowvyjGVBhbU8hVp1FOgZ8FeJT+t2H98=;
	h=Date:To:From:Subject:Message-Id; b=QX6CspN+5mhsJhlfwbIZdGgRY8BMJw7XjvW8uqKiLd1sM6lnXGO14valZSbZh550vEN3YFx+4gQe5bxGFDw41FwJveC2CtGVL0Drz2uxXMI+AdgvDWYTmFl1Y0TJUBCDXT3lj9/bG+knDunC0gYIzhysXD+Z7eD6QAgU4buAl4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lxbnc+Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lxbnc+Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0F3C4CEF1;
	Tue, 26 Aug 2025 23:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756249479;
	bh=UoVBYkMwGKWaowvyjGVBhbU8hVp1FOgZ8FeJT+t2H98=;
	h=Date:To:From:Subject:From;
	b=lxbnc+RnXLkDYJxMPcvtAQkF6qXet8B9p+rUIXa7pGksr+JSofcDKx+KNHY2jIKbq
	 r/4w2tPcgba5pa13wtUsUmNfrm3psnN9oXi2OTj2+7SzIeuzA1WrSl9cHnVpTPEjNm
	 V24yP+3J1Ew1yE9FyHPaC9riEJahQG0rs4CWpQzM=
Date: Tue, 26 Aug 2025 16:04:38 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-make-sure-kho_scratch-argument-is-fully-consumed.patch added to mm-new branch
Message-Id: <20250826230439.5F0F3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: make sure kho_scratch argument is fully consumed
has been added to the -mm mm-new branch.  Its filename is
     kho-make-sure-kho_scratch-argument-is-fully-consumed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-make-sure-kho_scratch-argument-is-fully-consumed.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Pratyush Yadav <pratyush@kernel.org>
Subject: kho: make sure kho_scratch argument is fully consumed
Date: Tue, 26 Aug 2025 14:38:16 +0200

When specifying fixed sized scratch areas, the parser only parses the
three scratch sizes and ignores the rest of the argument.  This means the
argument can have any bogus trailing characters.

For example, "kho_scratch=256M,512M,512Mfoobar" results in successful
parsing:

    [    0.000000] KHO: scratch areas: lowmem: 256MiB global: 512MiB pernode: 512MiB

It is generally a good idea to parse arguments as strictly as possible. 
In addition, if bogus trailing characters are allowed in the kho_scratch
argument, it is possible that some people might end up using them and
later extensions to the argument format will cause unexpected breakages.

Make sure the argument is fully consumed after all three scratch sizes are
parsed.  With this change, the bogus argument
"kho_scratch=256M,512M,512Mfoobar" results in:

    [    0.000000] Malformed early option 'kho_scratch'

Link: https://lkml.kernel.org/r/20250826123817.64681-1-pratyush@kernel.org
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/kexec_handover.c~kho-make-sure-kho_scratch-argument-is-fully-consumed
+++ a/kernel/kexec_handover.c
@@ -451,6 +451,10 @@ static int __init kho_parse_scratch_size
 	if (!total_size)
 		return -EINVAL;
 
+	/* The string should be fully consumed by now. */
+	if (*p)
+		return -EINVAL;
+
 	scratch_size_lowmem = sizes[0];
 	scratch_size_global = sizes[1];
 	scratch_size_pernode = sizes[2];
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-make-sure-kho_scratch-argument-is-fully-consumed.patch

