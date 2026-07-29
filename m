Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9E0221FD4
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298535; cv=none; b=HPQUPvKtZdfkVPOKkcf2vRs4kkKiIPq+DpaKZMa8/aKV3IzdiAgfXafduG5xqOytwEYhHiFB8vasZ7Fs2juxj4l14YRvZ8fHIpLNXwgrEhPTa26v+HxnidzqYsb/wc83R31p7EEKO2OsY3LlutZRGKmnDnsqFrNsy2wMD2DZsrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298535; c=relaxed/simple;
	bh=v2624h+KGGFEiEEVUmIeuYb+MrPRcAezIb4RuLUfgJ4=;
	h=Date:To:From:Subject:Message-Id; b=tRxdXfCHH8+N+3OEBDRihBjMSr97yoRJxi5UZdodkH+RPrXsJq9DgIbAFCHZRMnHruDJMvr2L65ZbrCCuNE6h4e/bZRHMBEBXrAp+tRTN+uPN6467jc9QUhcOEBP+kWpacOx2L+3WjSverM0HWKXRwTAH/BrovlL65gnDEtiQjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/aIWBFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/aIWBFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C2B1F00A3D;
	Wed, 29 Jul 2026 04:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298533;
	bh=PV2fD+YD/TJiu7urgnGS6x3wRJRhoVY9RWBpxqUsqIQ=;
	h=Date:To:From:Subject;
	b=h/aIWBFj9VrowWbkYI2/7sAMHyplJ4Z2p7zhshJgunayWL4nJORrVMjNktPcUz0dd
	 r8+Mw2d7fblMA8DTRdptj4Wo+l8PAEdHyl/2WOi2BbQw6wy/6t5FkqxeiabWzrzWJM
	 OV9bh0Xgcs94lC6nri6lIQUFy5kj09Cem/rrjo04=
Date: Tue, 28 Jul 2026 21:15:33 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lianux.mm@gmail.com,chentao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch removed from -mm tree
Message-Id: <20260729041533.83C2B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damos_tried_regions: fix expectation output and join TypeError
has been removed from the -mm tree.  Its filename was
     selftests-damon-damos_tried_regions-fix-expectation-output-and-join-typeerror.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


