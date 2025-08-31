Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F23D22F76F
	for <mm-commits@vger.kernel.org>; Sun, 31 Aug 2025 20:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756670698; cv=none; b=fKvp4oV6eQXUSiN9lm+uaL0VX8ZMcPtLD/H9a6O5Tl+tsVuxh1An9/qJo0YjvCSCgsbOPnmniXJeON9rrRQd2YqPzIOLCbGQJ6QhjueD/PUDt9jL2y8lUwu9f2enIJOOLPj99HdpBgg8vGMQI4mykfVGXMNB6a+K2+YrJTkPbIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756670698; c=relaxed/simple;
	bh=q2K6kX/xR2MEl7zjfEn4LcIOuYPA6zX7EvAEftTyWYI=;
	h=Date:To:From:Subject:Message-Id; b=ePKxA4bAWCLltDBVRaze3s2fEKgsFdxEBiHyJxlrQKHdu7giYpAtbbVUL+31zL8hfNl9mZaCfiGvcAY8G1EmcgSCtiyuezSPCbkTMDKfG78tyhN4d1to4gpodJ75BgN26Jrn0a+unVff7m6S0rbTkCBgat1QfS2D6ZGDHQr9CW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iRLE5d3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iRLE5d3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9909EC4CEED;
	Sun, 31 Aug 2025 20:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756670697;
	bh=q2K6kX/xR2MEl7zjfEn4LcIOuYPA6zX7EvAEftTyWYI=;
	h=Date:To:From:Subject:From;
	b=iRLE5d3Aul8rG2kW2AXn17Vu1Jn667cP3+rGgeJ2h+YX3yVIdzEzEeQBbYikLdv5S
	 +JQoKKac+pQW9wJDUwP64uG1mP+yRQYJRW0nph4Tj5k1O3CZGp2zMVrMjql/C7hcZS
	 XSht3uBYLsUuBrzzalu99KSq1/EWQrWBTnD8/t4I=
Date: Sun, 31 Aug 2025 13:04:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,pabeni@redhat.com,ming.lei@redhat.com,mic@digikod.net,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kuba@kernel.org,horms@kernel.org,gnoack@google.com,edumazet@google.com,david@redhat.com,davem@davemloft.net,reddybalavignesh9979@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch added to mm-nonmm-unstable branch
Message-Id: <20250831200457.9909EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: centralize include path for kselftest.h and kselftest_harness.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch

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
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Subject: selftests: centralize include path for kselftest.h and kselftest_harness.h
Date: Sat, 30 Aug 2025 22:09:48 +0530

Add compile flag in lib.mk, to include the selftest/ directory while
building.

Link: https://lkml.kernel.org/r/20250830163949.20952-2-reddybalavignesh9979@gmail.com
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Suggested-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Günther Noack <gnoack@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mickael Salaun <mic@digikod.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Simon Horman <horms@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/lib.mk |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/lib.mk~selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh
+++ a/tools/testing/selftests/lib.mk
@@ -199,6 +199,8 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_m
 # Build with _GNU_SOURCE by default
 CFLAGS += -D_GNU_SOURCE=
 
+CFLAGS += -I${top_srcdir}/tools/testing/selftests
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
_

Patches currently in -mm which might be from reddybalavignesh9979@gmail.com are

selftests-centralise-maybe-unused-definition-in-kselftesth.patch
selftests-proc-mark-vsyscall-strings-maybe-unused.patch
selftests-centralize-include-path-for-kselftesth-and-kselftest_harnessh.patch
selftests-replace-relative-includes-with-non-relative-for-kselftesth-and-kselftest_harnessh.patch

