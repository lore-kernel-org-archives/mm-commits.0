Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065BF282F33
	for <mm-commits@vger.kernel.org>; Tue, 14 Apr 2026 05:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776144059; cv=none; b=TCRi1CmI2OdxFN3sQWzpAcFpy6ut5QfUQKsXeKvuILiE2NoTFdM1lrNsvCvXexKkH/v0H58ya9f/+REHbvSINF+cTZXp2w5Mk5cgSt8T78TIX3LThMRVt+F7wnZJtPDFrMet7fto7lCeN2o4xf/RPXhgpsHXPysFqvKXVzB+dUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776144059; c=relaxed/simple;
	bh=rvNMYLXNg6rv/lh3litkzslybcdpsARN0v4U45k62uk=;
	h=Date:To:From:Subject:Message-Id; b=ciKT5rNCAqlE26+DcMgZZtcL31p/Y5aQb1R6wDkn6R1ny3UmakgvENbLo55Nq8Ej9+X00ac8mItSxrrnKMvTgZDdoXf8jP7BvSJYoUNceQRhwPZpDikJFi5ZK/mhCh0oAelTzpJQhZi604UXL0HDQx6tY1sASdoPdmN5slA+Htk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bNCFZMhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bNCFZMhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8659C19425;
	Tue, 14 Apr 2026 05:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776144058;
	bh=rvNMYLXNg6rv/lh3litkzslybcdpsARN0v4U45k62uk=;
	h=Date:To:From:Subject:From;
	b=bNCFZMhiEtoZqFqIdRikPs7gZWjrZsEyK4v03v9qVftYbCJ04Ev2OOfGM/4Gmq4Yc
	 X6a4kP2teefPjmDXYijW9cEFwpDIG6vw88cBdcaFXI1A2Bm4CEpEz6lG29HXu0maBm
	 E6wv1NIbZpKJeelOd+aMU7HaKIi7mSsYOgdHjbPk=
Date: Mon, 13 Apr 2026 22:20:53 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,masahiroy@kernel.org,martink@posteo.de,magnus.karlsson@intel.com,kuba@kernel.org,diego.viola@gmail.com,broonie@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-kexec-kdump-maintainers-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20260414052057.B8659C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update kexec/kdump maintainers entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-kexec-kdump-maintainers-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-kexec-kdump-maintainers-entries.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: MAINTAINERS: update kexec/kdump maintainers entries
Date: Mon, 13 Apr 2026 12:11:46 +0000

Update KEXEC and KDUMP maintainer entries by adding the live update group
maintainers.  Remove Vivek Goyal due to inactivity to keep the MAINTAINERS
file up-to-date, and add Vivek to the CREDITS file to recognize their
contributions.

Link: https://lkml.kernel.org/r/20260413121146.49215-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Diego Viola <diego.viola@gmail.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/CREDITS~maintainers-update-kexec-kdump-maintainers-entries
+++ a/CREDITS
@@ -1456,6 +1456,10 @@ N: Andy Gospodarek
 E: andy@greyhouse.net
 D: Maintenance and contributions to the network interface bonding driver.
 
+N: Vivek Goyal
+E: vgoyal@redhat.com
+D: KDUMP, KEXEC, and VIRTIO FILE SYSTEM
+
 N: Wolfgang Grandegger
 E: wg@grandegger.com
 D: Controller Area Network (device drivers)
--- a/MAINTAINERS~maintainers-update-kexec-kdump-maintainers-entries
+++ a/MAINTAINERS
@@ -13786,7 +13786,9 @@ F:	scripts/Makefile.kcsan
 KDUMP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Baoquan He <bhe@redhat.com>
-R:	Vivek Goyal <vgoyal@redhat.com>
+M:	Mike Rapoport <rppt@kernel.org>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Pratyush Yadav <pratyush@kernel.org>
 R:	Dave Young <dyoung@redhat.com>
 L:	kexec@lists.infradead.org
 S:	Maintained
@@ -14102,6 +14104,9 @@ F:	include/linux/kernfs.h
 KEXEC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Baoquan He <bhe@redhat.com>
+M:	Mike Rapoport <rppt@kernel.org>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 F:	include/linux/kexec.h
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

maintainers-update-kexec-kdump-maintainers-entries.patch
liveupdate-prevent-double-management-of-files.patch
memfd-implement-get_id-for-memfd_luo.patch
selftests-liveupdate-add-test-for-double-preservation.patch
liveupdate-safely-print-untrusted-strings.patch
liveupdate-synchronize-lazy-initialization-of-flb-private-state.patch
liveupdate-protect-file-handler-list-with-rwsem.patch
liveupdate-protect-flb-lists-with-luo_register_rwlock.patch
liveupdate-defer-flb-module-refcounting-to-active-sessions.patch
liveupdate-remove-luo_session_quiesce.patch
liveupdate-auto-unregister-flbs-on-file-handler-unregistration.patch
liveupdate-remove-liveupdate_test_unregister.patch
liveupdate-make-unregister-functions-return-void.patch
liveupdate-defer-file-handler-module-refcounting-to-active-sessions.patch

