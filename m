Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4086228640C
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126375; cv=none; b=inifEP1kBikMmZKz/hyDy5dlGd7zsUQW0BP4zMjNm//gdwOrm2QnfP9r5hOLKUvVapzh54G/LyaBYS1GLi14AP+gL4QB+k2kPua9tQZ5THNA881ChoZHeswiIo10rijU9JFBQfyRHE1v2sgZc9ifkWnDb8tkSyJqg/et7rLvOL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126375; c=relaxed/simple;
	bh=szCUS3lh0q0scWmKs+lhoxv9JS2Q3jUbh+ZcOSJqHZg=;
	h=Date:To:From:Subject:Message-Id; b=HCesgsZeaOtAvQbyGdwuyj9x+asCLZXDwSZBhwbLJlyn6qk5I8vTn0oKEY6jUysRmunUgMMPf1OB0v44lzPn8eNxYnMpNnTZZ+kzkEpB2vlA6JK5bH5powpieEzBUUDR6W8lzfBsBHVIyc+VUkpx29kHxE7q5JhXztA2+/zScDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qtf70hB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qtf70hB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16881C4CEE3;
	Thu, 10 Jul 2025 05:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126375;
	bh=szCUS3lh0q0scWmKs+lhoxv9JS2Q3jUbh+ZcOSJqHZg=;
	h=Date:To:From:Subject:From;
	b=qtf70hB61v38iT1DOgxpqnBr5ThbBPJSis+UZNKnUOF5FgFBFTF132nzcdPN0e92O
	 rAWFQM//OzRLylNeIem5A3fIbJjvNuBy3vF8TCCaI9teiOmqflcwcygKQ0Al0ir4cy
	 QD4xHM2YSmE2wAxIzsm4qRYYvGhIMvgC0rZ3Swts=
Date: Wed, 09 Jul 2025 22:46:14 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,harry.yoo@oracle.com,bhe@redhat.com,00107082@163.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch removed from -mm tree
Message-Id: <20250710054615.16881C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: restrict default test mask to avoid test warnings
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: restrict default test mask to avoid test warnings
Date: Mon, 23 Jun 2025 20:40:35 +0200

When the vmalloc test is built into the kernel, it runs automatically
during the boot.  The current-default "run_test_mask" includes all test
cases, including those which are designed to fail and which trigger kernel
warnings.

These kernel splats can be misinterpreted as actual kernel bugs, leading
to false alarms and unnecessary reports.

To address this, limit the default test mask to only the first few tests
which are expected to pass cleanly.  These tests are safe and should not
generate any warnings unless there is a real bug.

Users who wish to explicitly run specific test cases have to pass the
run_test_mask as a boot parameter or at module load time.

Link: https://lkml.kernel.org/r/20250623184035.581229-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-restrict-default-test-mask-to-avoid-test-warnings
+++ a/lib/test_vmalloc.c
@@ -41,7 +41,7 @@ __param(int, nr_pages, 0,
 __param(bool, use_huge, false,
 	"Use vmalloc_huge in fix_size_alloc_test");
 
-__param(int, run_test_mask, INT_MAX,
+__param(int, run_test_mask, 7,
 	"Set tests specified in the mask.\n\n"
 		"\t\tid: 1,    name: fix_size_alloc_test\n"
 		"\t\tid: 2,    name: full_fit_alloc_test\n"
_

Patches currently in -mm which might be from urezki@gmail.com are


