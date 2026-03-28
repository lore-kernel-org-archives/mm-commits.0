Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD6288A2
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 00:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774657880; cv=none; b=FHT8b59nhmKP4FbfylI9iJev0mKB7gh9KlQ/rLvvaKUhZwXn8+GEd5UH6PKiv1FKebvYTtTCDGBVdTpnqmIQKt5ofajpIV9A50EGsw6HK/qsutuximBvG0PHe1IyVOhi+bVjgih0Zqga4Gk4selQ1a1/i4Hvy/tuCFDYXSvuGH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774657880; c=relaxed/simple;
	bh=nSNQUMtT1YHcaDoI6VV8qC2y3JPVEIkhdUCVQQADums=;
	h=Date:To:From:Subject:Message-Id; b=SaSZw0x7pzFyNvRNp7cNhnbQU6JK+yafeKmXdgKUeidZXjG2JtoKc//6YHAqcSeY3YfMQbHA/APuZADTqSRDK9fmv+QFd19Ro+CUqYD2zMhVn+4fBr088ECe1VebXu/hzt2vhIu4+gsRI5bLf4U0rsmIceMl6smPHDp3xUiyMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mibqMNmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mibqMNmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68803C19423;
	Sat, 28 Mar 2026 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774657880;
	bh=nSNQUMtT1YHcaDoI6VV8qC2y3JPVEIkhdUCVQQADums=;
	h=Date:To:From:Subject:From;
	b=mibqMNmwmteqmg6fjFbZ/rSt2H/7VxCupYJTPrrxCd/VFuJJiS6zthmD6rUql8u0c
	 3wTFoIUh3JKRdGjrLZuLLKAOkK1T03ZILZj4wQhdNjBR+GoXZFBICd+3cKlcsS0+yn
	 MpSO+2vcL0/jdDO3PgRtGrB/SRGYqgM89T3ykjrs=
Date: Fri, 27 Mar 2026 17:31:19 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,leotimmins1974@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-initialize-incoming-flb-state-before-finish-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20260328003120.68803C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-initialize-incoming-flb-state-before-finish-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     liveupdate-initialize-incoming-flb-state-before-finish-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-initialize-incoming-flb-state-before-finish-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: liveupdate-initialize-incoming-flb-state-before-finish-fix
Date: Fri Mar 27 05:21:05 PM PDT 2026

remove unneeded braces, per Pasha

Cc: Leo Timmins <leotimmins1974@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_flb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/liveupdate/luo_flb.c~liveupdate-initialize-incoming-flb-state-before-finish-fix
+++ a/kernel/liveupdate/luo_flb.c
@@ -210,9 +210,8 @@ static void luo_flb_file_finish_one(stru
 		}
 	}
 
-	scoped_guard(mutex, &private->incoming.lock) {
+	scoped_guard(mutex, &private->incoming.lock)
 		count = --private->incoming.count;
-	}
 
 	if (!count) {
 		struct liveupdate_flb_op_args args = {0};
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
drivers-hv-vmbus-replace-deprecated-mmap-hook-with-mmap_prepare-fix.patch
selftests-mm-vm_util-robust-write_file-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

