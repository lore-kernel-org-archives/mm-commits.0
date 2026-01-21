Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7548141C72
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966111; cv=none; b=X8vHOze6sU0IVzq9IS4VZJ6erlBxuvYO9THuwlLL61l1puS8ZC0GP2pvKm+7Eu45PIRdjX9q1fOfbvfqyOtPDxsQj/xoLE26HLjNX4JQ+2E8PpxzGLUHM0itQXxRByx9ApmAjsBBumS6vAUygNSdhfoMETuY10GuWR5lypb62nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966111; c=relaxed/simple;
	bh=VA1cDzfQsZ5Nnc2RvcQW5L6mEW2s/bYQdSzM57rq+iU=;
	h=Date:To:From:Subject:Message-Id; b=DWV8s0YMQ0hCEQzw4vi69I+6mwMcN7yk9ASve4iNTgKV+2rufV3ID2Tm4+X/0uhfuaiW1Yd0YpVDL+wLhSGp1+96dLqNUGp4nbPIDljkKvGvy8+9WzgpFXgGsmgmh+luzLsWBBTrBGZ5eKEMLE5Zo+9kQ/vzGX2HYS/HSIrlIhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NbftOEbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NbftOEbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4ABC16AAE;
	Wed, 21 Jan 2026 03:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966111;
	bh=VA1cDzfQsZ5Nnc2RvcQW5L6mEW2s/bYQdSzM57rq+iU=;
	h=Date:To:From:Subject:From;
	b=NbftOEbjd+qyow7Go7jMDxvc4N0X7LQEcSDRPWpzN3ZmxXnXOuG2L4Il45FHG+3nU
	 lBGnAPpshLQcgRr7s1Sf4NGF+mVpjjYEwskwdHF6sGhsl+3n5nWJqDh0HVbeCxjeo6
	 6ks4zl72XDg2FIEghcHiMR8nXUvT3l21IVh+GjoE=
Date: Tue, 20 Jan 2026 19:28:30 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-va_high_addr_switchsh-return-value.patch removed from -mm tree
Message-Id: <20260121032831.4C4ABC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix va_high_addr_switch.sh return value
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-va_high_addr_switchsh-return-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


