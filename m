Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14E63BF66D
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068156; cv=none; b=nK+1xEVt0/0Zpnkn1SvdWUGelmqmzRboPCWd9zEz/FjbvPZj/EZJ7IaD/iS4jEQnaVdw+c+l6GUGHD/Q7SIS0Bsvz/k74C8qyMjtoPeKR/F3RriM3enkXiNrWwOIYq7ErJR55S5J0N93QiQe68F6HYqCaVqMSxH7HRFeQaasY/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068156; c=relaxed/simple;
	bh=eGMMsvgZ8G41wo9hmQNAjOFaaELL1CtewWqkUDK7vMA=;
	h=Date:To:From:Subject:Message-Id; b=TAwGlU9WVww/1phm+0AgL1EsJhCPL5BzDrMbtWQdMglD+n9GEbQBtD19CAa5JqZifMcTQp3LzXQ3ilrvQp6HUpYlyY7w70Dl+JWc2/erqJTLgutcIWgK0J1zewaLdKmUqEofRbkasBgcXJEvH6xrNG6rcAzDCz0Ui9nJG8CWObM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJ+3Jdp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJ+3Jdp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F7C1F00A3A;
	Fri,  7 Aug 2026 02:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068155;
	bh=gqtpGia6LzI0D/bm+j6GBFcGc/com6jLTZK8RAra5dg=;
	h=Date:To:From:Subject;
	b=cJ+3Jdp+Qzzt8jE0c8XvicTRRg19GjSNiIiWigiX/kOMPSTo3djnDz8YJGVrvBnVK
	 oaz0KnVwUucEFcjplygnJ2+54vp7FzNjFCFF7EaQf2jx7/j45ZSYf1B+O9i7ZKRRda
	 4K/veXu5CkIOVkmOl8/vbF7mnIPgJH+TLE78jGAg=
Date: Thu, 06 Aug 2026 19:02:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sarthak.sharma@arm.com,peterx@redhat.com,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@kernel.org,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-gup_longterm-einval-error-message.patch removed from -mm tree
Message-Id: <20260807020235.78F7C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix gup_longterm EINVAL error message
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-gup_longterm-einval-error-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: selftests/mm: fix gup_longterm EINVAL error message
Date: Fri, 24 Jul 2026 15:46:03 +0800

The gup_longterm test prints a literal "n" when PIN_LONGTERM_TEST_START
fails with EINVAL because the string is missing the newline escape
sequence.

Print a newline instead.

Link: https://lore.kernel.org/23557F4CB8CF36FF+20260724074603.1479243-1-zhaozhengzhuo@uniontech.com
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/gup_longterm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-mm-fix-gup_longterm-einval-error-message
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -196,7 +196,7 @@ static void do_test(int fd, size_t size,
 		args.flags |= rw ? PIN_LONGTERM_TEST_FLAG_USE_WRITE : 0;
 		ret = ioctl(gup_fd, PIN_LONGTERM_TEST_START, &args);
 		if (ret && errno == EINVAL) {
-			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)n");
+			ksft_print_msg("PIN_LONGTERM_TEST_START failed (EINVAL)\n");
 			result = KSFT_SKIP;
 			break;
 		} else if (ret && errno == EFAULT) {
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are


