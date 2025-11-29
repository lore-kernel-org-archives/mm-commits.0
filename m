Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5C7FBA2
	for <mm-commits@vger.kernel.org>; Sat, 29 Nov 2025 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764441713; cv=none; b=nNoXQgXY3zayLuQhEQ1f5PyrgyI9zNHfuQJTBFuMTi6G43QOOYqSbKtK5qBF763WSe8LWVwfO4NyfEcOIv05EwPMQT6HnZgrqaSEVv2CEtWe/guuyMnmCwztysYNS3DnHHZnyM5uhh4lrBKl3wCJVrCqh+Sa2ELKf+3+QYGaXiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764441713; c=relaxed/simple;
	bh=eW9MVEbeulsS9CrE7RjkTMHYqlVFLopM3wAU56U26TY=;
	h=Date:To:From:Subject:Message-Id; b=A1l9PiKZTZflewtqwRKmCS677OBSzOrpdh1QivNHcRjNFpjATAqLrO4O3jzm+/t3fzViwgxvQLLqplXhQ3YW7dql9B3TbJ6yGKImA2ky2R/bMoLqAiE2BGz0bFNqq5O9jm1/x+K5hruT8IIl2jfjWUogUyUpBWaeN8EaUmtK6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pUkO8PCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pUkO8PCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90977C4CEF7;
	Sat, 29 Nov 2025 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764441712;
	bh=eW9MVEbeulsS9CrE7RjkTMHYqlVFLopM3wAU56U26TY=;
	h=Date:To:From:Subject:From;
	b=pUkO8PCilHlKu7J7Xz57JzqprfmGt7+0HUdiTctokOhr8wl0+/lxp0cpNmNoTQOJ3
	 MQVWqVEvmYA27MBcRpi7zQc3ysOr0khHsUjy2gWIbFHkSWridJt6yaY91L07wWWMYd
	 +TBQ8sX2F/MmCH9HmmiPagkNnmrHA6HoKgEFRD2Q=
Date: Sat, 29 Nov 2025 10:41:51 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kees@kernel.org,jinb.park7@gmail.com,anshuman.khandual@arm.com,geert@linux-m68k.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-debug_rodata_test-indentation-in-kconfig.patch removed from -mm tree
Message-Id: <20251129184152.90977C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix DEBUG_RODATA_TEST indentation in Kconfig
has been removed from the -mm tree.  Its filename was
     mm-fix-debug_rodata_test-indentation-in-kconfig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm: fix DEBUG_RODATA_TEST indentation in Kconfig
Date: Tue, 25 Nov 2025 09:19:30 +0100

Most of the DEBUG_RODATA_TEST section is indented by four spaces instead
of the customary single TAB.

Link: https://lkml.kernel.org/r/74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org
Fixes: 2959a5f726f6 ("mm: add arch-independent testcases for RODATA")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jinbum Park <jinb.park7@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig.debug |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/Kconfig.debug~mm-fix-debug_rodata_test-indentation-in-kconfig
+++ a/mm/Kconfig.debug
@@ -175,10 +175,10 @@ config DEBUG_PAGE_REF
 	  nil until the tracepoints are actually enabled.
 
 config DEBUG_RODATA_TEST
-    bool "Testcase for the marking rodata read-only"
-    depends on STRICT_KERNEL_RWX
+	bool "Testcase for the marking rodata read-only"
+	depends on STRICT_KERNEL_RWX
 	help
-      This option enables a testcase for the setting rodata read-only.
+	  This option enables a testcase for the setting rodata read-only.
 
 config ARCH_HAS_DEBUG_WX
 	bool
_

Patches currently in -mm which might be from geert@linux-m68k.org are


