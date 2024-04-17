Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EFE171A1
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385386; cv=none; b=rJcCamnBFrglmrKaGZ77AjEI5JF0xb/MTlpCyYsmzZ/oSWpzVdxE9DN0r46NwC8Lw0eioB+16C5DRF2r86kl2prh1c64tHtYLDSAKpxiUNae3n6bcM1PfJ35jyEF0BPpY1ei7TYhOAxkJNRdzteBH8llWjjxVQSIVrd+Y8bsTkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385386; c=relaxed/simple;
	bh=te2ACbPEEMNjSd3nm9F9Eh8iODgQTdjpIZ5iocua9qs=;
	h=Date:To:From:Subject:Message-Id; b=f95s8kQ2o/YEPp0eygykgvdbyPIRt3SLJujHRVqxy24T6CxKDjOKubM/I7w4gOYP6zfQUKJiOaRR1i0uuN+Mq4matuifDBKowTd0x7wVNNkfHPtS/RoTGyaT07PnINhdl8AACXXjNdAE8ssEdbr9lexw77YELBfLJme9iAP6wXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYsy7o2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYsy7o2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06839C072AA;
	Wed, 17 Apr 2024 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713385386;
	bh=te2ACbPEEMNjSd3nm9F9Eh8iODgQTdjpIZ5iocua9qs=;
	h=Date:To:From:Subject:From;
	b=oYsy7o2hqwmvtkYSHfcXTu4RT3yxP8z/pFBsVNBx9UdehiRpD8fcCNkv4K3+tRpTn
	 orA8W0BV6wLgloW5BPTzVZh7BiNJdHEW4pXYwb6/M0VQ+2vSQNPi9fdBkju2wFizYs
	 V7Jp8oWaMqfSwQPExVHnb+HTIkFQTZegXKIryrIg=
Date: Wed, 17 Apr 2024 13:23:05 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,linux@rasmusvillemoes.dk,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cpumask-delete-unused-reset_cpu_possible_mask.patch added to mm-nonmm-unstable branch
Message-Id: <20240417202306.06839C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cpumask: delete unused reset_cpu_possible_mask()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     cpumask-delete-unused-reset_cpu_possible_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cpumask-delete-unused-reset_cpu_possible_mask.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: cpumask: delete unused reset_cpu_possible_mask()
Date: Wed, 17 Apr 2024 23:11:23 +0300

Link: https://lkml.kernel.org/r/20240417201123.2961-1-adobriyan@gmail.com
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/include/linux/cpumask.h~cpumask-delete-unused-reset_cpu_possible_mask
+++ a/include/linux/cpumask.h
@@ -1017,11 +1017,6 @@ void init_cpu_present(const struct cpuma
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
 
-static inline void reset_cpu_possible_mask(void)
-{
-	bitmap_zero(cpumask_bits(&__cpu_possible_mask), NR_CPUS);
-}
-
 static inline void
 set_cpu_possible(unsigned int cpu, bool possible)
 {
_

Patches currently in -mm which might be from adobriyan@gmail.com are

cpumask-delete-unused-reset_cpu_possible_mask.patch

