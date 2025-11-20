Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC6723A9B3
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676260; cv=none; b=gFparNC49vKKzjWzLC6J+VNxJex3yxrrrpZ6GFYJRhpgTrnkrbFfqKzeosyVcIwyiQA2OyzdxAYOGR23pRjTcSkcdhyynot/cP2OAiSvDJYirO4f5dgosjmJZxgkU8eKCk94fHjgOHESGGFKfXoWoqoZEMXTDzg1ghx8YhaMv7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676260; c=relaxed/simple;
	bh=rwDxuWFAPKqa+DiE550NTsOwwwiCdX8cHhlELcd07EU=;
	h=Date:To:From:Subject:Message-Id; b=thqclpR7GRGxlZKNQGAO8g5S9mrc+DCGXx6vouRjKa8TXfR87Z9eMxFZE6pnRkWRdjczPGSjAxH4DEwYBSIWu2lSz9W7GARbL6LeYpy8NEVBwTly7q9uyLfwSdFSVDmIM71PuP9V6r6X5nUNzZkc4+ldHOBxHtNWow0fQ0VK0sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j4qyTVTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j4qyTVTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4551EC4CEF1;
	Thu, 20 Nov 2025 22:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676260;
	bh=rwDxuWFAPKqa+DiE550NTsOwwwiCdX8cHhlELcd07EU=;
	h=Date:To:From:Subject:From;
	b=j4qyTVTFWkIlom0FAjti6FE0KEu23hFRY26Iyf7uSoQ1jb0rrSAaPMBYbb22+F3wB
	 ZVDqPAP0KnK94tL+5CObuRqbT8TLGdJ26HarRuNeM0qpLzus4TPiAEns+P5hcN7qGZ
	 C3eAz3b/QfNjle7i57C1skOY2Dnf8BtgYtxX0PH8=
Date: Thu, 20 Nov 2025 14:04:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,dan.j.williams@intel.com,apw@canonical.com,clopez@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-idr-to-the-deprecated-list.patch removed from -mm tree
Message-Id: <20251120220420.4551EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add IDR to the deprecated list
has been removed from the -mm tree.  Its filename was
     checkpatch-add-idr-to-the-deprecated-list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: : Carlos López <clopez@suse.de>
Subject: checkpatch: add IDR to the deprecated list
Date: Fri, 31 Oct 2025 12:19:09 +0100

As of commit 85656ec193e9, the IDR interface is marked as deprecated in
the documentation, but no checks are made in that regard for new code. 
Add the existing IDR initialization APIs to the deprecated list in
checkpatch, so that if new code is introduced using these APIs, a warning
is emitted.

Link: https://lkml.kernel.org/r/20251031111908.2266077-2-clopez@suse.de
Signed-off-by: Carlos López <clopez@suse.de>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-idr-to-the-deprecated-list
+++ a/scripts/checkpatch.pl
@@ -860,6 +860,10 @@ our %deprecated_apis = (
 	"kunmap"				=> "kunmap_local",
 	"kmap_atomic"				=> "kmap_local_page",
 	"kunmap_atomic"				=> "kunmap_local",
+	#These should be enough to drive away new IDR users
+	"DEFINE_IDR"				=> "DEFINE_XARRAY",
+	"idr_init"				=> "xa_init",
+	"idr_init_base"				=> "xa_init_flags"
 );
 
 #Create a search pattern for all these strings to speed up a loop below
_

Patches currently in -mm which might be from clopez@suse.de are


