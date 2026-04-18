Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4688934F48E
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499175; cv=none; b=KfN3njQxupaRC3DIPzGJemC0lZgCz1tDzwo+gh2yvGsuMKOPFFX8yCmvXO1wkwmezzLLTx/jL/UBpFzcAXM/QqOdZZpatiADNCC2vdJjO5D4Cl5x/p+e+4mdiwQujJMkP8Yw88rYgBVp1I+hNa3zJ8JfQiROALuv1xLBJ8Xj0Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499175; c=relaxed/simple;
	bh=2udk+rkDaLRD4m1lZpFQdyReoSp8cKJa1fyxXBC56bo=;
	h=Date:To:From:Subject:Message-Id; b=Ll9coTwdrThExgyjb20Urrpfhz27GeLYL9hQrWiVV4SKYAG+Bc7fmry3qpoG/sDzNg3SM3Z3TqUP8+U14EFuCG1UFtg03OlkM/IoX9cTKmglwUM9M2Vk4mykHwtOMQ5ZM004I87Ya2Izl4Xw/4HgIlfwstdvS8LqRxsYdkFMzMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1gPV/Uzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1gPV/Uzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50894C19424;
	Sat, 18 Apr 2026 07:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499175;
	bh=2udk+rkDaLRD4m1lZpFQdyReoSp8cKJa1fyxXBC56bo=;
	h=Date:To:From:Subject:From;
	b=1gPV/UzqL8dGPgyBnbgFFMONH7MLC6yXJPqBsv9auWfqiY+bTeg4YAIhG0/3ctT/v
	 5vwgwNAQlzaZTrvZ3tmmovzBDhzaI/o2fB4tEeUWKvlYjkZXlcLdFvgH+TuBERVmum
	 1aviunRbNtn8NUMJA5WhZ7iBtSAN6MSPmmDDKADc=
Date: Sat, 18 Apr 2026 00:59:30 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,masahiroy@kernel.org,martink@posteo.de,magnus.karlsson@intel.com,kuba@kernel.org,diego.viola@gmail.com,broonie@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-update-kexec-kdump-maintainers-entries.patch removed from -mm tree
Message-Id: <20260418075934.50894C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update kexec/kdump maintainers entries
has been removed from the -mm tree.  Its filename was
     maintainers-update-kexec-kdump-maintainers-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: MAINTAINERS: update kexec/kdump maintainers entries
Date: Mon, 13 Apr 2026 12:11:46 +0000

Update KEXEC and KDUMP maintainer entries by adding the live update group
maintainers.  Remove Vivek Goyal due to inactivity to keep the MAINTAINERS
file up-to-date, and add Vivek to the CREDITS file to recognize their
contributions.

Link: https://lore.kernel.org/20260413121146.49215-1-pasha.tatashin@soleen.com
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

liveupdate-fix-return-value-on-session-allocation-failure.patch

