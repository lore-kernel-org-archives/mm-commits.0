Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F32423A11D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836970; cv=none; b=YqYoGF0kCTxo3NyisPwBsQ46Yrob1PlqSCxl/Ljuy3K7/wjZwnugLUCZp6klGtBt9oSYj0/x6aPVJmdjTLu8BgOFnUvfqFBV1CK2Fu9WCWr23Jgmh982PHbWitBOaTba6EpvJjffkN2tOc1bqBaIXTr/bsFcMn7w5z9+Y2J0/fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836970; c=relaxed/simple;
	bh=QepdCh43wOpeju0qV1lxIUof+dyOhaNiW/Ri7n82fw4=;
	h=Date:To:From:Subject:Message-Id; b=uRpTCGVAWHZhzxuFbrhJcOI8kLxe5ohi3T5FA7evy2WWI9naeo77EbjBf/nTbK8ARNYDt6OVvsEbncXYki3bDHAlCd2i10gTNdumisoqTnIviC5SJVO+1+OwGCHPdeokaokn7tE2xm6vM4G7hXEgyAUL3+97cQZCkKXxjaDI24U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdE8Lody; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdE8Lody"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCB4C4CEDD;
	Tue, 14 Jan 2025 06:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836969;
	bh=QepdCh43wOpeju0qV1lxIUof+dyOhaNiW/Ri7n82fw4=;
	h=Date:To:From:Subject:From;
	b=fdE8Lodyjdi2uvjkiRufuQ5tctDZIcrxMJhRFsMPZbUnn/aFwjzVUMxZ9CZ38hjlp
	 6pUPtOQqPyDquHzgEvz12f/MvOEMArqBNW8/DLg0H9pVFP7qaGwTlGQDbWP7s6P1i9
	 rfNeDB8XLWjXLGUVk8f1zND1ynSAUdRq+0nYvMzc=
Date: Mon, 13 Jan 2025 22:42:49 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,ryabinin.a.a@gmail.com,lkp@intel.com,dvyukov@google.com,andreyknvl@gmail.com,niharchaithanya@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kasan-fix-sparse-warnings-should-it-be-static.patch removed from -mm tree
Message-Id: <20250114064249.CFCB4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm:kasan: fix sparse warnings: Should it be static?
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-sparse-warnings-should-it-be-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nihar Chaithanya <niharchaithanya@gmail.com>
Subject: mm:kasan: fix sparse warnings: Should it be static?
Date: Fri, 11 Oct 2024 17:15:38 +0530

Yes, when making the global variables kasan_ptr_result and
kasan_int_result as static volatile, the warnings are removed and the
variable and assignments are retained, but when just static is used I
understand that it might be optimized.

Add a fix making the global varaibles - static volatile, removing the
warnings:
mm/kasan/kasan_test.c:36:6: warning: symbol 'kasan_ptr_result' was not declared. Should it be static?
mm/kasan/kasan_test.c:37:5: warning: symbol 'kasan_int_result' was not declared. Should it be static?

Link: https://lkml.kernel.org/r/20241011114537.35664-1-niharchaithanya@gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312261010.o0lRiI9b-lkp@intel.com/
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kasan/kasan_test_c.c~mm-kasan-fix-sparse-warnings-should-it-be-static
+++ a/mm/kasan/kasan_test_c.c
@@ -47,8 +47,8 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-void *kasan_ptr_result;
-int kasan_int_result;
+static volatile void *kasan_ptr_result;
+static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */
 static void probe_console(void *ignore, const char *buf, size_t len)
_

Patches currently in -mm which might be from niharchaithanya@gmail.com are


