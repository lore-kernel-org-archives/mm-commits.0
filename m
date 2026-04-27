Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7066315D43;
	Mon, 27 Apr 2026 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777309029; cv=none; b=a1e8+2cX/3CTUpAdwliYUssPTVaHEanjgEQMqBZBYN+3uL5dyX3YIbBq5Uq/aXDJdKOJGTTPdFDCJsxFfj3o/glwSoyeGDLrNt7DzEWujlKV2eUHytv/A38VRoUWvl28nhTqQ23EhqK+Epgnk5YHEUT19EuEzezu8m7aV3FuqF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777309029; c=relaxed/simple;
	bh=YdMUiCz23/6/lQS7mbEjjU5lVhGEnVd0qqRQbk38lBo=;
	h=Date:To:From:Subject:Message-Id; b=Ym7xvxr20ksuiJl76GVSqb+0pPxmMEd/XkJsPDqdbwRCs9IzSBj1zyzZgzr47Krs4DUOFUvOskxXWSbw5KWoXU2R4A9nB1UyRBrlLayD6A/ZXdCNQk3d5MDgG5bc+04/M18OK5nodwgMOIpMG3io5KvR+0oVdqE3T0DUhPrB3IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W+Plb62i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W+Plb62i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A20FC19425;
	Mon, 27 Apr 2026 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777309029;
	bh=YdMUiCz23/6/lQS7mbEjjU5lVhGEnVd0qqRQbk38lBo=;
	h=Date:To:From:Subject:From;
	b=W+Plb62igFWTVuBRkRc7BvybqZOWLlxKFCYeLy5CocCvHcLNNqFJmgbTey4qoLuhd
	 ZlTdzG/XSJg7fiZV3u7dp+F/FWkFzD4mZ5piHNZFskEVGm7ItmuNuEztOXRMiaIWj+
	 1lhANiQ8v8DA+/1e04RcdC0p34iTMmqcIp+rvWkA=
Date: Mon, 27 Apr 2026 09:57:08 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch added to mm-hotfixes-unstable branch
Message-Id: <20260427165709.5A20FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: fix destructive tests invocation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Mon, 27 Apr 2026 12:03:51 -0400

Destructive tests should be invocated with -d command-line option, but
this won't work today since 'd' is missing in getopts command-line.  This
commit fixes it.

Link: https://lore.kernel.org/214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com
Fixes: f16ff3b692ad ("selftests/mm: run_vmtests.sh: add missing tests")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-destructive-tests-invocation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -103,7 +103,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;
_

Patches currently in -mm which might be from luizcap@redhat.com are

selftests-mm-run_vmtestssh-fix-destructive-tests-invocation.patch

