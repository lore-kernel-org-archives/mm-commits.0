Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F405A28E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628220; cv=none; b=k1OslCxSuZhZ6NP2PkiTg5eT/IK6KRknT5n4J7AGEOtP+piKB8YBKHFoTe318fcZTyCcC34xj5vCvzBfx2OPpCYSPCeP1kfvej9bF75rloL3djDlEptac1gex7qelTCnG7INuxW6BdquAnjjXb82SPE6zYw1xXPwtqPrRxQJKrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628220; c=relaxed/simple;
	bh=zN9lub4ZappE+PxTLwpTqAPTLjJ8In6dpKRy0iSJyB4=;
	h=Date:To:From:Subject:Message-Id; b=QS7pG5UQv/t2oSasC12TQ+iSwzLbo6o+WJZtSlvCgI2zCrynkWDykRa2MgeMqBZvKp44lIEOhrlngGe2AmxGnrh4zZrhz3/gMuhmK+oAiKnz/peEQSS18RegRneCgLirCsugLhtYbTm11/EwM2PFDltrcT0Z1dfTf3ukOiHM1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BXg7TO5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BXg7TO5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFA7C116B1;
	Sat, 29 Jun 2024 02:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628219;
	bh=zN9lub4ZappE+PxTLwpTqAPTLjJ8In6dpKRy0iSJyB4=;
	h=Date:To:From:Subject:From;
	b=BXg7TO5lqVZ8ykMv3opLoBd5+aDnYttfnCN5jSSoc3nU2ZEHSG5CCL8GnVcJs0+kH
	 +pmANw4ewudDhZk8wvdp+xNikws0ktX3QCWVMnjbo58NDyPsVWRlBZg5OY9Uc1jTyO
	 iBfzC28MHlz32gBRXj5I8DmrCVNLQZQwuu6Gf+4w=
Date: Fri, 28 Jun 2024 19:30:19 -0700
To: mm-commits@vger.kernel.org,mripard@kernel.org,bmasney@redhat.com,javierm@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch removed from -mm tree
Message-Id: <20240629023019.CBFA7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/Kconfig: mention arm64 in DEFAULT_MMAP_MIN_ADDR symbol help text
has been removed from the -mm tree.  Its filename was
     mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Javier Martinez Canillas <javierm@redhat.com>
Subject: mm/Kconfig: mention arm64 in DEFAULT_MMAP_MIN_ADDR symbol help text
Date: Wed, 19 Jun 2024 10:30:38 +0200

Currently ppc64 and x86 are mentioned as architectures where a 65536 value
is reasonable but arm64 isn't listed and it is also a 64-bit architecture.

The help text says that for "arm" the value should be no higher than 32768
but it's only talking about 32-bit ARM.  Adding arm64 to the above list
can make this more clear and avoid confusing users who may think that the
32k limit would also apply to 64-bit ARM.

Link: https://lkml.kernel.org/r/20240619083047.114613-1-javierm@redhat.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Brian Masney <bmasney@redhat.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-mention-arm64-in-default_mmap_min_addr-symbol-help-text
+++ a/mm/Kconfig
@@ -720,7 +720,7 @@ config DEFAULT_MMAP_MIN_ADDR
 	  from userspace allocation.  Keeping a user from writing to low pages
 	  can help reduce the impact of kernel NULL pointer bugs.
 
-	  For most ppc64 and x86 users with lots of address space
+	  For most arm64, ppc64 and x86 users with lots of address space
 	  a value of 65536 is reasonable and should cause no problems.
 	  On arm and other archs it should not be higher than 32768.
 	  Programs which use vm86 functionality or have some need to map
_

Patches currently in -mm which might be from javierm@redhat.com are


