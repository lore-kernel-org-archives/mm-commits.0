Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64DB226D18
	for <mm-commits@vger.kernel.org>; Sun, 12 Apr 2026 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776017602; cv=none; b=FC29Gej0mVOfWg3DKBnsf+USPv02RjZpwR40CY5Rz3Y+oqkGFeJfaSMgXJAeuxH4axDNAydl5i/Mdpj9fx+KrhpfS7wQZqoJWZ/0Anc3rW53Gxk5EDPTFbmapw2xlIwUn18gSwQ4LDxTPIzYQgkHlqIfIdkCevLmp88NGK3yGQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776017602; c=relaxed/simple;
	bh=77M8euYqynleT/eoJlkgl+OGDEwbLbIS9rbZv1NgmQ0=;
	h=Date:To:From:Subject:Message-Id; b=dwQJQA9bG1fcufJ3PFZiDSm8tb8+01j9X2/Zu+daVJT2kWW72AtnzYuwX52DVWZWhNKRC2afpziMiAdDRt/wgezeNgZS/TDnVXU57QSa8E4VY7Rj7CjlQAVPeiIvpFjodqB/zIgd7i3Z1+49Np7lsH7PRG231EixWPX7DLMpG+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Okhs+hAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Okhs+hAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E974C19424;
	Sun, 12 Apr 2026 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776017602;
	bh=77M8euYqynleT/eoJlkgl+OGDEwbLbIS9rbZv1NgmQ0=;
	h=Date:To:From:Subject:From;
	b=Okhs+hAfRgMHUwTkiQkc9bD4XZAEV6+mavquVmKtrDxVUbvpXIDD0NgLeQ66JviG2
	 lKFdDWFT6EXnftrFOg3IQ0l1rESw3lO0FstS87c7iX97gPGxzr3HBMG4YthsjVAjHD
	 nu3emZouitD77a83E1+Fbt1B5IgeAljt4ijh2j+8=
Date: Sun, 12 Apr 2026 11:13:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,david@kernel.org,create0818@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch added to mm-unstable branch
Message-Id: <20260412181321.8E974C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: skip charge_reserved_hugetlb without killall
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Cao Ruichuang <create0818@163.com>
Subject: selftests: mm: skip charge_reserved_hugetlb without killall
Date: Fri, 10 Apr 2026 12:41:39 +0800

charge_reserved_hugetlb.sh tears down background writers with killall from
psmisc.  Minimal Ubuntu images do not always provide that tool, so the
selftest fails in cleanup for an environment reason rather than for the
hugetlb behavior it is trying to cover.

Skip the test when killall is unavailable, similar to the existing root
check, so these environments report the dependency clearly instead of
failing the test.

Link: https://lkml.kernel.org/r/20260410044139.67480-1-create0818@163.com
Signed-off-by: Cao Ruichuang <create0818@163.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-skip-charge_reserved_hugetlb-without-killall
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -11,6 +11,11 @@ if [[ $(id -u) -ne 0 ]]; then
   exit $ksft_skip
 fi
 
+if ! command -v killall >/dev/null 2>&1; then
+  echo "killall not available. Skipping..."
+  exit $ksft_skip
+fi
+
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 
 fault_limit_file=limit_in_bytes
_

Patches currently in -mm which might be from create0818@163.com are

selftests-mm-skip-charge_reserved_hugetlb-without-killall.patch

