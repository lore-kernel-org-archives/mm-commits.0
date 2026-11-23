Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454933;
	b=cQANMh5UCUb18KQhsqrplr2cpHxqfRfRBKfLfx4cDyjVPnJUcVA6xbn/BWowWbkatHet
	 Ax9i+gt6dunp02wHDwCHOJdV/zlfAdzRFrwtfHP7IjzIzkh1PahS+4nq+UYshqvAY3SoH
	 JG7F2D4QawVnqkmNBjMRICCq8PsBKh4pA4ikMhyq+UOY4K4iAv+G0ye/HLMBiQXA19Gx7
	 Hw/Nf1jbmWXnFujsNkQPaLiWchAcwc59dzK6Z5ahJmeCZLL0EeBCbBaKDYZciRVZC5WUu
	 rszHGYlhfFwmGw2MMuNok4b2Rv6mfW7q1UwDHz9SXiR/QW73FbzyjnWs0dt/yBEZSAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454933;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Bu86Dfdax2ipGOH6jSxcwVes79/6Zo/Sr3SfIirqF54=;
	b=xhqK6plRtiFIQ3S3IRvLRROCaT9/MJqKr7OqULvoRjRZyuyg9YfMcPJbrBZDM6puOF4M
	 Le95DRKMm4sDPkR/BrS5CDw6WJ9rKsUn3VCtuXtZyJ1wyeMcBypEe3kradytN4P2skOUT
	 XRmFCwHoJTU6eY4HbcTX7xqXcBqcdcpKZ2f/FAiBI8I6COUhh90vbAcc5KQB5KUjKTeq8
	 QZ2b9+H3LsXbcteHnWkbsJ5wNHhSzZlr6YLYWBzGgLY5mmui5W3+Z/XFRs6WI4BvwEhV+
	 PP6XPUGIblvwGYKEZzUpwpAeJv1Qs7ewI98ZVcVDvS5Yeq3UzAjO2r10FUwbw+INlaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P3Gu0sh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A79606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=P3Gu0sh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A611F000C4;
	Mon, 23 Nov 2026 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454933;
	bh=Bu86Dfdax2ipGOH6jSxcwVes79/6Zo/Sr3SfIirqF54=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=P3Gu0sh379jM60hsxAIQyk8+aZjvYRPoB8hFfcYAklCqsbF0qC3mpSoQk1wMGG9Or
	 WUXQzyT/tIQZZB7pDrHfc5FhWE0vsTOd5tdqVAwNZ8cQ8dw7GOXpWJ1waP8Ba1HNRQ
	 kUiBi7csOnS6oOWvrknmEpjxaCYSHTRh20uyhIBY=
Date: Mon, 23 Nov 2026 09:28:52 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-7-sj@kernel.org>
References: <20261123151309.82675-7-sj@kernel.org>
Subject: + docs-abi-damon-update-for-sz_ops_filter_passed_last.patch added to mm-new branch
Message-Id: <20261123172852.D1A611F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/ABI/damon: update for sz_ops_filter_passed_last
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Docs/ABI/damon: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:07 -0800

Update DAMON ABI document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Link: https://patch.msgid.link/20261123151309.82675-7-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-sz_ops_filter_passed_last
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -623,6 +623,13 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the total size of memory that passed
 		DAMON operations layer-handled filters of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/sz_ops_filter_passed_last
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the size of memory that passed DAMON
+		operations layer-handled filters of the scheme in bytes, in the
+		last apply interval of the scheme.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/qt_exceeds
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

