Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24834611E
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768091867; cv=none; b=GR076kwisIzjYwSRvAyInU2JmnagKeJlHMSFS9ynNWQOGhNSzxy26M4ML8f3wcazmcX+xwXV24OPNlp1xhTzmKcR8e3fFBD43pIhwfvowozY/0fr+Ut6NNbddMmVYqfyNSfYmPUtIw19BQ92x+hZSEEhITgYhbOM1aR0rFm8iE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768091867; c=relaxed/simple;
	bh=eAjdvLxI4vffpRtwws/Sn2e8pkkHjB3ATDBtojXKNPE=;
	h=Date:To:From:Subject:Message-Id; b=MsdrUpbMqrzPR1arc8annejpwfrcW3OV7YCxdglf1aQgh0xaPomNXrHaMWYL67W6TNxWtb55wGKegCheUoWhD/cpf6vzzctR6LEHuD/RJeNU7l+8tiCOe5NFJOoEmkLGJZ0dDXp621xbxXGiwu7OQsvwImTHvvaR4CsOFU1GCrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BgocuUf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BgocuUf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC23C4CEF1;
	Sun, 11 Jan 2026 00:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768091866;
	bh=eAjdvLxI4vffpRtwws/Sn2e8pkkHjB3ATDBtojXKNPE=;
	h=Date:To:From:Subject:From;
	b=BgocuUf/TFCWpIvKkHFMstoBp3/8xhPAKMLf9sy9We1eQNogejn+pTXFOY57sDYQD
	 lTAjI+SXGXGtY3u0ChdvhB909JN7+14Pqgl7Xu1pOVXee1cAfFOmO3jiS4SpkzCoUT
	 Wn1i3/DPF7mdnzf5AIBTVLJu5iVWLnWUSiMw/twU=
Date: Sat, 10 Jan 2026 16:37:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@kernel.org,akpm@linux-foundation.org,sun.jian.kdev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ksm_tests-skip-when-not-run-as-root.patch added to mm-new branch
Message-Id: <20260111003746.9FC23C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: ksm_tests: skip when not run as root
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-ksm_tests-skip-when-not-run-as-root.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ksm_tests-skip-when-not-run-as-root.patch

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
From: Sun Jian <sun.jian.kdev@gmail.com>
Subject: selftests/mm: ksm_tests: skip when not run as root
Date: Fri, 9 Jan 2026 17:43:13 +0800

ksm_tests writes KSM sysfs knobs under /sys/kernel/mm/ksm, which requires
root privileges.  When run unprivileged, it fails with permission errors
and reports FAIL, which is misleading.

Skip the test early when not run as root to avoid false failures.

Link: https://lkml.kernel.org/r/20260109094313.52307-1-sun.jian.kdev@gmail.com
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/ksm_tests.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/ksm_tests.c~selftests-mm-ksm_tests-skip-when-not-run-as-root
+++ a/tools/testing/selftests/mm/ksm_tests.c
@@ -766,6 +766,11 @@ int main(int argc, char *argv[])
 	bool merge_across_nodes = KSM_MERGE_ACROSS_NODES_DEFAULT;
 	long size_MB = 0;
 
+	if (geteuid() != 0) {
+		printf("# SKIP ksm_tests requires root privileges\n");
+		return KSFT_SKIP;
+	}
+
 	while ((opt = getopt(argc, argv, "dha:p:l:z:m:s:t:MUZNPCHD")) != -1) {
 		switch (opt) {
 		case 'a':
_

Patches currently in -mm which might be from sun.jian.kdev@gmail.com are

selftests-mm-ksm_tests-skip-when-not-run-as-root.patch

