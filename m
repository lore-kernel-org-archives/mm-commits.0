Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540206;
	b=jqVqJzbtOz1FMCazOaxObUbqhuq8OgovtCdgWxRlsdUAWGCl3uZtmunNPxR5wcTuH8CR
	 4JVQM1y/ZeIq7v7+prdPGKorc1RPWc3S0ZYI4p7UsycEozcmH9OsX5clBDLvV4mtTBB0s
	 qbDRcmbSpteBQf7w/+JmeJtc/yDWNjINhm22iosDPpm0gPIKXI+Jnyfbcm21G3/i7DrNq
	 opzg2HyTUXIdRh5cffpxAsD83gYSjMr+3v6aAbE7+brPat6E4m1/1cM/OsDOe8ekj6Zu1
	 spabR31mgBRZks6LUYQ9Gp37YxewtQyfAgL45v5hYOZSouwIk7KsupSPqI3d/+2jyTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540206;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=dt79lmLXpJlWuU1T6Hej8BujHea3zOuIrAz1GVd+2ds=;
	b=28Tv/n8KTpOSFtciUqUAhKrjxY5xDQfVlnE5ehd7ZrUmegZSO42W4ac8kGwG1Q9eW8Z8
	 nlzBZT+dxRI3i/bpXa06zGEveGrcJ68eFgDqq0vERzuZ4EQ+M3/lzq0J2YIQ2Zaa0kNfQ
	 V/2eLTT3yv452aCF8GxQ/EQ5kfaB7fCLwfxSihUIlMxdZt+ZWdcfkAd9BZrK8aVC/Ywm0
	 J7+LWEEe8XIYVLXaFSbVoKbK4IaeUlrWxQ5LXP+e6eNdiqsvF3JTVMRncpK4T8TwPI/3F
	 Sj2O39Sqp0Ho8sVSYCatlpcFutag28iQyd0PiM2esYiqQ8RYgn+jpv43OB8jZVTASvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MU+qddei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0763606A330
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MU+qddei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD17D1F0089E;
	Tue, 24 Nov 2026 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540205;
	bh=dt79lmLXpJlWuU1T6Hej8BujHea3zOuIrAz1GVd+2ds=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=MU+qddeidjOFMUZgT4V2GHy0IjBHnN+o06VQIWQSyr7Zn6T/E0eT8iyiSRc5WKy/w
	 bbbU0T/QbUcPJBpU5rRr1lcoIhWbDwmoNEtwWA69u3dG700HUfT3wU+A2BVXxzeVqC
	 yaASf1esAixfIOEKOMGhevc0BoN1sA52I1VHLEhI=
Date: Tue, 24 Nov 2026 09:10:05 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,
	rdunlap@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124160124.93482-2-sj@kernel.org>
References: <20261124160124.93482-2-sj@kernel.org>
Subject: + maintainers-change-damon-scm-tree-to-mm-damongit.patch added to mm-unstable branch
Message-Id: <20261124171005.AD17D1F0089E@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: change DAMON SCM tree to mm/damon.git
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-change-damon-scm-tree-to-mm-damongit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-change-damon-scm-tree-to-mm-damongit.patch

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
From: SJ Park <sj@kernel.org>
Subject: MAINTAINERS: change DAMON SCM tree to mm/damon.git
Date: Tue, 24 Nov 2026 08:01:19 -0800

Patch series "mm/damon: update documents for mm-next onboarding".

Right after the 7.5-rc1 release, DAMON will onboard the mm-next transition
[1].  The major change is that it will use mm/damon.git [2] and
mm/linux.git [3] instead of sj/linux.git [4] and akpm/mm.git [5].

Update MAINTAINERS file to capture the change, via patch 1.  Further
update DAMON maintainer-profile document for the change, step by step, via
patches 2-4.


This patch (of 4):

Right after 7.5-rc1, DAMON will onboard the mm-next transition.  The
major change is that it will use mm/damon.git [2] as its SCM tree.
Update the DAMON subsystem SCM tree section on the MAINTAINERS file for
that.  Together, rename the section to have 'MEMORY MANAGEMENT - '
prefix, to be consistent with other mm components.  Because the name is
changed, move the section on the file to be alphabetically sorted.

Link: https://lore.kernel.org/20261124160124.93482-1-sj@kernel.org
Link: https://patch.msgid.link/20261124160124.93482-2-sj@kernel.org
Link: https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/ [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/ [2]
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>

 MAINTAINERS |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/MAINTAINERS~maintainers-change-damon-scm-tree-to-mm-damongit
+++ a/MAINTAINERS
@@ -7366,25 +7366,6 @@ S:	Maintained
 W:	https://docs.dasharo.com/
 F:	drivers/platform/x86/dasharo-acpi.c
 
-DAMON
-M:	SJ Park <sj@kernel.org>
-L:	damon@lists.linux.dev
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	https://damonitor.github.io
-P:	Documentation/mm/damon/maintainer-profile.rst
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
-F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
-F:	Documentation/admin-guide/mm/damon/
-F:	Documentation/mm/damon/
-F:	include/linux/damon.h
-F:	include/trace/events/damon.h
-F:	mm/damon/
-F:	samples/damon/
-F:	tools/testing/selftests/damon/
-
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 L:	netdev@vger.kernel.org
 S:	Orphan
@@ -17563,6 +17544,23 @@ F:	mm/vmstat.c
 F:	scripts/gdb/linux/mm.py
 N:	include\/linux\/page[-_][a-zA-Z]*
 
+MEMORY MANAGEMENT - DAMON
+M:	SJ Park <sj@kernel.org>
+L:	damon@lists.linux.dev
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	https://damonitor.github.io
+P:	Documentation/mm/damon/maintainer-profile.rst
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git for-next
+F:	Documentation/ABI/testing/sysfs-kernel-mm-damon
+F:	Documentation/admin-guide/mm/damon/
+F:	Documentation/mm/damon/
+F:	include/linux/damon.h
+F:	include/trace/events/damon.h
+F:	mm/damon/
+F:	samples/damon/
+F:	tools/testing/selftests/damon/
+
 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch

