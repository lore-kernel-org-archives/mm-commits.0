Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62D0367F59
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622910; cv=none; b=fu05/Jx72Gm41ChEyzkGYlBxqbt5AS9nMYWjgIW0cNntLQYAxlzZLy5BWOBCxM+FCNaKhkOR7icC8HU+1CKsNYInbi+O+vpJA99pMCCMsXAA9MninpmXrhITQNyxQflHjcxvBnT1S6PI6jmqVEW2y5iFmXT9wYKwEJnlcYmfbZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622910; c=relaxed/simple;
	bh=o6a5CE0iO6xfXIq1Scnub84CDJkcvCts53rhZuW8OZY=;
	h=Date:To:From:Subject:Message-Id; b=ig3lVG7aGldZkq4Sv/E9Q9es+QQ6yhWDfx41tA3OGmW5og1ne4gX8D+A5BORLmLu5/YridW2M1QIdhJNzJJCrLXixD7I9NjjvCkd9nQ/mxI/CwYIBKKjYcxitAC2PNyCT++XvH1zNJFjlPGz9RMdE2XLUyrag5HCCIv233sqW4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VO6d19hE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VO6d19hE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7716C1F000E9;
	Tue, 25 Aug 2026 01:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622909;
	bh=PozVqsh27aZ/RnmaMZFAVsa1QPhmgWDyjic3AUhcsS8=;
	h=Date:To:From:Subject;
	b=VO6d19hE4nIn3kIqd43hV4ipkRcZ7pSIog8cUuLG6wXh1ibH19ZJAKAkItYNGqwWZ
	 Mthgp9Y/SfkSrKYUiljju+nCbo/wSavCtqfZ7h5lIDqCrjRlw2Twe7dPTUf1w+RwV9
	 kThCzmHQGe/jtZR3GkctUbpQVjm8L6qTXZTg4GMA=
Date: Mon, 24 Aug 2026 18:55:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch removed from -mm tree
Message-Id: <20260825015509.7716C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: kmemleak: document the conditional min_unref_scans default
has been removed from the -mm tree.  Its filename was
     documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: Documentation: kmemleak: document the conditional min_unref_scans default
Date: Fri, 31 Jul 2026 03:13:05 -0700

min_unref_scans now defaults to 2 when CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and
CONFIG_DEBUG_KMEMLEAK_VERBOSE are both enabled, but the documentation
still states that the default is unconditionally 1.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-2-7b9689ac77cb@debian.org
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

 Documentation/dev-tools/kmemleak.rst |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/dev-tools/kmemleak.rst~documentation-kmemleak-document-the-conditional-min_unref_scans-default
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -198,11 +198,13 @@ systems, because of pointers temporarily
 stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
 the minimum age of an object to be reported as a memory leak.
 
-The ``min_unref_scans`` module parameter (default 1) requires an object to
-be seen unreferenced in that many consecutive scans before it is reported.
-Keeping it at 1 preserves the historical behaviour; higher values filter
-the transient false positives described above, at the cost of delaying
-genuine reports by up to that many scans. It can be set at boot with
+The ``min_unref_scans`` module parameter requires an object to be seen
+unreferenced in that many consecutive scans before it is reported. It
+defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+periodic scan thread confirms a leak on its own, and to 1 otherwise. A
+value of 1 preserves the historical behaviour; higher values filter the
+transient false positives described above, at the cost of delaying genuine
+reports by up to that many scans. It can be set at boot with
 ``kmemleak.min_unref_scans=<n>`` or at run-time via
 ``/sys/module/kmemleak/parameters/min_unref_scans``.
 
_

Patches currently in -mm which might be from leitao@debian.org are


