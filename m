Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A277E1607A4
	for <mm-commits@vger.kernel.org>; Fri, 21 Jun 2024 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718993386; cv=none; b=kKGKUT6t+mn+FjVD27iHbtjAjNdyh3cGyAojFlRxTJkpaQ2Yn6wlnRmon+B1AnHxEu8T0Wq0T5x5PTuEV0vdEzPhtB3mQJExPs/WlMehupN+k9Vp4O0jxfffdJ6Nc5z4DMpEEtstAHewJaLFPF2O2Ew0SLx/ThGFh6DBabkQU7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718993386; c=relaxed/simple;
	bh=jJdNo7xQnNdKYhBYFnlgICiqxF/tYKibDT8iM63gFqk=;
	h=Date:To:From:Subject:Message-Id; b=PzcXEqQo1bWWirTm/DoETL7TfmWee4C+wH8IS1hFNVuBYA+eHQzmI8Y2N1unCPlLVuXwn6lQaP0uyiEAtlNos3S7pZtiFHZIQwf/DRgK1jM44mwTx697vclAkCtXvy77GqgpqJyqnHFolVdv8h3e5mzCUYYKRNqER7jzEZG2QvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0csBMOVy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0csBMOVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB49C2BBFC;
	Fri, 21 Jun 2024 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718993385;
	bh=jJdNo7xQnNdKYhBYFnlgICiqxF/tYKibDT8iM63gFqk=;
	h=Date:To:From:Subject:From;
	b=0csBMOVyDS01t3ETwH0EfX3CSZR45SyKf3buHVDp48ddY8yl7WOMhlojsNnHV9dPY
	 35vqx7Ri+j/k6djOyFXRdePI7qJ8hiWPdhJVyUaQvqWYmw4GyxFUhcNYgFszVesNAb
	 2vWB9uxgXScG5GCXI2L44zgrbjx2TFbvMQ+Kcq8o=
Date: Fri, 21 Jun 2024 11:09:44 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,hannes@cmpxchg.org,anna-maria@linutronix.de,shivamurthy.shastri@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch added to mm-unstable branch
Message-Id: <20240621180945.3EB49C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: fix -Wenum-enum-conversion warning in vmstat.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch

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
From: Shivamurthy Shastri <shivamurthy.shastri@linutronix.de>
Subject: mm/vmstat: fix -Wenum-enum-conversion warning in vmstat.h
Date: Fri, 21 Jun 2024 13:16:04 +0200

A W=1 build with -Wenum-enum-conversion enabled, results in the following
build warning due to an arithmetic operation between different enumeration
types 'enum node_stat_item' and 'enum lru_list':

  include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
    514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
        |                               ~~~~~~~~~~~ ^ ~~~

Address this by casting lru to the proper type.

Link: https://lkml.kernel.org/r/20240621111604.25330-1-shivamurthy.shastri@linutronix.de
Signed-off-by: Shivamurthy Shastri <shivamurthy.shastri@linutronix.de>
Reviewed-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath
+++ a/include/linux/vmstat.h
@@ -495,7 +495,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
_

Patches currently in -mm which might be from shivamurthy.shastri@linutronix.de are

mm-vmstat-fix-wenum-enum-conversion-warning-in-vmstath.patch

