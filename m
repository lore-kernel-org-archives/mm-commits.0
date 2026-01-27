Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8451169AD2
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 00:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769474075; cv=none; b=Umpb6PGCuJVbyFveD3YMa4G8He9us3NeIpHVxIS6DAAnyNtT22jqMgndFRR+VnGSF07+C15jjSFY7RUzLCufP4ZsU/MzeEIy9V9Ia+FXjwUWcGBSLQ+ohHToe5Dn6s7QpLry9ewkoe4b0ODXKyAqrF1nFhZMh8ANg5s5KoNena4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769474075; c=relaxed/simple;
	bh=ewuQF4JB+8x6Ofx0ZTC1PSmxLvTVLvd2MQ9kQACjaVI=;
	h=Date:To:From:Subject:Message-Id; b=hKqLcIcMdBJe9st0fwhUdIvlshlxncMfL1ZNnp+P4R/WDFN9cQD3U6UhDW3fnZ6+xqFblKf85+qq41n/oaNDbihKj5pv4lkDe2YdTeuUgAm0CX7+0mKmjWIhAPUep7Axi4Msxh+VDG7Xa4CZoQKmqewCuotge3emiMKEUZ5EQmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QRQ5kpy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QRQ5kpy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593FBC16AAE;
	Tue, 27 Jan 2026 00:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769474075;
	bh=ewuQF4JB+8x6Ofx0ZTC1PSmxLvTVLvd2MQ9kQACjaVI=;
	h=Date:To:From:Subject:From;
	b=QRQ5kpy2sRtZ0ivJ3OAXCaZB0AdezwrQt7UZs104vYUoAXBTvD4AL/FpDFbRc2Sqo
	 UNQVCYS0KXuu2mQErSGpIIeQ4chdQoPnOgnrFlAc+qv5RrOOcoab1FgCw1bFY0a44E
	 hTBipOKe8ll6tOGmEgpNxCkOcu1ZDpaETkBJVecI=
Date: Mon, 26 Jan 2026 16:34:34 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch added to mm-hotfixes-unstable branch
Message-Id: <20260127003435.593FBC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_file: do not clear serialized_data on unfreeze
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: liveupdate: luo_file: do not clear serialized_data on unfreeze
Date: Tue, 27 Jan 2026 00:02:52 +0100

The unfreeze operation is supposed to undo the effects of the freeze
operation.  serialized_data is not set by freeze, but by preserve. 
Consequently, the unpreserve operation needs to access serialized_data to
undo the effects of the preserve operation.  This includes freeing the
serialized data structures for example.

If a freeze callback fails, unfreeze is called for all frozen files.  This
would clear serialized_data for them.  Since live update has failed, it
can be expected that userspace aborts, releasing all sessions.  When the
sessions are released, unpreserve will be called for all files.  The
unfrozen files will see 0 in their serialized_data.  This is not expected
by file handlers, and they might either fail, leaking data and state, or
might even crash or cause invalid memory access.

Do not clear serialized_data on unfreeze so it gets passed on to
unpreserve.  There is no need to clear it on unpreserve since luo_file
will be freed immediately after.

Link: https://lkml.kernel.org/r/20260126230302.2936817-2-pratyush@kernel.org
Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze
+++ a/kernel/liveupdate/luo_file.c
@@ -402,8 +402,6 @@ static void luo_file_unfreeze_one(struct
 
 		luo_file->fh->ops->unfreeze(&args);
 	}
-
-	luo_file->serialized_data = 0;
 }
 
 static void __luo_file_unfreeze(struct luo_file_set *file_set,
_

Patches currently in -mm which might be from pratyush@kernel.org are

memfd-export-alloc_file.patch
mm-memfd_luo-use-memfd_alloc_file-instead-of-shmem_file_setup.patch
mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch
liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch
liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

