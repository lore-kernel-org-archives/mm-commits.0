Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC12C029D
	for <mm-commits@vger.kernel.org>; Mon, 22 Dec 2025 17:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766425212; cv=none; b=htfYei4yUxDbUPzI58cDdgHVEavcnDdkwdc30Uvx8y7zaOcZqhQR6bkM8oylNueXGjl4zED5Sp+vKy3bS6uiv8jXHAWK0ED1aXaf9v/pC/a1/HdillCZu4G+yFUZp7V5tjUhPHUAGA1lDvzpa7Tw7gLWOzWZXpkd9O+RQn1/RSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766425212; c=relaxed/simple;
	bh=mLwZYRPzRNCPB7oZGbmVODBgNQRlOG3WDb2oHcAEufw=;
	h=Date:To:From:Subject:Message-Id; b=udIIFEmQBXJw8IYTgYL9cnxGbz1zVAjcWNGX6qErblaGmkgHuh1OP7LOLvtrmpeAn2K/Xt6+z2MqRnjkWjiKvZvsL/wAK+Zn/cnZJo72dIo5x/iCnui8bfmBivv6gtVNLDt0JfEmOIHgXe/KAmwNzPJ5XM3If9xc5LTX4RIf/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USm7F3M2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USm7F3M2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F89C4CEF1;
	Mon, 22 Dec 2025 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766425212;
	bh=mLwZYRPzRNCPB7oZGbmVODBgNQRlOG3WDb2oHcAEufw=;
	h=Date:To:From:Subject:From;
	b=USm7F3M2CZuqb/bbmdtNNbn9T+gM5Q7ABrvwHzXA1h5vYvtgNrirXaEf8IK1u5kF5
	 cOeLvcYsMh688tMdDx5a9J2QO30LQPma870sAcgLsspsT7/az/XQ5HuBXcCD9ocFGQ
	 QZKVF+TAs8p2jkTW0vtvB+YBMo6PzQIvYz7USdE8=
Date: Mon, 22 Dec 2025 09:40:11 -0800
To: mm-commits@vger.kernel.org,glider@google.com,dvyukov@google.com,corbet@lwn.net,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-kernel-parameters-add-kfence-parameters.patch added to mm-hotfixes-unstable branch
Message-Id: <20251222174011.E5F89C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: kernel-parameters: add kfence parameters
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-kernel-parameters-add-kfence-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-kernel-parameters-add-kfence-parameters.patch

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
From: Marco Elver <elver@google.com>
Subject: docs: kernel-parameters: add kfence parameters
Date: Mon, 22 Dec 2025 16:00:06 +0100

Add a brief summary for KFENCE's kernel command-line parameters in
admin-guide/kernel-parameters.

Link: https://lkml.kernel.org/r/20251222150018.1349672-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   35 ++++++++++++++
 1 file changed, 35 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~docs-kernel-parameters-add-kfence-parameters
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -2917,6 +2917,41 @@ Kernel parameters
 			for Movable pages.  "nn[KMGTPE]", "nn%", and "mirror"
 			are exclusive, so you cannot specify multiple forms.
 
+	kfence.burst=	[MM,KFENCE] The number of additional successive
+			allocations to be attempted through KFENCE for each
+			sample interval.
+			Format: <unsigned integer>
+			Default: 0
+
+	kfence.check_on_panic=
+			[MM,KFENCE] Whether to check all KFENCE-managed objects'
+			canaries on panic.
+			Format: <bool>
+			Default: false
+
+	kfence.deferrable=
+			[MM,KFENCE] Whether to use a deferrable timer to trigger
+			allocations. This avoids forcing CPU wake-ups if the
+			system is idle, at the risk of a less predictable
+			sample interval.
+			Format: <bool>
+			Default: CONFIG_KFENCE_DEFERRABLE
+
+	kfence.sample_interval=
+			[MM,KFENCE] KFENCE's sample interval in milliseconds.
+			Format: <unsigned integer>
+			 0 - Disable KFENCE.
+			>0 - Enabled KFENCE with given sample interval.
+			Default: CONFIG_KFENCE_SAMPLE_INTERVAL
+
+	kfence.skip_covered_thresh=
+			[MM,KFENCE] If pool utilization reaches this threshold
+			(pool usage%), KFENCE limits currently covered
+			allocations of the same source from further filling
+			up the pool.
+			Format: <unsigned integer>
+			Default: 75
+
 	kgdbdbgp=	[KGDB,HW,EARLY] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
_

Patches currently in -mm which might be from elver@google.com are

docs-kernel-parameters-add-kfence-parameters.patch

