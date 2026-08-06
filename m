Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D15302146
	for <mm-commits@vger.kernel.org>; Thu,  6 Aug 2026 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786057777; cv=none; b=gsQNGmUblQfeq2CIa5keLBHeCG3ffo3BfP1jtnXOW3txoFdsYQvWmie1rx6rx1pJjdldl9gYy4oeWqOE5iSH4U3roHCQn1DmtEWNPmjP12l1JwpCsAanY3Rp3L6OuLRywEA3xdfa5576cOvRFynRjFkF0DLIX3u3FgDczAaFsL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786057777; c=relaxed/simple;
	bh=27xFqdTUkv4q3AlsGuLuzJvhtLYLTqTEU7J8AdzE5G0=;
	h=Date:To:From:Subject:Message-Id; b=p8eLHtIYr/btZFIddnlqXYaF+oTJ9f4HD/yEMoqoyWG6ZKcjUbIIXilyTx3kgYpALe5zyX4U1JXgladoqA1TygjilUa3z8NS3wZlbBYSlV8IeEr+3YdrZpgHIZDwmmHBEyCpikT58eZhNYO1Hw5qqVEUf3ruA9icsOrt2iItgN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlcwvuFe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlcwvuFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D505F1F000E9;
	Thu,  6 Aug 2026 23:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786057775;
	bh=BfLF00YYXMO+uNuE4MJSzctQ0t/ykV24CFOn50xha48=;
	h=Date:To:From:Subject;
	b=PlcwvuFe7jXushlFZ2IbRu6guyXhjwG3h8bIf7QFA7qBsv0hN8Ui/QThc2sl+u0AZ
	 diJP1EvJnCPoQSsUMV3wnnUD0bqpRf553f+ZgsOUFsYIA7CaCfk71KDd9FZVbzNQfd
	 VB15ot4w2aTV1vwMru/tuHuKEg/s+AIu7vIs13qg=
Date: Thu, 06 Aug 2026 16:09:35 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,pratmal@google.com,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jhubbard@nvidia.com,jgg@ziepe.ca,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-use-pattern-matching-in-gitignore-fix.patch added to mm-unstable branch
Message-Id: <20260806230935.D505F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-mm-use-pattern-matching-in-gitignore-fix
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-use-pattern-matching-in-gitignore-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-use-pattern-matching-in-gitignore-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests-mm-use-pattern-matching-in-gitignore-fix
Date: Thu Aug  6 04:08:41 PM PDT 2026

fix botched merge resolution

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Pratyush Mallick <pratmal@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-use-pattern-matching-in-gitignore-fix
+++ a/tools/testing/selftests/mm/.gitignore
@@ -2,3 +2,9 @@
 *
 !/**/
 !*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
selftests-mm-use-pattern-matching-in-gitignore-fix.patch
selftests-mm-fix-soft-dirty-kselftest-supported-check-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

