Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F61C32
	for <mm-commits@vger.kernel.org>; Sat, 22 Feb 2025 00:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740183075; cv=none; b=B98WNgFZJxC7sosnBewC02GohyEIObSfDz8Ro6Z3IPaF6PXf8w2S8HAHSe+B4pVqr2oyUi1cwYjsAdqz7ddg49hClPoXbGtK+/tyoxAt5/0AURz4APoSs2JHoguu/NVmE7kC2z8O5SiPbGbVTIMPaJUgAZIF0Tj7732SX0xImmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740183075; c=relaxed/simple;
	bh=crfqDjFX5y5Jt3IVZ0E+zAijMg7n2W0SE4ewyPEAA1E=;
	h=Date:To:From:Subject:Message-Id; b=No4ainRMXkkn+tv71L36j7tRMxqDZ37LnlhjESy0J0Rrr4MqF1OGJritcEyC613BfEs5N4jOQkR9VceqY5D9H9RAHWgtM9Ll4dgaQEIgErNTiNWvHuz1EtX9kx7QjFEDVz/s0M2mp2SdKtaozX+rvlfQV8mPYIMBQaHsdt3q64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSRx9Ppy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSRx9Ppy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BD4C4CED6;
	Sat, 22 Feb 2025 00:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740183075;
	bh=crfqDjFX5y5Jt3IVZ0E+zAijMg7n2W0SE4ewyPEAA1E=;
	h=Date:To:From:Subject:From;
	b=FSRx9Ppya0cjZDKzZnahJ0/YWiwRzCao7CbdGK5hX/HXeM9Fybyxj1Sfoq71GTCeK
	 c90e1nNXPCheebKnqQ2I/44f5bY15+bkbUsyRBbzym9vRx3NHK9ATI6bzu/EGwpfZL
	 IyH9FmWU7RR1xNDWsNHppt8s5W92rxizG5ISQ5iQ=
Date: Fri, 21 Feb 2025 16:11:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-map_populate-on-weird-filesystems.patch added to mm-unstable branch
Message-Id: <20250222001115.45BD4C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip map_populate on weird filesystems
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-map_populate-on-weird-filesystems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-map_populate-on-weird-filesystems.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip map_populate on weird filesystems
Date: Fri, 21 Feb 2025 18:25:47 +0000

It seems that 9pfs does not allow truncating unlinked files, Mark Brown
has noted that NFS may also behave this way.

It doesn't seem quite right to call this a "bug" but it's probably a
special enough case that it makes sense for the test to just SKIP if it
happens.

Link: https://lkml.kernel.org/r/20250221-mm-selftests-v2-8-28c4d66383c5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_populate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-skip-map_populate-on-weird-filesystems
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -87,6 +87,13 @@ int main(int argc, char **argv)
 	BUG_ON(!ftmp, "tmpfile()");
 
 	ret = ftruncate(fileno(ftmp), MMAP_SZ);
+	if (ret < 0 && errno == ENOENT) {
+		/*
+		 * This probably means tmpfile() made a file on a filesystem
+		 * that doesn't handle temporary files the way we want.
+		 */
+		ksft_exit_skip("ftruncate(fileno(tmpfile())) gave ENOENT, weird filesystem?");
+	}
 	BUG_ON(ret, "ftruncate()");
 
 	smap = mmap(0, MMAP_SZ, PROT_READ | PROT_WRITE,
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-fix-assumption-that-sudo-is-present.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_threads.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longerm-tests-on-weird-filesystems.patch

