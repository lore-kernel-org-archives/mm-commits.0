Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE472F6916
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023167; cv=none; b=oQjR7QT2rkcxYlJoj2ZRXWzRbvoJ+tJdXiZIF8Bcn+6Ef2eVD33k5PG3uqB9RHqS2bu11IP59dnWhLEvTguKX6R/ze+uh/12NxIsdgOrjWiJcr4Z7w8r2WghgCfVm80GH9Rr4HP2PpcZ4N8XDZWxoZICb9qZUWn7JRf3xyoS6BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023167; c=relaxed/simple;
	bh=wOhfAo6ckZ0teHMIIYR1C+AFWxzOwV/dywXAGCO8W9E=;
	h=Date:To:From:Subject:Message-Id; b=S46alZ/HLanSLcH28lh1yMVVcOqNKdv2VtSdqkJZ5COIzVDchK9Ci5fVJPzP+88dzB6RgcTfRcITmZoNC6JoJ0/tg4gKeGw3TqMFJFThprDM+2NDPQHFo1nh2jiftI9XfvGcggWqxZ9pmwbK+bTVlS1M+IkbnRJOf3VfLkCc9wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W26AIEzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W26AIEzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA40C4CEF1;
	Mon, 24 Nov 2025 22:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023165;
	bh=wOhfAo6ckZ0teHMIIYR1C+AFWxzOwV/dywXAGCO8W9E=;
	h=Date:To:From:Subject:From;
	b=W26AIEzT0vCFtRz58EnepKAS5sMgTKGIAJajK2dq7f5QlpxZqeHfJGD5FbUvhuWAZ
	 KOoGgeO0QIP8a9BMspkiMY4TdbZxm+DXuvtKxJ9wADqe6+gLZU5O7mVcEHDHpzgBht
	 Is9f7Npow/QDLM/3zUtBXBIk6/l/l0R+c92kr8+Y=
Date: Mon, 24 Nov 2025 14:26:05 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-test_kho-to-khos-entry.patch removed from -mm tree
Message-Id: <20251124222605.9DA40C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add test_kho to KHO's entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-test_kho-to-khos-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pratyush Yadav <pratyush@kernel.org>
Subject: MAINTAINERS: add test_kho to KHO's entry
Date: Tue, 18 Nov 2025 19:24:15 +0100

Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
KHO test but missed adding it to KHO's MAINTAINERS entry.  Add it so the
KHO maintainers can get patches for its test.

Link: https://lkml.kernel.org/r/20251118182416.70660-1-pratyush@kernel.org
Fixes: b753522bed0b7 ("kho: add test for kexec handover")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-test_kho-to-khos-entry
+++ a/MAINTAINERS
@@ -13798,6 +13798,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	kernel/kexec_handover.c
+F:	lib/test_kho.c
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
_

Patches currently in -mm which might be from pratyush@kernel.org are

kho-free-chunks-using-free_page-instead-of-kfree.patch
test_kho-always-print-restore-status.patch

