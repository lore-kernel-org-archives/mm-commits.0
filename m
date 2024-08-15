Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916781AC897
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 23:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723764661; cv=none; b=Lb38/UBYPGO533ETJYVA16ArbRsCZ79uWrxgDoZg9Cy4HXP/ezxt5+YgRqUPG5Lsp639IvK3FICxAJ1tOJ7KlNrdvA1xvNOUakZgerK4wzi+162+pW31WREKtPurL80ytrZrH0IrZpWCQcj9F2i3QREVm8Ax90qME8p1wOpS8Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723764661; c=relaxed/simple;
	bh=PW/ESyJspoxdBtoy12x4UMnSj5V6GztRMV99WIHuDJU=;
	h=Date:To:From:Subject:Message-Id; b=VtBOnSpoyewTxYocI+Y0AaR002istZUtevrSDMApm0Ev3TMM4g32Uu0LAlEbE9DjQT5T2zI6ZGt9OZXsFOT13a0CTOhY0MMogHeTnEmeumoOLm7unGKxnEnfkapk5rT6Iq8dPABsGL7aSGg9woaRdjWsijNrLQD9ksQycRsFgcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K9xaFB7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K9xaFB7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B476C32786;
	Thu, 15 Aug 2024 23:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723764661;
	bh=PW/ESyJspoxdBtoy12x4UMnSj5V6GztRMV99WIHuDJU=;
	h=Date:To:From:Subject:From;
	b=K9xaFB7oz+uWRhjQx0WTGNALGdwrCuyY/J/9RfSt3vWOuzyMuOVMTF9O7aRgUjbNL
	 +16FgbLv3Dk/4NipMBclJjnrJxx2552BbCXeBdtZt56CBJO87QQTRPPV6XYPnSbuki
	 jn6l//A/+/484ULW2ensMfqmHmhonMNUpm7xjouI=
Date: Thu, 15 Aug 2024 16:31:00 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch added to mm-unstable branch
Message-Id: <20240815233101.0B476C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use get_oder() and check size is is_power_of_2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: use get_oder() and check size is is_power_of_2
Date: Thu, 15 Aug 2024 10:34:16 +1200

Using get_order() is more robust according to Baolin.  It is also better
to filter illegal size such as 3KB, 16KB according to David.

Link: https://lkml.kernel.org/r/20240814224635.43272-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix
+++ a/mm/huge_memory.c
@@ -952,14 +952,17 @@ static inline int get_order_from_str(con
 	int order;
 
 	size = memparse(size_str, &endptr);
-	order = fls(size >> PAGE_SHIFT) - 1;
-	if ((1 << order) & ~THP_ORDERS_ALL_ANON) {
-		pr_err("invalid size %s(order %d) in thp_anon boot parameter\n",
-			size_str, order);
-		return -EINVAL;
-	}
+
+	if (!is_power_of_2(size >> PAGE_SHIFT))
+		goto err;
+	order = get_order(size);
+	if ((1 << order) & ~THP_ORDERS_ALL_ANON)
+		goto err;
 
 	return order;
+err:
+	pr_err("invalid size %s in thp_anon boot parameter\n", size_str);
+	return -EINVAL;
 }
 
 static char str_dup[PAGE_SIZE] __meminitdata;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-extend-usage-parameter-so-that-cluster_swap_free_nr-can-be-reused.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios.patch
mm-swap-add-nr-argument-in-swapcache_prepare-and-swapcache_clear-to-support-large-folios-fix.patch
vpda-try-to-fix-the-potential-crash-due-to-misusing-__gfp_nofail.patch
mm-document-__gfp_nofail-must-be-blockable.patch
mm-bug_on-to-avoid-null-deference-while-__gfp_nofail-fails.patch
mm-prohibit-null-deference-exposed-for-unsupported-non-blockable-__gfp_nofail.patch
mm-add-nr-argument-in-mem_cgroup_swapin_uncharge_swap-helper-to-support-large-folios.patch
mm-rename-instances-of-swap_info_struct-to-meaningful-si.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range.patch
mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix.patch
mm-override-mthp-enabled-defaults-at-kernel-cmdline-fix.patch

