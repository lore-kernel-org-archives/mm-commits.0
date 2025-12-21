Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741312FFDEC
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766343465; cv=none; b=GQW+GDNP0ShyeUPyYLUXqEPfGvGH+EWBquCQjR+biV/MRSfza5PrfECLKfq/Z2lC2FCea4ACEsjbZqmVU5x9l2GfkCj/vFi1W2RbDWTENJcDnhj0k7dzkx3A5WdbPOhLPXNoEbFcc43uu1KFkQf8EKfpEHcLS8ptilNVtM8P26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766343465; c=relaxed/simple;
	bh=0Cy7rsXI/7z7BYbsLNTyBySDEmkPTW3QgIGuwpr4Nfk=;
	h=Date:To:From:Subject:Message-Id; b=T/HxSZsD9RIhp/ZfEF40uEUTpSPKkIgomwKoZ0nV7lXW9dflcFyyzAFFcZ7CFpUhibnbXRtXZq3ndCQrOPWjfmwWG9x+VbDZYBd5hvcakMIZnQ9bDr7pL/nFEu3eiTIbV9ffIkuAnZdhNuEJ+1al0pLMyr3s13fw6rr6+inszaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0/AIAOA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0/AIAOA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EB4C4CEFB;
	Sun, 21 Dec 2025 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766343465;
	bh=0Cy7rsXI/7z7BYbsLNTyBySDEmkPTW3QgIGuwpr4Nfk=;
	h=Date:To:From:Subject:From;
	b=0/AIAOA9Sq8Zxko5YT/2PSPh/RMJIwFH6FBuViJwzY4Ow5aik/qwJBBxvogiE88ys
	 di8UcfaYj+w79KlnrnDki80XupnFJm96l7aUM48tZl3dRI3auiDhBGohrnZ/WMfTdf
	 JLaGTfq1LWuSObqiwVrdK+GuaJ13Q8RvrHTSHDoU=
Date: Sun, 21 Dec 2025 10:57:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-va_high_addr_switchsh-return-value.patch added to mm-new branch
Message-Id: <20251221185745.05EB4C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix va_high_addr_switch.sh return value
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-va_high_addr_switchsh-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-va_high_addr_switchsh-return-value.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: fix va_high_addr_switch.sh return value
Date: Sun, 21 Dec 2025 12:00:21 +0800

Patch series "Fix va_high_addr_switch.sh test failure - again", v2.

The series address several issues exist for the va_high_addr_switch test:
1) the test return value is ignored in va_high_addr_switch.sh.
2) the va_high_addr_switch test requires 6 hugepages not 5.
3) the reurn value of the first test in va_high_addr_switch.c can be
   overridden by the second test.
4) the nr_hugepages setup in run_vmtests.sh for arm64 can be done in
   va_high_addr_switch.sh too.
5) update a comment for check_test_requirements.


This patch: (of 5)

The return value should be return value of va_high_addr_switch, otherwise
a test failure would be silently ignored.

Link: https://lkml.kernel.org/r/20251221040025.3159990-1-chuhu@redhat.com
Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-fix-va_high_addr_switchsh-return-value
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -114,4 +114,6 @@ save_nr_hugepages
 # 4 keep_mapped pages, and one for tmp usage
 setup_nr_hugepages 5
 ./va_high_addr_switch --run-hugetlb
+retcode=$?
 restore_nr_hugepages
+exit $retcode
_

Patches currently in -mm which might be from chuhu@redhat.com are

selftests-mm-fix-va_high_addr_switchsh-return-value.patch
selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch
selftests-mm-remove-arm64-nr_hugepages-setup-for-va_high_addr_switch-test.patch
selftests-mm-va_high_addr_switch-return-fail-when-either-test-failed.patch
selftests-mm-fix-comment-for-check_test_requirements.patch

