Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438124;
	b=ReGCZwBEB/NN+wobobFhTVusMD/9WYJroJ4vWi89VIZcaR7YBXNyC3mWvFakdPizMXhG
	 5id7eIhn3DKslSZc01OtMTn9PIg/PXmlIOPARFVfXNcClGJojyTMxOWkEwfaN8DnmZ6Cc
	 qNZxAg3n1nasKe838Xq/rTEZsLPrrE8e7Rd50RoNJBpC4HWr2ErYA/fQIpnpDgSF6TDba
	 o7rjWajMc8gaCHfaPSVeU/a8pUmCvDvQHemhs0fkRX4r9L7LaKkUu42HEYoAPzHqhUE//
	 0r8Axz6vWN4sREDepUvww9M3XrDiKQf+GsT3xk60ZNU2CaBmxKItylFnox69yT3KYYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438124;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=cwJBRXNREaOVWu47Wfg73fuoxIqifLn1OtmV/Ha2dbE=;
	b=JN4YI2jrjFZlONODkuCbsgMKmnKzwLYsQqtjljMS33RtO8qGfWcM/Bkq/qAtlTS9VN+d
	 TmVbxuBaQKA5Ba/J+BOCoXlzU4djZQ3qgtJB3faTbG1DsZjpqibca+Yh0Es2DtmGaukNI
	 Sx/omM7vbRt9qGsFiI812LNImq2/TzhKt+2059PQ2bO9q3K9Ck333X+kT441BlS8setPA
	 bI9pwLZRLOFLodGZgHGJY1hjakloKGMCxDSD1EpMJTrcZXe/x7PG6f8BBTUYlX2vvQ8NE
	 uKqMQrK2SXFcfby0CnvKZijQFBSzb0E3zAPsgl/1V/1pQyASI0BwiELh2H0De8Guk+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eQAEqoQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD98A606A33A
	for <mm-commits@vger.kernel.org>; Wed, 11 Nov 2026 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eQAEqoQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544441F00A05;
	Wed, 11 Nov 2026 23:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794438124;
	bh=cwJBRXNREaOVWu47Wfg73fuoxIqifLn1OtmV/Ha2dbE=;
	h=Date:To:From:Subject;
	b=eQAEqoQq8AhzhG9RcQBXqcxFaKKmFD5tuxX/oWL+/Y0XvJnrb1MsnjTPgb0FZuYoU
	 ikMwbCUO7aP/b4PIRT10zaKpq4NB6ZQJek7R91RzlxfhUR2BLn4iE2uLMZV74BlmkM
	 KrHx0gItYBvvoy2dVq1RvRk0erjuHOXPW/hbyxNU=
Date: Wed, 11 Nov 2026 15:02:03 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,
	tongweilin@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-serialize-disable-time-cleanup.patch added to mm-new branch
Message-Id: <20261111230204.544441F00A05@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: kmemleak: serialize disable-time cleanup
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-serialize-disable-time-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-serialize-disable-time-cleanup.patch

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
From: Weilin Tong <tongweilin@linux.alibaba.com>
Subject: mm: kmemleak: serialize disable-time cleanup
Date: Thu,  5 Nov 2026 17:52:49 +0800

kmemleak_do_cleanup() drops scan_mutex before removing tracked objects
without kmemleak_lock.  A concurrent clear command can therefore start
another cleanup while the background cleanup is still running.

Keep scan_mutex held until the background cleanup completes, serializing
its lockless removals with explicit clearing and report readers.

Link: https://lore.kernel.org/149d93f2cfe20d355f4d9882ce2bf99030217772.1793871596.git.tongweilin@linux.alibaba.com
Fixes: 2abd839aa7e6 ("kmemleak: Do not corrupt the object_list during clean-up")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-serialize-disable-time-cleanup
+++ a/mm/kmemleak.c
@@ -2532,12 +2532,13 @@ static void kmemleak_do_cleanup(struct w
 	 * function.
 	 */
 	kmemleak_free_enabled = 0;
-	mutex_unlock(&scan_mutex);
 
+	/* Serialize the lockless cleanup with report readers. */
 	if (!kmemleak_found_leaks)
 		__kmemleak_do_cleanup();
 	else
 		pr_info("Kmemleak disabled without freeing internal data. Reclaim the memory with \"echo clear > /sys/kernel/debug/kmemleak\".\n");
+	mutex_unlock(&scan_mutex);
 }
 
 static DECLARE_WORK(cleanup_work, kmemleak_do_cleanup);
_

Patches currently in -mm which might be from tongweilin@linux.alibaba.com are

tools-mm-thpmaps-fix-partial-thp-anon-file-accounting.patch
tools-mm-thpmaps-fix-missing-order-1-file-thp-statistics.patch
tools-mm-thpmaps-fix-missing-mapping-names.patch
mm-kmemleak-serialize-disable-time-cleanup.patch
tools-mm-thpmaps-handle-carriage-returns-and-non-utf-8-filenames.patch

