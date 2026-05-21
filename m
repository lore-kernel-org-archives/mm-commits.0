Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E154E35AC0C
	for <mm-commits@vger.kernel.org>; Thu, 21 May 2026 23:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779405365; cv=none; b=I+uCqo+H5mQzLWDuGReIBusg0oevcIKrPW8cLCyNCptuJCp7/4BLhu9gWRWrw5o5uH1ViSWsxFqhlUAmabmLxeXGgabfqgaLJwFnujvPM0V5ofhs6X9mjs0QCpMHHGZreDZKl6ZVVGlCtxVQniL5G0ZL5PRLnSHizK01H2VY7UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779405365; c=relaxed/simple;
	bh=fKRsN3P8FW2pKsfDD0bo44Ikc1wD7iizjYJPfjlLgw8=;
	h=Date:To:From:Subject:Message-Id; b=R7DpUiO6dA2So4wQZmCEniklq79HtpkZSQkn+hbVps5+ZhDfsLNB5eplffA5vCVKDJ3R4TlE8G1rUyY6423nzIjxdW3N6WR/6702OVTg9sHWX2j8MUpbBl7feV1dlZdU6jIDmQQJ9Y8chf6h3AaBlvauUJGz6ORxkDQ/pu5EZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BQte9Z24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BQte9Z24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681121F000E9;
	Thu, 21 May 2026 23:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779405363;
	bh=Eg4Zk1CBUqZSPax5rnmGE0oQsFNyalYpTXsSwnhheKs=;
	h=Date:To:From:Subject;
	b=BQte9Z244F7tlKFsXazGlhbd4KlLFY72uKVzyrr7qoT32+ZT8PYOC0BJuzxO3NVpn
	 4lfTYUeJlcw5imaU1CQTY0C0ma+w1gHwCNnTb9PMDYAhmZi9kSxLo9LxbvNUQrQmll
	 qj0hhnbl6+ul3cHC76AYGlDg5fHU7XlwMpEgfGRg=
Date: Thu, 21 May 2026 16:16:03 -0700
To: mm-commits@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch removed from -mm tree
Message-Id: <20260521231603.681121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
has been removed from the -mm tree.  Its filename was
     kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix.patch

This patch was dropped because it was folded into kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
Date: Wed, 20 May 2026 20:21:29 +0200

move and reword sentence on simultaneous normal/remote collection

Link: https://lore.kernel.org/20260520-kcov-docs-v2-1-819f78778763@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Suggested-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kcov.rst |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kcov.rst~kcov-allow-simultaneous-kcov_enable-kcov_remote_enable-fix-fix
+++ a/Documentation/dev-tools/kcov.rst
@@ -237,6 +237,9 @@ Both ``kcov_remote_start`` and ``kcov_re
 collection sections. The way a handle is used depends on the context where the
 matching code section executes.
 
+A thread can use two separate KCOV instances to collect remote coverage and
+normal coverage at the same time.
+
 KCOV supports collecting remote coverage from the following contexts:
 
 1. Global kernel background tasks. These are the tasks that are spawned during
@@ -246,8 +249,6 @@ KCOV supports collecting remote coverage
 2. Local kernel background tasks. These are spawned when a userspace process
    interacts with some kernel interface and are usually killed when the process
    exits (e.g. vhost workers).
-   This can be combined with another KCOV instance that is configured for normal
-   coverage collection.
 
 3. Soft interrupts.
 
_

Patches currently in -mm which might be from jannh@google.com are

kcov-refactor-common-handle-id-into-kcov_common_handle_id.patch
kcov-allow-simultaneous-kcov_enable-kcov_remote_enable.patch

