Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150EA1C36
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718846343; cv=none; b=I2IbADzTpk/RNlzEDqzW5xwdriJESLtlPhQCybkf/k08JACWsDQO02fCcgC6s59KowEjapnBErQfyBeq0qyNF2nr34BQElWJxwAEzhHe6/sAqjCGuZVtG7j5Z8Dh0yyV4mAVgH6w4FUyCF717QRThDyh0WLkuMaxAuv9hU0fkr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718846343; c=relaxed/simple;
	bh=IG2JLHDd1MKjrcaUxUv4nMVtGmqv2gjLk4bDyowlhpI=;
	h=Date:To:From:Subject:Message-Id; b=ZIZ08Cya55cPbmiL233YmQWwRdE8nx9n8eKxw04DpMHkRQgEpxnR5RxYcHBB/YU+O/vfDAqAiHRDlVavVkqwzWLJTOdnzL4hDR2g+wkP0HVp6gifv1CEy1hDwcRLylONhIZ0wQ+5GhxdT3MGpJldjkR3pA8Dw5cYLzGGmFUkFTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rRGgvhYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rRGgvhYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76804C32786;
	Thu, 20 Jun 2024 01:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718846342;
	bh=IG2JLHDd1MKjrcaUxUv4nMVtGmqv2gjLk4bDyowlhpI=;
	h=Date:To:From:Subject:From;
	b=rRGgvhYjrnn27x/mzP8mFy1L4faNpY1eZK6tiHJa/Sb8VTWCu0ii6A2woV1aH0Oi8
	 8fyEU+yW++fiEn/fzkjEfu7PekI7ePksXHj1tAz+2SmVPqV9fPbz6GaX0u5ttqN6nU
	 ylJci9yKkCa2N3BSPSZjVD6OJOYxpnm8vpdMeUpk=
Date: Wed, 19 Jun 2024 18:19:01 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,ioworker0@gmail.com,jiaqiyan@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-refactor-log-format-in-unpoison_memory.patch added to mm-unstable branch
Message-Id: <20240620011902.76804C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: refactor log format in unpoison_memory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-refactor-log-format-in-unpoison_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-refactor-log-format-in-unpoison_memory.patch

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
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: mm/memory-failure: refactor log format in unpoison_memory
Date: Wed, 19 Jun 2024 06:33:55 +0000

Logs from memory_failure and other memory-failure.c code follow the
format:

  "Memory failure: 0x{pfn}: ${lower_case_message}"

Convert the logs in unpoison_memory to follow similar format:

  "Unpoison: 0x${pfn}: ${lower_case_message}"

For example (from local test):
  [ 1331.938397] Unpoison: 0x144bc8: page was already unpoisoned

No functional change in this commit.

Link: https://lkml.kernel.org/r/20240619063355.171313-1-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-refactor-log-format-in-unpoison_memory
+++ a/mm/memory-failure.c
@@ -2526,7 +2526,7 @@ static int __init memory_failure_init(vo
 core_initcall(memory_failure_init);
 
 #undef pr_fmt
-#define pr_fmt(fmt)	fmt
+#define pr_fmt(fmt)	"Unpoison: " fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
@@ -2564,27 +2564,27 @@ int unpoison_memory(unsigned long pfn)
 	mutex_lock(&mf_mutex);
 
 	if (hw_memory_failure) {
-		unpoison_pr_info("Unpoison: Disabled after HW memory failure %#lx\n",
+		unpoison_pr_info("%#lx: disabled after HW memory failure\n",
 				 pfn, &unpoison_rs);
 		ret = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	if (is_huge_zero_folio(folio)) {
-		unpoison_pr_info("Unpoison: huge zero page is not supported %#lx\n",
+		unpoison_pr_info("%#lx: huge zero page is not supported\n",
 				 pfn, &unpoison_rs);
 		ret = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	if (!PageHWPoison(p)) {
-		unpoison_pr_info("Unpoison: Page was already unpoisoned %#lx\n",
+		unpoison_pr_info("%#lx: page was already unpoisoned\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
 	if (folio_ref_count(folio) > 1) {
-		unpoison_pr_info("Unpoison: Someone grabs the hwpoison page %#lx\n",
+		unpoison_pr_info("%#lx: someone grabs the hwpoison page\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
@@ -2594,13 +2594,13 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 
 	if (folio_mapped(folio)) {
-		unpoison_pr_info("Unpoison: Someone maps the hwpoison page %#lx\n",
+		unpoison_pr_info("%#lx: someone maps the hwpoison page\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
 
 	if (folio_mapping(folio)) {
-		unpoison_pr_info("Unpoison: the hwpoison page has non-NULL mapping %#lx\n",
+		unpoison_pr_info("%#lx: the hwpoison page has non-NULL mapping\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
@@ -2619,7 +2619,7 @@ int unpoison_memory(unsigned long pfn)
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
 		} else {
 			ret = ghp;
-			unpoison_pr_info("Unpoison: failed to grab page %#lx\n",
+			unpoison_pr_info("%#lx: failed to grab page\n",
 					 pfn, &unpoison_rs);
 		}
 	} else {
@@ -2644,7 +2644,7 @@ unlock_mutex:
 	if (!ret) {
 		if (!huge)
 			num_poisoned_pages_sub(pfn, 1);
-		unpoison_pr_info("Unpoison: Software-unpoisoned page %#lx\n",
+		unpoison_pr_info("%#lx: software-unpoisoned page\n",
 				 page_to_pfn(p), &unpoison_rs);
 	}
 	return ret;
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-memory-failure-userspace-controls-soft-offlining-pages.patch
selftest-mm-test-enable_soft_offline-behaviors.patch
docs-mm-add-enable_soft_offline-sysctl.patch
mm-memory-failure-refactor-log-format-in-unpoison_memory.patch

