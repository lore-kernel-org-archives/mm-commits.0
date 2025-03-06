Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51D19E98D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239443; cv=none; b=E4SibeBOstGyKglHtPVdOnCpdtyZt0ek+Mu5p69I8QMitohobh6/pnz4jBPl2CjBIDvSzZiMICE5BcmfCzpOmQ/+rma9mdbNzl0cHk9jOIrsvRJxHR6yKck9u9uePPbqYlSdTrvb1agAl0cxZa0f7brDGoRc2ammuysjzkOh63k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239443; c=relaxed/simple;
	bh=PlrXsG/XH9FWQY9dusNrEjVWmcKX6qbngLRkrS9NFM4=;
	h=Date:To:From:Subject:Message-Id; b=G+yJ6oSUHwx4KJKDCSVOLBQR9VHyilEW75s/1lrDU5if6kYtXcDkHfnsx9TlbjYqOvrNZEJ+EVobd/e2sS1fJ2gNIPc6VDTFYYKFI4odTsuX7LjhWi5wNDzdtdnyf63bkVM5iwa0I9G81ZBydGwM/6LTGUy/VE7LPL3nUyrhXeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ao8ckUUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ao8ckUUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72781C4CEE5;
	Thu,  6 Mar 2025 05:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239443;
	bh=PlrXsG/XH9FWQY9dusNrEjVWmcKX6qbngLRkrS9NFM4=;
	h=Date:To:From:Subject:From;
	b=Ao8ckUUG5bZFgCufYC6k/uk1xLgj3vRIBJ6wwdkpRYJgr9HA/alAj2eoBiGqeY1NG
	 YiH1OqLsUxDT7Hk2lAJiXguwAvzlFM3GiAaXLfB0CaN02nMgHRx7oK3l9Mg+11fNfV
	 CkHk0asIsdNsmo23nWkoqG8d2TDYE+iHt80C4Kuk=
Date: Wed, 05 Mar 2025 21:37:22 -0800
To: mm-commits@vger.kernel.org,ujwal.kundur@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] documentation-fix-doc-link-to-fault-injectionrst.patch removed from -mm tree
Message-Id: <20250306053723.72781C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: fix doc link to fault-injection.rst
has been removed from the -mm tree.  Its filename was
     documentation-fix-doc-link-to-fault-injectionrst.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Documentation: fix doc link to fault-injection.rst
Date: Sat, 15 Feb 2025 16:21:07 +0530

Fix incorrect reference to fault-injection docs

Link: https://lkml.kernel.org/r/20250215105106.734-1-ujwal.kundur@gmail.com
Signed-off-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug~documentation-fix-doc-link-to-fault-injectionrst
+++ a/lib/Kconfig.debug
@@ -2103,7 +2103,7 @@ config FAIL_SKB_REALLOC
 	  reallocated, catching possible invalid pointers to the skb.
 
 	  For more information, check
-	  Documentation/dev-tools/fault-injection/fault-injection.rst
+	  Documentation/fault-injection/fault-injection.rst
 
 config FAULT_INJECTION_CONFIGFS
 	bool "Configfs interface for fault-injection capabilities"
_

Patches currently in -mm which might be from ujwal.kundur@gmail.com are

selftests-mm-fix-spelling.patch

