Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D992537FF4D
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782755046; cv=none; b=UaQCUWoX8llS89yx8fPf7+vQ4+dLuN9bnYYgPjLYrtKPrmQUldOatOIfWJkxIyydmRlAmlO4PDv4crAJT6f2i3JDbWOvad359DqvKclOD0AucUQQd1rsivfKQMDa6ogNWorHaQ2c2JtNvCs5IFsQ7Ge4pieNjdINzR04Y7zFOYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782755046; c=relaxed/simple;
	bh=DUtu8yJSALP2bSJ3QiMeUZUMIIJxD6vXQErUbMKaTJQ=;
	h=Date:To:From:Subject:Message-Id; b=qccaQIF+QPJ4B/AGkGXIsMyWNQoWC0xpsQTxAUSqTdoAdDMLdgkBWdDywmeZ8xqrfF8gfI5Spk1hSFbUt5cCc30JTaLY4c2PalPeNpHsgEZXMfNwB0WWEQRg5bKi7LLs4qXzemlXCPa95g1/TxeZvF/8WBl7LLK7bAJC/YgrjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eprEyfN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eprEyfN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6413E1F00ACF;
	Mon, 29 Jun 2026 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782755044;
	bh=Br3tmf2u+Uc6hoyWRkRyQHIQ67teUdYLXpzjTk6oFv4=;
	h=Date:To:From:Subject;
	b=eprEyfN0zKkyeuDXR4IgvL83kD1/kx6G2L0fsJ9tSorlGR+zkdjQLhjP0U+KYnEBX
	 8xMdAFNwPONQTfXeSJrcb/+STBGgoT8XzRVJUtkLVCX+edLE+Cfs4IWzPtn8tUQ9FM
	 JQRGx9rjJug5Gkj5QWMdidxO6Yu0UBjLhxCZ1e1Q=
Date: Mon, 29 Jun 2026 10:44:04 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch added to mm-new branch
Message-Id: <20260629174404.6413E1F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/damos_tried_regions: fix expectation output and join TypeError
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch

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
From: Kunwu Chan <chentao@kylinos.cn>
Subject: selftests/damon/damos_tried_regions: fix expectation output and join TypeError
Date: Mon, 29 Jun 2026 07:46:45 -0700

The expectation print has wrong operator precedence: '%' binds before the
conditional expression, so the else branch prints 'not met' without the
prefix 'expectation (>= 14) is'.  Add parentheses to fix it.

Also, '\n'.join() on the list of ints raises TypeError; convert to str in
the list comprehension.

Link: https://lore.kernel.org/20260601032314.424013-3-kunwu.chan@linux.dev
Link: https://lore.kernel.org/20260629144648.134092-3-sj@kernel.org
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damos_tried_regions.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/damos_tried_regions.py~selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror
+++ a/tools/testing/selftests/damon/damos_tried_regions.py
@@ -55,10 +55,10 @@ def main():
     collected_nr_regions.sort()
     sample = collected_nr_regions[4]
     print('50-th percentile nr_regions: %d' % sample)
-    print('expectation (>= 14) is %s' % 'met' if sample >= 14 else 'not met')
+    print('expectation (>= 14) is %s' % ('met' if sample >= 14 else 'not met'))
     if collected_nr_regions[4] < 14:
         print('full nr_regions:')
-        print('\n'.join(collected_nr_regions))
+        print('\n'.join(['%d' % x for x in collected_nr_regions]))
         exit(1)
 
 if __name__ == '__main__':
_

Patches currently in -mm which might be from chentao@kylinos.cn are

selftests-damon-prevent-cross-context-state-pollution-in-damonctx.patch
selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch
selftests-damon-fix-dead-code-skipped-checks-and-broken-lookups.patch

