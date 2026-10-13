Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C162EEE84
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865910; cv=none; b=I8BjB2tostwNjtC0y/c5/S9ORPaQ+gTg0q91KHq+40Bpoo7sP9R5yvOVbsylTX2Vjy2f6xhDTaMFqGxz6nExt34FCRaaBMsOx94IyaeKmhHhZ4o4irB2gaUOcujW4FMmpU4CjQTr4rno6WGlYmpAYGcTTzEi9HowCfCo5RFrtR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865910; c=relaxed/simple;
	bh=1ELk+6Ur7ZqoZ0uuUDxNFeDmv+Qh1ox3QyV5JepfTe4=;
	h=Date:To:From:Subject:Message-Id; b=QEmMDXQt0BwnaB/P0LxRZJxTX30JBkhRY9tF8YPQ+2N5bHBlnGsOwhWpUbwqVap2gAq06W6rd8W78RnVw9QRrrmtwP0TgXPA9by0tLsnrNVGnVqmYtE+WhwVxDKHVQTc3u4cmFPBMp9l27mWuRW0HZNOlAaF3rWGxVbdsw0NYDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3RbfqYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3RbfqYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5C41F00893;
	Tue, 13 Oct 2026 04:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865908;
	bh=7w+jpCX8Rb4Prg6tGqecXaVhlULpm95sl2Em1yi1aok=;
	h=Date:To:From:Subject;
	b=x3RbfqYzx2ZW5HQhccrBlaP4r+HwfR7FJY44ZSRdtbClKdt37XwYZFXcjZDp8leRC
	 18bJuEj0FbF1kWEQscca6d2ES2gTwMbL1DLWsEdX7g+oAz/H5SGNgS9FwNPMfVtV0d
	 7FcumJCJy+3JWO/HocSOAmm5GN40HDlGtW+Hvb/U=
Date: Mon, 12 Oct 2026 21:31:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,eva.kurchatova@virtuozzo.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-ignore-test-generated-damon_dump_output.patch removed from -mm tree
Message-Id: <20261013043148.CE5C41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: ignore test-generated damon_dump_output
has been removed from the -mm tree.  Its filename was
     selftests-damon-ignore-test-generated-damon_dump_output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/damon: ignore test-generated damon_dump_output
Date: Mon, 14 Sep 2026 07:19:47 -0700

sysfs.py and sysfs_no_op_commit_break.py dump the DAMON status collected
via drgn_dump_damon_status.py into a damon_dump_output file in the working
directory.  Ignore it so that running the tests in-tree does not pollute
git status.

Link: https://lore.kernel.org/20260914141952.91465-3-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/damon/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/.gitignore~selftests-damon-ignore-test-generated-damon_dump_output
+++ a/tools/testing/selftests/damon/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 access_memory
 access_memory_even
+damon_dump_output
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

mm-damon-api-remove-unused-nr_damos_-enumerators.patch
selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

