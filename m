Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E3523D297
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788657734; cv=none; b=L1VeIhKERI6HxHqa5GUY6hckFmEwvz3YnJxTpnXCi5C9R5AHK/29rltQs1T3Z0mP+gRBZwepJITTGCjoezUk+l9+V2QRM/XAjQByXAMMO1guIg7QVL4nkuiv46oUuzQ4A6Lg4jJm1GLlyzKiuKPn54zIrtNj4lkJasAHuMPjp4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788657734; c=relaxed/simple;
	bh=lVCqav/awqnljUWV8ighNZUn2erXX1sLNKfXu3uXhG4=;
	h=Date:To:From:Subject:Message-Id; b=t/eKfs5xLgca+rX3IQokoBNlkUcT8FOG/OUppoaMxzIF0CqaV5z6PM4dANQvevsX9yNoUjidhWEHY+nK/t49WgpGQjY2i+gbP0raGPCpP4uYkUouunWmMxUwx/oYbPrKD8f+Vfj7xCKsQ6mZGM0eZ6wX+uivOJSOdaumsLpp66c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S9+rQXZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S9+rQXZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDB41F00A3D;
	Sun,  6 Sep 2026 01:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788657732;
	bh=mOWaO1g0P3sn7p36Ne7yytSL0de/NzLkAsZXJ5BHboY=;
	h=Date:To:From:Subject;
	b=S9+rQXZla/d2RErYzVZUi1Vfjn15I0q3P4PAt+3SWuCWfDcC0aP6bbDOC5H98solF
	 0YbQ6kaGh880q00AakZyxJW39M5aol6hog7Badq6I1sWJbplqHxlMLbXXmy93KVdbn
	 fFa5wDp+t58B/AmLTfM22lAKEKWp0uU3WCZXPDBA=
Date: Sat, 05 Sep 2026 18:22:12 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch added to mm-nonmm-unstable branch
Message-Id: <20260906012212.6EDB41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: ignore <inttypes.h> format macros for userspace tools
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: ignore <inttypes.h> format macros for userspace tools
Date: Fri, 4 Sep 2026 13:02:28 +0200

Constants from <inttypes.h> are used only in userspace tools, they are
from ISO C99, let's don't report it:

    arch/mips/boot/tools/relocs.c:572: CHECK: Avoid CamelCase: <PRIx32>
    arch/s390/tools/relocs.c:52: CHECK: Avoid CamelCase: <PRIu64>
    tools/testing/selftests/mm/vm_util.c:244: CHECK: Avoid CamelCase: <SCNu64>

Link: https://lore.kernel.org/20260904110230.1219037-3-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-ignore-inttypesh-format-macros-for-userspace-tools
+++ a/scripts/checkpatch.pl
@@ -5950,6 +5950,8 @@ sub process {
 #Ignore SI style variants like nS, mV and dB
 #(ie: max_uV, regulator_min_uA_show, RANGE_mA_VALUE)
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
+#Ignore <inttypes.h> format macros (e.g. PRIu64, SCNu64)
+			    (is_userspace($realfile) ? $var !~ /^(?:PRI|SCN)[dioux][A-Z0-9]+$/ : 1) &&
 #Ignore some three character SI units explicitly, like MiB and KHz
 			    $var !~ /^(?:[a-z_]*?)_?(?:[KMGT]iB|[KMGT]?Hz)(?:_[a-z_]+)?$/) {
 				while ($var =~ m{\b($Ident)}g) {
_

Patches currently in -mm which might be from pvorel@suse.cz are

checkpatch-skip-camelcase-cache-for-no-tree-without-root.patch
checkpatch-add-more-userspace-directories-to-is_userspace.patch
checkpatch-ignore-inttypesh-format-macros-for-userspace-tools.patch
checkpatch-add-userspace-to-force-userspace-rules.patch
checkpatch-skip-kernel-specific-checks-for-userspace.patch

