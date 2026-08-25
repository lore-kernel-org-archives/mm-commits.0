Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D4F34E777
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622909; cv=none; b=YSRX5MRt3FS1FKQA9G/jlPhOsADYGdSEmxTcpwhI7njZwVq/DYq4/KrEbiwaEZmvilZZl/EfE9icydSncKtGoFqggLKgcm7XZrb5UC2A3Keid/dar3dCRMkoHXY1nKB5oeojdcrv0JVdO6IsugFbdS9w2Ehmtw1Hm49OY4/Skbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622909; c=relaxed/simple;
	bh=yo73iPLmDgn0kz3rLpaTdUY4AeSJ0gNVJh6phxUO2w0=;
	h=Date:To:From:Subject:Message-Id; b=SO6wqTk7t0hUGpKq5YLI6//bsAW78ork3SfLHEpY4vxeZQ8iG3haFmasmDWOM6sB8c2816YKD29fLwzI6fveMkg/TPW/bVI82cOx4hhBaaqet0tghBp+xfaYxwdhMM1PakS7TAljbhC7xUO5DOCYYfEEwH1wtzPpiO1uXK1BUfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0ulKnLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0ulKnLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489AA1F00A3A;
	Tue, 25 Aug 2026 01:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622908;
	bh=6NIZ19zewXyHkIsrgxCVbXIkWO18bSEdXX8S/FAfrfQ=;
	h=Date:To:From:Subject;
	b=x0ulKnLwWNEHvsXikYq8l9K+uZlUQl9mc3jHUailFLLMxCsS3HCVoNNtdaPf/59Ws
	 Jk0/JWABBYbGEaWGrjL0Iicg0CLtPQltI1BlABrEsKcyPA640zsz/7yI7HC8bgjHn8
	 iel3JYJ3WWT62ve6L6Lz4dDwGcSIXdo/RcYg601Q=
Date: Mon, 24 Aug 2026 18:55:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch removed from -mm tree
Message-Id: <20260825015508.489AA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
Date: Fri, 31 Jul 2026 03:13:04 -0700

Patch series "mm: kmemleak: default min_unref_scans to 2 for verbose
kernels", v2.

When CONFIG_DEBUG_KMEMLEAK_VERBOSE is set, which means the host is in
auto scan mode, set min_unref_scans to 2, avoiding false positives.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it already runs the scan thread periodically and
the user has asked for detailed leak reports.

The confirming second scan comes for free there, so default
min_unref_scans to 2 in that case and keep it at 1 everywhere else.
CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so nothing changes for
kernels that do not opt in.

The other two patches bring the documentation and the selftest comments
in line with the new conditional default.

PS: A similar patch (v1 of this patchset) is applied to Meta's kernel,
in real production hosts.


This patch (of 3):

min_unref_scans defers reporting an object as leaked until it has stayed
unreferenced for that many consecutive scans, filtering out objects that
are only transiently unreferenced during a scan.

It defaults to 1, which reports on the first unreferenced scan.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it runs the scan thread periodically and the user
has opted into detailed leak reporting.  A second confirming scan then
happens on its own.

Default min_unref_scans to 2 there to suppress transient false positives,
and keep it at 1 otherwise, where a manually triggered scan is expected to
report immediately.  The value stays writable through the module
parameter.

CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so this does not change the
default for kernels that do not opt in.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org
Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-1-7b9689ac77cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan
+++ a/mm/kmemleak.c
@@ -237,7 +237,8 @@ static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
-static unsigned int min_unref_scans = 1;
+static unsigned int min_unref_scans =
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
_

Patches currently in -mm which might be from leitao@debian.org are


